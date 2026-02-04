package Controllers;

import java.io.IOException;

import DALs.StaffDAO;
import DALs.TenantDAO;
import Models.entity.Staff;
import Models.entity.Tenant;
import Utils.HashUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginController extends HttpServlet {

    private final StaffDAO staffDAO = new StaffDAO();
    private final TenantDAO tenantDAO = new TenantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập email và mật khẩu.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        String inputHash = HashUtil.md5(password);

        // 1) Ưu tiên check STAFF trước
        Staff s = staffDAO.findByEmail(email);
        if (s != null) {
            // staff tồn tại -> check status + password
            if (!"ACTIVE".equalsIgnoreCase(s.getStatus())) {
                request.setAttribute("error", "Tài khoản đã bị vô hiệu hóa.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            if (s.getPasswordHash() == null || !inputHash.equalsIgnoreCase(s.getPasswordHash())) {
                request.setAttribute("error", "Sai email hoặc mật khẩu.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("staff", s);
            session.removeAttribute("tenant");

            // redirect theo role
            if ("MANAGER".equalsIgnoreCase(s.getStaffRole())) {
                response.sendRedirect(request.getContextPath() + "/manager/home");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/home");
            }
            return;
        }

        // 2) Không phải staff -> check TENANT
        Tenant t = tenantDAO.findByEmail(email);
        if (t == null) {
            request.setAttribute("error", "Sai email hoặc mật khẩu.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Tenant chưa set password -> bắt đi OTP flow
        if (t.getPasswordHash() == null) {
            request.setAttribute("error", "Tài khoản chưa set mật khẩu. Hãy đăng nhập lần đầu bằng OTP.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        if (!inputHash.equalsIgnoreCase(t.getPasswordHash())) {
            request.setAttribute("error", "Sai email hoặc mật khẩu.");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            return;
        }

        // Login ok
        HttpSession session = request.getSession(true);
        session.setAttribute("tenant", t);
        session.removeAttribute("staff");

        // must_set_password -> ép đổi pass
        if (t.isMustSetPassword()) {
            response.sendRedirect(request.getContextPath() + "/tenant/set-password");
            return;
        }

        // status điều hướng
        if ("ACTIVE".equalsIgnoreCase(t.getAccountStatus())) {
            response.sendRedirect(request.getContextPath() + "/tenant/home");
        } else {
            response.sendRedirect(request.getContextPath() + "/tenant/contract");
        }
    }
}
