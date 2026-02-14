package Controllers.tenant;

import java.io.IOException;
import java.math.BigDecimal;

import DALs.contract.ContractDAO;
import DALs.payment.PaymentDAO;
import Models.authentication.AuthResult;
import Models.entity.Contract;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class TenantConfirmTransferController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");

        if (auth == null || auth.getTenant() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idRaw = request.getParameter("contractId");
        if (idRaw == null || idRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/tenant/contract");
            return;
        }

        int contractId;
        try {
            contractId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tenant/contract");
            return;
        }

        int tenantId = auth.getTenant().getTenantId();
        Contract c = contractDAO.findByIdForTenant(contractId, tenantId);
        if (c == null) {
            response.sendRedirect(request.getContextPath() + "/tenant/contract");
            return;
        }

        // chỉ cho confirm khi contract PENDING
        if (!"PENDING".equalsIgnoreCase(c.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/tenant/contract/detail?id=" + contractId);
            return;
        }

        // tránh spam
        if (paymentDAO.hasPendingOrConfirmedBankForContract(contractId)) {
            response.sendRedirect(request.getContextPath() + "/tenant/contract/detail?id=" + contractId + "&already=1");
            return;
        }

        BigDecimal deposit = (c.getDeposit() != null) ? c.getDeposit() : BigDecimal.ZERO;
        BigDecimal rent = (c.getMonthlyRent() != null) ? c.getMonthlyRent() : BigDecimal.ZERO;

        BigDecimal amount = deposit.add(rent);

        boolean ok = paymentDAO.insertTenantConfirmTransfer(contractId, amount);
        if (ok) {
            response.sendRedirect(request.getContextPath() + "/tenant/contract/detail?id=" + contractId + "&sent=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/tenant/contract/detail?id=" + contractId + "&err=1");
        }
    }
}
