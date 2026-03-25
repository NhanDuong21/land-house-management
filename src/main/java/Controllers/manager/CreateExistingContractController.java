package Controllers.manager;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Date;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import DALs.auth.TenantDAO;
import DALs.room.RoomDAO;
import Models.authentication.AuthResult;
import Models.common.ServiceResult;
import Models.entity.Contract;
import Models.entity.Room;
import Models.entity.Tenant;
import Services.contract.ContractService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024, // 10MB
        maxRequestSize = 25 * 1024 * 1024 // 25MB
)
public class CreateExistingContractController extends HttpServlet {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final ContractService contractService = new ContractService();

    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(".jpg", ".jpeg", ".png", ".webp");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Tenant> tenants = tenantDAO.findActiveTenants();
        request.setAttribute("tenants", tenants);

        List<Room> rooms = roomDAO.findAvailableRooms();
        request.setAttribute("rooms", rooms);

        request.getRequestDispatcher("/views/manager/createContractExisting.jsp")
                .forward(request, response);
    }

    @Override
    @SuppressWarnings("CallToPrintStackTrace")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");

        if (auth == null || auth.getStaff() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Path runtimeDir = null;
        Path sourceDir = null;
        String frontFile = null;
        String backFile = null;

        try {
            int tenantId = Integer.parseInt(req(request, "tenantId"));
            int roomId = Integer.parseInt(req(request, "roomId"));

            Date startDate = Date.valueOf(req(request, "startDate"));
            Date endDate = Date.valueOf(req(request, "endDate"));

            BigDecimal rent = new BigDecimal(req(request, "rent"));
            BigDecimal deposit = new BigDecimal(req(request, "deposit"));

            if (rent.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Monthly rent must be >= 0.");
            }

            if (deposit.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Deposit must be >= 0.");
            }

            Date expectedEndDate = Date.valueOf(startDate.toLocalDate().plusYears(1));
            if (!endDate.equals(expectedEndDate)) {
                throw new IllegalArgumentException("Hợp đồng phải có thời hạn đúng 1 năm kể từ ngày bắt đầu.");
            }

            Part cccdFront = request.getPart("cccdFront");
            Part cccdBack = request.getPart("cccdBack");

            if (cccdFront == null || cccdFront.getSize() <= 0 || cccdBack == null || cccdBack.getSize() <= 0) {
                redirectError(request, response, "Vui lòng upload đủ CCCD mặt trước và mặt sau.");
                return;
            }

            String frontExt = getFileExtension(cccdFront);
            String backExt = getFileExtension(cccdBack);

            validateImageExtension(frontExt, "CCCD mặt trước");
            validateImageExtension(backExt, "CCCD mặt sau");

            String runtimeUploadPath = getServletContext().getRealPath("/assets/images/tenant-docs/");
            if (runtimeUploadPath == null || runtimeUploadPath.isBlank()) {
                throw new IllegalStateException("Không lấy được runtime upload path từ getRealPath().");
            }
            runtimeDir = Paths.get(runtimeUploadPath);

            String sourceUploadPath = getServletContext().getInitParameter("tenantDocsUploadDir");
            if (sourceUploadPath == null || sourceUploadPath.isBlank()) {
                throw new IllegalStateException("Thiếu context-param tenantDocsUploadDir trong web.xml.");
            }
            sourceDir = Paths.get(sourceUploadPath);

            Files.createDirectories(runtimeDir);
            Files.createDirectories(sourceDir);

            String unique = System.currentTimeMillis() + "_" + UUID.randomUUID().toString().replace("-", "");
            frontFile = unique + "_front" + frontExt;
            backFile = unique + "_back" + backExt;

            savePartToBothLocations(cccdFront, frontFile, runtimeDir, sourceDir);
            savePartToBothLocations(cccdBack, backFile, runtimeDir, sourceDir);

            String frontUrl = "/assets/images/tenant-docs/" + frontFile;
            String backUrl = "/assets/images/tenant-docs/" + backFile;

            Contract c = new Contract();
            c.setTenantId(tenantId);
            c.setRoomId(roomId);
            c.setCreatedByStaffId(auth.getStaff().getStaffId());
            c.setStartDate(startDate);
            c.setEndDate(endDate);
            c.setMonthlyRent(rent);
            c.setDeposit(deposit);
            c.setPaymentQrData("/assets/images/qr/myqr.png");

            ServiceResult rs = contractService.createContractForExistingTenant(c, tenantId, frontUrl, backUrl);

            if (rs.isOk()) {
                response.sendRedirect(request.getContextPath() + "/manager/contracts?created=1");
            } else {
                rollbackUploadedFiles(runtimeDir, sourceDir, frontFile, backFile);

                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/create-existing?error="
                        + java.net.URLEncoder.encode(rs.getMessage(), "UTF-8"));
            }

        } catch (ServletException | IOException | IllegalArgumentException | IllegalStateException e) {
            e.printStackTrace();

            rollbackUploadedFiles(runtimeDir, sourceDir, frontFile, backFile);

            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts/create-existing?error="
                    + java.net.URLEncoder.encode("Lỗi dữ liệu form: " + e.getMessage(), "UTF-8"));
        }
    }

    private void savePartToBothLocations(Part part, String fileName, Path runtimeDir, Path sourceDir) throws IOException {
        Path runtimeFile = runtimeDir.resolve(fileName);
        Path sourceFile = sourceDir.resolve(fileName);

        try (InputStream in = part.getInputStream()) {
            Files.copy(in, runtimeFile, StandardCopyOption.REPLACE_EXISTING);
        }

        try (InputStream in = part.getInputStream()) {
            Files.copy(in, sourceFile, StandardCopyOption.REPLACE_EXISTING);
        }
    }

    private void rollbackUploadedFiles(Path runtimeDir, Path sourceDir, String frontFile, String backFile) {
        deleteIfExists(runtimeDir, frontFile);
        deleteIfExists(runtimeDir, backFile);
        deleteIfExists(sourceDir, frontFile);
        deleteIfExists(sourceDir, backFile);
    }

    private void deleteIfExists(Path dir, String fileName) {
        if (dir == null || fileName == null || fileName.isBlank()) {
            return;
        }
        try {
            Files.deleteIfExists(dir.resolve(fileName));
        } catch (IOException ignored) {
        }
    }

    private void validateImageExtension(String ext, String fieldName) {
        if (!ALLOWED_EXTENSIONS.contains(ext)) {
            throw new IllegalArgumentException(fieldName + " chỉ chấp nhận file ảnh: .jpg, .jpeg, .png, .webp");
        }
    }

    private void redirectError(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        String err = java.net.URLEncoder.encode(message, "UTF-8");
        response.sendRedirect(request.getContextPath() + "/manager/contracts/create-existing?error=" + err);
    }

    private String req(HttpServletRequest request, String name) {
        String v = request.getParameter(name);
        if (v == null || v.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing field: " + name);
        }
        return v.trim();
    }

    private String getFileExtension(Part part) {
        String submitted = part.getSubmittedFileName();
        if (submitted == null || submitted.isBlank()) {
            return ".jpg";
        }

        int dot = submitted.lastIndexOf('.');
        if (dot < 0) {
            return ".jpg";
        }

        return submitted.substring(dot).toLowerCase();
    }
}
