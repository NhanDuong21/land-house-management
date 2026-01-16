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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        // basic validate
        if (username == null || password == null || username.isBlank() || password.isBlank()) {
            request.setAttribute("error", "Please enter your username and password!");
            request.setAttribute("username", username);
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
            return;
        }
        StaffDAO sdao = new StaffDAO();
        TenantDAO tdao = new TenantDAO();

        AuthUser authUser = sdao.login(username, password);
        if (authUser == null) {
            authUser = tdao.login(username, password);
        }

        if (authUser == null) {
            request.setAttribute("error", "Incorrect username/password or account locked.");
            request.setAttribute("username", username); // login sai set lại username
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
            return;
        }

        // //Remember me
        // String remember = request.getParameter("remember");
        // if (remember != null) {
        //     String token = UUID.randomUUID().toString(); //toString để chuyển uuid v4 thành String để lưu db ( varchar )
        //     //save token to DB
        //     dao.saveRemember(acc.getAccountId(), token);
        //     Cookie cookie = new Cookie("Remember_me", token);
        //     cookie.setMaxAge(60 * 60 * 24 * 7); // 7 ngày
        //     cookie.setHttpOnly(true);
        //     cookie.setPath(request.getContextPath()); // quy định cookie send request đến url của contexpath
        //     response.addCookie(cookie); // send cookie from server to client (Set-Cookie: Remember_me=abc123; Path=/LandHouseManagement; HttpOnly)
        // }
        //Debug lộ pass khi gắn pass vào object
        // System.out.println("USERNAME = [" + acc.getUsername() + "]");
        // System.out.println("PASSWORD = [" + acc.getPassword() + "]");
        // login ok -> set session
        HttpSession session = request.getSession();
        session.setAttribute("auth", authUser); // auth là name attribute do mình set

        response.sendRedirect(request.getContextPath() + "/home");

    }
}
