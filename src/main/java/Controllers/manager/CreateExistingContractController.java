package Controllers.manager;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;

import DALs.auth.TenantDAO;
import DALs.room.RoomDAO;
import Models.authentication.AuthResult;
import Models.common.ServiceResult;
import Models.entity.Contract;
import Models.entity.Room;
import Models.entity.Tenant;
import Services.contract.ContractService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class CreateExistingContractController extends HttpServlet {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final ContractService contractService = new ContractService();

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

        try {
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));

            BigDecimal rent = new BigDecimal(request.getParameter("rent"));
            BigDecimal deposit = new BigDecimal(request.getParameter("deposit"));

            Contract c = new Contract();
            c.setTenantId(tenantId);
            c.setRoomId(roomId);
            c.setCreatedByStaffId(auth.getStaff().getStaffId());
            c.setStartDate(startDate);
            c.setEndDate(endDate);
            c.setMonthlyRent(rent);
            c.setDeposit(deposit);
            c.setPaymentQrData("/assets/images/qr/myqr.png");

            ServiceResult rs = contractService.createContractForExistingTenant(c, tenantId);

            if (rs.isOk()) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts?created=1");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/create-existing?error="
                        + java.net.URLEncoder.encode(rs.getMessage(), "UTF-8"));
            }

        } catch (IOException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts/create-existing?error="
                    + java.net.URLEncoder.encode("Lỗi dữ liệu form hoặc hệ thống.", "UTF-8"));
        }
    }
}
