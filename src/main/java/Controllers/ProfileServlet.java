/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import java.io.IOException;

import DALs.StaffDAO;
import DALs.TenantDAO;
import Models.authentication.AuthUser;
import Models.entity.Staff;
import Models.entity.Tenant;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("auth") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        AuthUser authUser = (AuthUser) session.getAttribute("auth");
        request.setAttribute("auth", authUser);

        // load detail từ DB để show username/email/phone/cccd
        if ("ADMIN".equalsIgnoreCase(authUser.getRole()) || "MANAGER".equalsIgnoreCase(authUser.getRole()) == true) {
            StaffDAO sdao = new StaffDAO();
            Staff staff = sdao.getById(authUser.getId());
            request.setAttribute("p_username", staff == null ? "" : staff.getUsername());
            request.setAttribute("p_email", staff == null ? "" : staff.getEmail());
            request.setAttribute("p_full_name", staff == null ? "" : staff.getFullName());
            request.setAttribute("p_phone", staff == null ? "" : staff.getPhoneNumber());
            request.setAttribute("p_identity_code", staff == null ? "" : staff.getIdentityCode());
        } else {
            TenantDAO tdao = new TenantDAO();
            Tenant t = tdao.getById(authUser.getId());
            request.setAttribute("p_username", t != null ? t.getUsername() : "");
            request.setAttribute("p_email", t != null ? t.getEmail() : "");
            request.setAttribute("p_full_name", t != null ? t.getFullName() : "");
            request.setAttribute("p_phone", t != null ? t.getPhoneNumber() : "");
            request.setAttribute("p_identity", t != null ? t.getIdentityCode() : "");
        }
        request.getRequestDispatcher("view/auth/profile/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
