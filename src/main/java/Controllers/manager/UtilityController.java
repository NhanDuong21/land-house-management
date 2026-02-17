/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers.manager;

import Models.entity.Utility;
import Services.manager.UtilityService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author Truong Hoang Khang - CE190729
 */
public class UtilityController extends HttpServlet {

    private final UtilityService utilityService = new UtilityService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Utility> utilities = utilityService.getAllUtilities();

        request.setAttribute("utilities", utilities);

        request.getRequestDispatcher("/views/manager/manageUtilities.jsp")
                .forward(request, response);

    }
}
