package Controllers.manager;

import java.io.IOException;

import DALs.contract.ContractDAO;
import DALs.payment.PaymentDAO;
import Models.authentication.AuthResult;
import Models.entity.Contract;
import Models.entity.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/manager/contracts/detail")
public class ManagerContractDetailController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");

        // Bạn chỉnh theo model auth của bạn: auth.getStaff() hoặc auth.getUser()...
        if (auth == null || auth.getStaff() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = auth.getStaff().getStaffRole(); // 'MANAGER' / 'ADMIN'
        if (role == null || (!role.equals("MANAGER") && !role.equals("ADMIN"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idRaw = request.getParameter("id");
        if (idRaw == null || idRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/manager/contract");
            return;
        }

        int contractId;
        try {
            contractId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/contract");
            return;
        }

        Contract c = contractDAO.findDetailForManager(contractId);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/manager/contract");
            return;
        }

        Payment latestPay = paymentDAO.findLatestBankPaymentForContract(contractId);

        request.setAttribute("contract", c);
        request.setAttribute("latestPayment", latestPay);

        request.getRequestDispatcher("/views/manager/contractDetail.jsp").forward(request, response);
    }
}
