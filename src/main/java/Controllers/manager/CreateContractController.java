package Controllers.manager;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

import DALs.room.RoomDAO;
import Models.authentication.AuthResult;
import Models.common.ServiceResult;
import Models.entity.Contract;
import Models.entity.Tenant;
import Services.contract.ContractService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/manager/contracts/create")
public class CreateContractController extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();
    private final ContractService service = new ContractService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("rooms", roomDAO.findAvailableRooms());
        request.getRequestDispatcher("/views/manager/createContract.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthResult auth = (AuthResult) request.getSession().getAttribute("auth");
        if (auth == null || auth.getStaff() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int roomId = Integer.parseInt(req(request, "roomId"));

            // tenant (ALL REQUIRED)
            String tenantName = req(request, "tenantName");
            String identityCode = req(request, "identityCode");
            String email = req(request, "email");
            String phone = req(request, "phone");
            String address = req(request, "address");
            String dobRaw = req(request, "dob");
            String genderRaw = req(request, "gender");

            // contract (ALL REQUIRED)
            BigDecimal rent = new BigDecimal(req(request, "rent"));
            BigDecimal deposit = new BigDecimal(req(request, "deposit"));

            LocalDate startDate = LocalDate.parse(req(request, "startDate"));
            LocalDate endDate = LocalDate.parse(req(request, "endDate"));

            Contract c = new Contract();
            c.setRoomId(roomId);
            c.setCreatedByStaffId(auth.getStaff().getStaffId());
            c.setStartDate(java.sql.Date.valueOf(startDate));
            c.setEndDate(java.sql.Date.valueOf(endDate));
            c.setMonthlyRent(rent);
            c.setDeposit(deposit);
            c.setPaymentQrData("/assets/images/qr/myqr.png");

            Tenant t = new Tenant();
            t.setFullName(tenantName);
            t.setIdentityCode(identityCode);
            t.setEmail(email);
            t.setPhoneNumber(phone);
            t.setAddress(address);
            t.setDateOfBirth(java.sql.Date.valueOf(LocalDate.parse(dobRaw)));
            t.setGender(Integer.valueOf(genderRaw)); // 0/1
            t.setAvatar("/assets/images/avatar/avtDefault.png");

            ServiceResult rs = service.createContractAndTenant(c, t);

            if (rs.isOk()) {
                String msg = java.net.URLEncoder.encode(rs.getMessage(), "UTF-8");
                response.sendRedirect(request.getContextPath() + "/manager/contracts?success=" + msg);
            } else {
                String err = java.net.URLEncoder.encode(rs.getMessage(), "UTF-8");
                response.sendRedirect(request.getContextPath() + "/manager/contracts/create?error=" + err);
            }
        } catch (IOException | NumberFormatException e) {
            String err = java.net.URLEncoder.encode("Lỗi dữ liệu form: " + e.getMessage(), "UTF-8");
            response.sendRedirect(request.getContextPath() + "/manager/contracts/create?error=" + err);
        }
    }

    private String req(HttpServletRequest request, String name) {
        String v = request.getParameter(name);
        if (v == null || v.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing field: " + name);
        }
        return v.trim();
    }
}
