package Controllers.manager;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import DALs.room.RoomDAO;
import Models.authentication.AuthResult;
import Models.entity.Contract;
import Models.entity.Room;
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

        List<Room> rooms = roomDAO.findAvailableRooms();
        request.setAttribute("rooms", rooms);

        request.getRequestDispatcher("/views/manager/createContract.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthResult auth = (AuthResult) request.getSession().getAttribute("auth");

        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String tenantName = request.getParameter("tenantName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        BigDecimal rent = new BigDecimal(request.getParameter("rent"));
        BigDecimal deposit = new BigDecimal(request.getParameter("deposit"));
        LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
        LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));
        
        Contract c = new Contract();
        c.setRoomId(roomId);
        c.setCreatedByStaffId(auth.getStaff().getStaffId());
        c.setStartDate(java.sql.Date.valueOf(startDate));
        c.setEndDate(java.sql.Date.valueOf(endDate));
        c.setMonthlyRent(rent);
        c.setDeposit(deposit);
        c.setPaymentQrData("QR_DATA_PLACEHOLDER");

        Tenant t = new Tenant();
        t.setFullName(tenantName);
        t.setEmail(email);
        t.setPhoneNumber(phone);

        boolean ok = service.createContractAndTenant(c, t);

        if (ok) {
            response.sendRedirect(request.getContextPath() + "/manager/contracts");
        } else {
            response.sendRedirect(request.getContextPath() + "/manager/contracts/create?error=1");
        }

    }
}
