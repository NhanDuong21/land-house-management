/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.manager;

import DALs.Bill.BillDAO;
import Models.dto.ManagerBillRowDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author To Thi Thao Trang - CE191027
 */

@WebServlet(name = "ManagerBillController", urlPatterns = {"/manager/billing"})
public class ManagerBillController extends HttpServlet {

  
    private final BillDAO billDAO = new BillDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ManagerBillRowDTO> list = billDAO.getManagerBills();
        request.setAttribute("bill", list);
        request.getRequestDispatcher("/views/manager/bills.jsp").forward(request, response);
    }

     

}
