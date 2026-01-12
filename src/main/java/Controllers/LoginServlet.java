/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import java.io.IOException;

import DALs.AccountDAO;
import Models.Account;
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
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
            return;
        }
        AccountDAO dao = new AccountDAO();
        Account acc = dao.login(username.trim(), password);

        if (acc == null) {
            request.setAttribute("error", "Incorrect username/password or account locked.");
            request.getRequestDispatcher("view/auth/login.jsp").forward(request, response);
            return;
        }
        //Debug lộ pass khi gắn pass vào object
        // System.out.println("USERNAME = [" + acc.getUsername() + "]");
        // System.out.println("PASSWORD = [" + acc.getPassword() + "]");

        // login ok -> set session
        HttpSession session = request.getSession();
        session.setAttribute("account", acc);
        session.setAttribute("role", acc.getRole()); // tiện dùng

        // set account theo role
        switch (acc.getRole()) {
            case "ADMIN" ->
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            case "MANAGER" ->
                response.sendRedirect(request.getContextPath() + "/manager/dashboard");
            case "TENANT" ->
                response.sendRedirect(request.getContextPath() + "/tenant/dashboard");
            default ->
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
