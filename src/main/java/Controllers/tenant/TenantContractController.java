package Controllers.tenant;

import java.io.IOException;
import java.util.List;

import DALs.contract.ContractDAO;
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
public class TenantContractController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");

        // AuthFilter đã chặn role, nhưng thêm guard cho chắc
        if (auth == null || auth.getTenant() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int tenantId = auth.getTenant().getTenantId();
        List<Contract> contracts = contractDAO.findByTenantId(tenantId);

        request.setAttribute("contracts", contracts);
        request.getRequestDispatcher("/views/tenant/contract.jsp").forward(request, response);
    }
}
