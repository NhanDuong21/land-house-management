package Controllers.guest;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import java.io.IOException;

import Models.entity.Room;
import Services.guest.RoomGuestService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class RoomDetailController extends HttpServlet {

    private final RoomGuestService roomGuestService = new RoomGuestService();

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

        Room room = roomGuestService.getRoomDetailForGuest(id); // service check AVAILABLE...
        if (room == null) {
            response.sendError(404, "Not found");
            return;
        }

        request.setAttribute("room", room);

        // trả về 1 JSP fragment, KHÔNG phải full layout
        request.getRequestDispatcher("/views/room/roomDetail.jsp").forward(request, response);
    }
}
