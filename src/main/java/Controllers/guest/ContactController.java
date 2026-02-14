/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.guest;

import java.io.IOException;

import Models.common.ContactInfo;
import Utils.config.ContactConfigUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class ContactController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = getServletContext().getInitParameter("contact_props_path");

        ContactInfo info = ContactConfigUtil.load(path);
        request.setAttribute("contact", info);

        request.getRequestDispatcher("/views/common/contact.jsp").forward(request, response);   
    }
}
