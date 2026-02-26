package Controllers.admin;

import java.io.IOException;

import Models.authentication.AuthResult;
import Models.common.ServiceResult;
import Services.staff.StaffService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
@WebServlet(name = "AdminAccountResetPasswordController", urlPatterns = {"/admin/accounts/reset-password"})
public class AdminAccountResetPasswordController extends HttpServlet {

    private final StaffService staffService = new StaffService();

    private AuthResult getAuth(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session == null) ? null : (AuthResult) session.getAttribute("auth");
    }

    private boolean isAdmin(AuthResult auth) {
        return auth != null && auth.getStaff() != null && "ADMIN".equalsIgnoreCase(auth.getRole());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuthResult auth = getAuth(request);
        if (!isAdmin(auth)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String accountType = request.getParameter("accountType"); // TENANT/STAFF
        String accountIdRaw = request.getParameter("accountId");
        String newPassword = request.getParameter("newPassword");
        String confirm = request.getParameter("confirmPassword");

        int accountId;
        try {
            accountId = Integer.parseInt(accountIdRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/accounts?error=ID%20kh%C3%B4ng%20h%E1%BB%A3p%20l%E1%BB%87");
            return;
        }

        ServiceResult r = staffService.adminResetPassword(auth, accountType, accountId, newPassword, confirm);

        if (r.isOk()) {
            response.sendRedirect(request.getContextPath() + "/admin/accounts?success=Reset%20password%20th%C3%A0nh%20c%C3%B4ng");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/accounts?error=" + java.net.URLEncoder.encode(r.getMessage(), "UTF-8"));
        }
    }
}
