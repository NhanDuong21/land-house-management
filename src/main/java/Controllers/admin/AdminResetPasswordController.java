package Controllers.admin;

import java.io.IOException;
import java.util.List;

import DALs.auth.StaffDAO;
import DALs.auth.TenantDAO;
import Models.authentication.AuthResult;
import Models.common.ServiceResult;
import Models.entity.Staff;
import Models.entity.Tenant;
import Services.staff.StaffService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "AdminResetPasswordController", urlPatterns = {"/admin/reset-password"})
public class AdminResetPasswordController extends HttpServlet {

    private final StaffService staffService = new StaffService();

    private final TenantDAO tenantDAO = new TenantDAO();
    private final StaffDAO staffDAO = new StaffDAO();

    private AuthResult getAuth(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session == null) ? null : (AuthResult) session.getAttribute("auth");
    }

    private boolean isAdmin(AuthResult auth) {
        return auth != null
                && auth.getStaff() != null
                && "ADMIN".equalsIgnoreCase(auth.getRole());
    }

    private void loadPageData(HttpServletRequest request) {
        List<Tenant> tenants = tenantDAO.findActiveTenants();
        Staff manager = staffDAO.findManager();

        request.setAttribute("tenants", tenants);
        request.setAttribute("manager", manager);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthResult auth = getAuth(request);
        if (!isAdmin(auth)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        loadPageData(request);
        request.getRequestDispatcher("/views/admin/adminResetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthResult auth = getAuth(request);
        if (!isAdmin(auth)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String targetType = request.getParameter("targetType");
        String targetIdRaw = request.getParameter("targetId");
        String newPassword = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        int targetId;
        try {
            targetId = Integer.parseInt(targetIdRaw);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ.");
            loadPageData(request);
            request.getRequestDispatcher("/views/admin/adminResetPassword.jsp").forward(request, response);
            return;
        }

        ServiceResult result = staffService.adminResetPassword(auth, targetType, targetId, newPassword, confirm);

        if (result.isOk()) {
            request.setAttribute("success", result.getMessage());
        } else {
            request.setAttribute("error", result.getMessage());
        }

        //luôn load tenants/manager trước khi forward
        loadPageData(request);
        request.getRequestDispatcher("/views/admin/adminResetPassword.jsp").forward(request, response);
    }
}
