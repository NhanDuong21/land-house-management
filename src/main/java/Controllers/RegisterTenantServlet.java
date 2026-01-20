package Controllers;

/**
 * Description
 *
 * @author Duong Thien Nhan - CE190741
 * @since 2026-01-19
 */
import java.io.IOException;

import DALs.TenantDAO;
import Utils.HashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class RegisterTenantServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods.">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");
        String genderStr = request.getParameter("gender"); // "1","0","2" hoặc null

        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("fullName", fullName);
        request.setAttribute("gender", genderStr);

        if (username == null || username.isBlank() || email == null || email.isBlank() || password == null || password.isBlank() || confirm == null || confirm.isBlank()) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Password confirmation does not match.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        TenantDAO tdao = new TenantDAO();
        if (tdao.existsUsername(username.trim())) {
            request.setAttribute("error", "The username already exists.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        if (tdao.existsEmail(email.trim())) {
            request.setAttribute("error", "The email already exists.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }

        Byte gender = null;
        try {
            if (genderStr != null && !genderStr.isBlank()) {
                gender = Byte.parseByte(genderStr);
            }
        } catch (NumberFormatException ignored) {
        }

        String passwordHash = HashUtil.md5(password);

        boolean ok = tdao.registerTenant(username.trim(), email.trim(), fullName.trim(), passwordHash, gender);

        if (!ok) {
            request.setAttribute("error", "Register failed, please try again.");
            request.getRequestDispatcher("view/auth/register.jsp").forward(request, response);
            return;
        }
        response.sendRedirect(request.getContextPath() + "/login?registered=1");
    }

}
