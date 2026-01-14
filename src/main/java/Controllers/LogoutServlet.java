/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // HttpSession session = request.getSession(false); // get sesssion hiện tại (false)
        // if (session != null) {
        //     Account acc = (Account) session.getAttribute("account"); //get account đang login
        //     if (acc != null) {
        //         AccountDAO dao = new AccountDAO();
        //         dao.clearRememberToken(acc.getAccountId());
        //     }
        //     session.invalidate(); // delete all session data ( lúc này "account" và "role" biến mất ) => user chính thức đã logout
        // }
        // // create cookie rỗng để Delete cookie Remember_me
        // Cookie c = new Cookie("Remember_me", "");
        // c.setMaxAge(0); // yêu cầu client delete cookie
        // c.setPath(request.getContextPath()); //path giống lúc tạo
        // response.addCookie(c); //send request delete về client
        // response.sendRedirect("login");
        // response.sendRedirect(request.getContextPath() + "/home");
    }
}
