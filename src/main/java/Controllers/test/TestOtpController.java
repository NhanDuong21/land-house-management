package Controllers.test;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import java.io.IOException;

import Services.auth.OtpService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
@WebServlet(urlPatterns = {"/test/send-otp"})
public class TestOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int tenantId = Integer.parseInt(request.getParameter("tenantId"));
        String email = request.getParameter("email");

        OtpService s = new OtpService();
        boolean ok = s.sendFirstLoginOtp(tenantId, email);

        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().println(ok ? "SEND OTP OK" : "SEND OTP FAIL");
    }
}
