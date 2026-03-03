package Controllers.tenant;

import java.io.IOException;

import DALs.contract.ContractDAO;
import DALs.room.RoomImageDAO;
import Models.authentication.AuthResult;
import Models.dto.TenantMyRoomDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class TenantMyRoomController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final RoomImageDAO roomImageDAO = new RoomImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthResult auth = (AuthResult) request.getSession().getAttribute("auth");
        if (auth == null || auth.getTenant() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!"ACTIVE".equalsIgnoreCase(auth.getTenant().getAccountStatus())) {
            response.sendRedirect(request.getContextPath() + "/tenant/contract");
            return;
        }

        int tenantId = auth.getTenant().getTenantId();

        TenantMyRoomDTO myRoom = contractDAO.findActiveMyRoomByTenantId(tenantId);
        if (myRoom != null) {
            myRoom.setImages(roomImageDAO.findByRoomId(myRoom.getRoomId()));
        }

        request.setAttribute("myRoom", myRoom);
        request.getRequestDispatcher("/views/tenant/myRoom.jsp").forward(request, response);
    }
}
