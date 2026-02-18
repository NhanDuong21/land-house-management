package Controllers.manager;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.util.List;

import DALs.auth.TenantDAO;
import DALs.contract.ContractDAO;
import DALs.room.RoomDAO;
import Models.authentication.AuthResult;
import Models.entity.Contract;
import Models.entity.Tenant;
import Models.entity.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CreateExistingContractController extends HttpServlet {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final ContractDAO contractDAO = new ContractDAO();
    private final RoomDAO roomDAO = new RoomDAO();

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

        try (Connection conn = contractDAO.getConnection()) {

            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));

            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));

            BigDecimal rent = new BigDecimal(request.getParameter("rent"));
            BigDecimal deposit = new BigDecimal(request.getParameter("deposit"));

            String qr = request.getParameter("paymentQrData");

            if (endDate.before(startDate)) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/create-existing?error=End date must be after start date");
                return;
            }

            // Check phòng có ACTIVE chưa
            if (contractDAO.existsActiveContractForRoom(roomId)) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/create-existing?error=Room already has ACTIVE contract");
                return;
            }

            Contract c = new Contract();
            c.setTenantId(tenantId);
            c.setRoomId(roomId);
            c.setCreatedByStaffId(auth.getStaff().getStaffId());
            c.setStartDate(startDate);
            c.setEndDate(endDate);
            c.setMonthlyRent(rent);
            c.setDeposit(deposit);
            c.setPaymentQrData(qr);

            int newId = contractDAO.insertPendingContract(conn, c);

            if (newId > 0) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts?created=1");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts?err=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts?err=1");
        }
    }
}
