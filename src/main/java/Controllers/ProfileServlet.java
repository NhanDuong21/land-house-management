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

        // Kiểm tra xem có phải vừa redirect từ đổi pass thành công qua không
        String changed = request.getParameter("changed");
        if ("1".equals(changed)) {
            request.setAttribute("msg", "Password changed successfully!");
        }

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
            request.setAttribute("p_identity", staff == null ? "" : staff.getIdentityCode());
        } else {
            TenantDAO tdao = new TenantDAO();
            Tenant t = tdao.getById(authUser.getId());
            request.setAttribute("p_username", t != null ? t.getUsername() : "");
            request.setAttribute("p_email", t != null ? t.getEmail() : "");
            request.setAttribute("p_full_name", t != null ? t.getFullName() : "");
            request.setAttribute("p_phone", t != null ? t.getPhoneNumber() : "");
            request.setAttribute("p_identity", t != null ? t.getIdentityCode() : "");
        }
        request.getRequestDispatcher("view/auth/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("auth") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        AuthUser authUser = (AuthUser) session.getAttribute("auth");

        String oldPass = request.getParameter("oldPassword");
        String newPass = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");
        if (oldPass == null || newPass == null || confirm == null
                || oldPass.isBlank() || newPass.isBlank() || confirm.isBlank()) {
            request.setAttribute("error", "Please fill in all the fields to change your password!");
            doGet(request, response);
            return;
        }

        if (!newPass.equals(confirm)) {
            request.setAttribute("error", "The new password and the re-entered new password do not match!");
            doGet(request, response);
            return;
        }

        //    if (newPass.length() < 6) {
        //     request.setAttribute("error", "The new password must be 6 characters or more!");
        //     doGet(request, response);
        //     return;
        // }
        // Verify old password theo đúng logic login hiện tại (khỏi đoán hash)
        boolean oldOk = false;
        if ("ADMIN".equalsIgnoreCase(authUser.getRole()) || "MANAGER".equalsIgnoreCase(authUser.getRole()) == true) {
            StaffDAO sdao = new StaffDAO();
            Staff staff = sdao.getById(authUser.getId());
            if (staff != null) {
                // Reuse login() để verify old password
                AuthUser au = sdao.login(staff.getUsername(), oldPass);
                oldOk = (au != null && au.getId() == authUser.getId());
            }

            if (!oldOk) {
                request.setAttribute("error", "The old password is incorrect!");
                doGet(request, response);
                return;
            }
            // Update password
            boolean updated = sdao.updatePassword(authUser.getId(), newPass);
            if (!updated) {
                request.setAttribute("error", "Unable to change password. Try again later!");
                doGet(request, response);
                return;
            }
        } else { // tenant
            TenantDAO tdao = new TenantDAO();
            Tenant tenant = tdao.getById(authUser.getId());
            if (tenant != null) {
                AuthUser au = tdao.login(tenant.getUsername(), oldPass);
                oldOk = (au != null && au.getId() == authUser.getId());
            }
            if (!oldOk) {
                request.setAttribute("error", "The old password is incorrect!");
                doGet(request, response);
                return;
            }

            boolean updated = tdao.updatePassword(authUser.getId(), newPass);
            if (!updated) {
                request.setAttribute("error", "Unable to change password. Try again later!");
                doGet(request, response);
                return;
            }
        }
        //đổi pass xong redirect về get
        response.sendRedirect(request.getContextPath() + "/profile?changed=1");
    }
}
