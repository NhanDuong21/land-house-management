package Controllers;

import java.io.IOException;
import java.util.List;

import DALs.RoomDAO;
import Models.entity.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomDAO rdao = new RoomDAO();
        List<Room> listRooms = rdao.getAvailableRooms();

        request.setAttribute("roomList", listRooms);
        request.getRequestDispatcher("view/auth/home.jsp").forward(request, response);
    }
}
