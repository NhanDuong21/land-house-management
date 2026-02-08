package Controllers.guest;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import java.io.IOException;

import Models.authentication.AuthResult;
import Models.entity.Room;
import Services.guest.RoomGuestService;
import Services.staff.RoomStaffService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class RoomDetailController extends HttpServlet {

    private final RoomGuestService roomGuestService = new RoomGuestService();
    private final RoomStaffService roomStaffService = new RoomStaffService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid id");
            return;
        }

        // --- lấy role từ session ---
        String role = null;
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object object = session.getAttribute("auth");
            if (!(object instanceof AuthResult)) {
            } else {
                role = ((AuthResult) object).getRole();
            }
        }

        boolean isStaff = role != null && (role.equalsIgnoreCase("ADMIN") || role.equalsIgnoreCase("MANAGER"));

        Room room = isStaff ? roomStaffService.getRoomDetailForStaff(id) : roomGuestService.getRoomDetailForGuest(id);

        if (room == null) {
            response.sendError(404, "Not found");
            return;
        }

        request.setAttribute("room", room);

        // để fragment dùng ${ctx} (ảnh) không bị null
        request.setAttribute("ctx", request.getContextPath());

        request.getRequestDispatcher("/views/room/roomDetail.jsp").forward(request, response);
    }
}
