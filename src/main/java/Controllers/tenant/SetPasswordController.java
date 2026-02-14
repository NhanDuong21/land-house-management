package Controllers.tenant;

import java.io.IOException;

import DALs.auth.TenantDAO;
import Models.authentication.AuthResult;
import Models.entity.Tenant;
import Utils.security.HashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class SetPasswordController extends HttpServlet {

    private final TenantDAO tenantDAO = new TenantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/tenant/setPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");
        if (auth == null || auth.getTenant() == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Tenant t = auth.getTenant();

        String pass = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        if (pass == null || confirm == null || pass.isBlank() || confirm.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu và xác nhận.");
            request.getRequestDispatcher("/views/tenant/setPassword.jsp").forward(request, response);
            return;
        }

        if (!pass.equals(confirm)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/views/tenant/setPassword.jsp").forward(request, response);
            return;
        }

        if (pass.length() < 6) {
            request.setAttribute("error", "Mật khẩu tối thiểu 6 ký tự.");
            request.getRequestDispatcher("/views/tenant/setPassword.jsp").forward(request, response);
            return;
        }

        String hash = HashUtil.md5(pass);
        boolean ok = tenantDAO.updatePasswordForTenant(t.getTenantId(), hash);

        if (!ok) {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/tenant/setPassword.jsp").forward(request, response);
            return;
        }

        // update lại auth trong session để layout hiển thị đúng must_set_password
        t.setPasswordHash(hash);
        t.setMustSetPassword(false);
        session.setAttribute("auth", auth);

        response.sendRedirect(request.getContextPath() + "/tenant/contract");
    }
}
