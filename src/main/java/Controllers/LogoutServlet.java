/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import java.io.IOException;

import DALs.StaffDAO;
import DALs.TenantDAO;
import Models.authentication.AuthUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // get sesssion hiện tại (false)
        if (session != null) {
            AuthUser authUser = (AuthUser) session.getAttribute("auth"); //get account đang login
            if (authUser != null) {
                if ("ADMIN".equalsIgnoreCase(authUser.getRole()) || "MANAGER".equalsIgnoreCase(authUser.getRole())) {
                    StaffDAO sdao = new StaffDAO();
                    sdao.clearRememberToken(authUser.getId());
                } else if ("TENANT".equalsIgnoreCase(authUser.getRole())) {
                    TenantDAO tdao = new TenantDAO();
                    tdao.clearRememberToken(authUser.getId());
                }
            }
            session.invalidate(); // delete all session data ( lúc này "account" và "role" biến mất ) => user chính thức đã logout
        }
        // create cookie rỗng để Delete cookie Remember_me
        Cookie c = new Cookie("Remember_me", "");
        c.setMaxAge(0); // yêu cầu client delete cookie
        c.setPath(request.getContextPath()); //path giống lúc tạo
        response.addCookie(c); //send request delete về client

        response.sendRedirect(request.getContextPath() + "/home");
    }
}
