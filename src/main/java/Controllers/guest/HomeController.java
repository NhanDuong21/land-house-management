package Controllers.guest;

import java.io.IOException;
import java.util.List;

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
public class HomeController extends HttpServlet {

    private final RoomGuestService roomService = new RoomGuestService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String minArea = request.getParameter("minArea");
        String maxArea = request.getParameter("maxArea");
        String hasAC = request.getParameter("hasAC");
        String hasMezzanine = request.getParameter("hasMezzanine");
        List<Room> listRooms = roomService.searchAvailable(minPrice, maxPrice, minArea, maxArea, hasAC, hasMezzanine);
        request.setAttribute("rooms", listRooms);
        // giữ lại filter
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("minArea", minArea);
        request.setAttribute("maxArea", maxArea);
        request.setAttribute("hasAC", hasAC == null ? "any" : hasAC);
        request.setAttribute("hasMezzanine", hasMezzanine == null ? "any" : hasMezzanine);

        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}
