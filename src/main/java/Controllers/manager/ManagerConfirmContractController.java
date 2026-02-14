package Controllers.manager;

import java.io.IOException;

import DALs.contract.ContractConfirmDAO;
import DALs.payment.PaymentDAO;
import Models.dto.TxResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class ManagerConfirmContractController extends HttpServlet {

    private final ContractConfirmDAO confirmDAO = new ContractConfirmDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/manager/contracts");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("contractId");
        if (idRaw == null || idRaw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/manager/contracts?err=1&code=NO_ID");
            return;
        }

        int contractId;
        try {
            contractId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/contracts?err=1&code=BAD_ID");
            return;
        }

        // block confirm nếu chưa có PAYMENT BANK PENDING
        boolean hasPendingPayment = paymentDAO.hasPendingBankPayment(contractId);
        if (!hasPendingPayment) {
            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts?err=1&code=NEED_TENANT_PAYMENT");
            return;
        }

        TxResult rs = confirmDAO.confirmContractWithDebug(contractId);

        if (rs.isOk()) {
            response.sendRedirect(request.getContextPath() + "/manager/contracts?confirmed=1");
        } else {
            String code = rs.getCode() == null ? "UNKNOWN" : rs.getCode();
            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts?err=1&code=" + code);
        }
    }
}
