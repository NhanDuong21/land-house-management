/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.auth;

import java.io.IOException;

import DALs.StaffDAO;
import DALs.TenantDAO;
import Models.authentication.AuthResult;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class LogoutController extends HttpServlet {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            AuthResult auth = (AuthResult) session.getAttribute("auth");
            if (auth != null) {
                if (auth.getTenant() != null) {
                    tenantDAO.clearTokenForTenant(auth.getTenant().getTenantId());
                }
                if (auth.getStaff() != null) {
                    staffDAO.clearTokenForStaff(auth.getStaff().getStaffId());
                }
            }
            session.invalidate();
        }

        Cookie c = new Cookie("REMEMBER_TOKEN", "");
        c.setMaxAge(0);
        c.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        response.addCookie(c);

        response.sendRedirect(request.getContextPath() + "/home");

    }
}
