package Controllers.manager;

import java.io.IOException;

import DALs.contract.ContractDAO;
import Models.authentication.AuthResult;
import Models.common.ServiceResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class ManagerTerminateContractController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // không cần page riêng -> quay về detail
        String id = request.getParameter("id");
        if (id == null) {
            id = "";
        }
        response.sendRedirect(request.getContextPath() + "/manager/contracts/detail?id=" + id);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Auth giống ManagerContractDetailController
        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");
        if (auth == null || auth.getStaff() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String role = auth.getStaff().getStaffRole();
        if (role == null || (!role.equals("MANAGER") && !role.equals("ADMIN"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

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

        ServiceResult rs = contractDAO.terminateContractByManager(contractId);

        if (rs.isOk()) {
            // về detail cho tenant thấy status mới
            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts/detail?id=" + contractId + "&terminated=1");
        } else {
            String code = rs.getMessage() == null ? "UNKNOWN" : rs.getMessage();
            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts/detail?id=" + contractId + "&err=1&code=" + code);
        }
    }
}
