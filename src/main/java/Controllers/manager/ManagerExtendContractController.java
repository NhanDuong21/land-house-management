package Controllers.manager;

import java.io.IOException;
import java.sql.Connection;

import DALs.contract.ContractDAO;
import Models.authentication.AuthResult;
import Models.entity.Contract;
import Utils.database.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * extend contract (same room) -> create new PENDING contract Tenant will
 * confirm transfer -> Manager confirm will activate & end old ACTIVE
 *
 * @author Duong Thien Nhan - CE190741
 */
public class ManagerExtendContractController extends HttpServlet {

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // auth
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
            response.sendRedirect(request.getContextPath() + "/manager/contracts");
            return;
        }

        int contractId;
        try {
            contractId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/contracts");
            return;
        }

        // Load current contract (must be ACTIVE)
        Contract cur = contractDAO.findDetailForManager(contractId);
        if (cur == null) {
            response.sendRedirect(request.getContextPath() + "/manager/contracts");
            return;
        }
        if (!"ACTIVE".equalsIgnoreCase(cur.getStatus())) {
            response.sendRedirect(request.getContextPath()
                    + "/manager/contracts/detail?id=" + contractId + "&err=NOT_ACTIVE");
            return;
        }

        // Suggested startDate = cur.end_date + 1 (if end_date null -> today)
        java.sql.Date suggestedStart;
        if (cur.getEndDate() != null) {
            suggestedStart = new java.sql.Date(cur.getEndDate().getTime() + 24L * 60 * 60 * 1000);
        } else {
            suggestedStart = new java.sql.Date(System.currentTimeMillis());
        }

        request.setAttribute("cur", cur);
        request.setAttribute("suggestedStart", suggestedStart);
        request.setAttribute("staffId", auth.getStaff().getStaffId());

        request.getRequestDispatcher("/views/manager/extendContract.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // auth
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

        try {
            int oldContractId = Integer.parseInt(request.getParameter("oldContractId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));

            java.sql.Date startDate = java.sql.Date.valueOf(request.getParameter("startDate"));
            java.sql.Date endDate = java.sql.Date.valueOf(request.getParameter("endDate"));

            java.math.BigDecimal monthlyRent = new java.math.BigDecimal(request.getParameter("monthlyRent"));
            java.math.BigDecimal deposit = new java.math.BigDecimal(request.getParameter("deposit"));

            String qr = request.getParameter("paymentQrData");
            qr = (qr == null) ? "" : qr.trim();

            // Basic validate
            if (endDate == null || startDate == null || !endDate.after(startDate)) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/extend?contractId=" + oldContractId + "&err=DATE");
                return;
            }
            if (monthlyRent == null || monthlyRent.signum() < 0) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/extend?contractId=" + oldContractId + "&err=RENT");
                return;
            }
            if (deposit == null || deposit.signum() < 0) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/extend?contractId=" + oldContractId + "&err=DEPOSIT");
                return;
            }
            if (qr.isBlank()) {
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/extend?contractId=" + oldContractId + "&err=QR");
                return;
            }

            Contract c = new Contract();
            c.setRoomId(roomId);
            c.setTenantId(tenantId);
            c.setCreatedByStaffId(auth.getStaff().getStaffId());
            c.setStartDate(startDate);
            c.setEndDate(endDate);
            c.setMonthlyRent(monthlyRent);
            c.setDeposit(deposit);
            c.setPaymentQrData(qr);

            try (Connection conn = new DBContext().getConnection()) {
                conn.setAutoCommit(false);

                // insert NEW PENDING contract (reuse existing DAO method)
                int newId = contractDAO.insertPendingContract(conn, c);
                if (newId <= 0) {
                    conn.rollback();
                    response.sendRedirect(request.getContextPath()
                            + "/manager/contracts/detail?id=" + oldContractId + "&err=EXTEND_FAIL");
                    return;
                }

                conn.commit();
                // redirect to new pending contract detail
                response.sendRedirect(request.getContextPath()
                        + "/manager/contracts/detail?id=" + newId + "&created=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/contracts?err=1&code=EXTEND_EXCEPTION");
        }
    }
}
