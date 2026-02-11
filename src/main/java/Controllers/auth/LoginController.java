package Controllers.auth;

import java.io.IOException;

import DALs.auth.StaffDAO;
import DALs.auth.TenantDAO;
import Models.authentication.AuthResult;
import Services.auth.AuthService;
import Utils.security.TokenUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Duong Thien Nhan - CE190741
 */
public class LoginController extends HttpServlet {

    private final AuthService authService = new AuthService();

    // DAO để lưu token
    private final TenantDAO tenantDAO = new TenantDAO();
    private final StaffDAO staffDAO = new StaffDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mode = request.getParameter("mode"); // password or otp
        String email = request.getParameter("email");

        String remember = request.getParameter("remember"); // on nếu tick

        AuthResult authResult = null;
        if ("OTP".equalsIgnoreCase(mode)) {
            String otp = request.getParameter("otp");

            if (email == null || otp == null || email.isBlank() || otp.isBlank()) {
                request.setAttribute("error", "Vui lòng nhập email và OTP.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            authResult = authService.loginByOtp(email, otp);
            if (authResult == null) {
                request.setAttribute("error", "OTP không đúng hoặc đã hết hạn.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        } else {
            String password = request.getParameter("password");

            if (email == null || password == null || email.isBlank() || password.isBlank()) {
                request.setAttribute("error", "Vui lòng nhập email và mật khẩu.");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            authResult = authService.login(email, password);

            if (authResult == null) {
                request.setAttribute("error", "Sai thông tin đăng nhập hoặc tài khoản chưa set mật khẩu (hãy dùng OTP lần đầu).");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("auth", authResult);

        // remember me
        if ("on".equals(remember)) {

            // Nếu là tenant thì chỉ allow remember khi ACTIVE (TEMP)
            if (authResult.getTenant() != null) {
                if (!"ACTIVE".equalsIgnoreCase(authResult.getTenant().getAccountStatus())) {
                    // không set token/cookie cho tenant chưa active
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }
            }
            String token = TokenUtil.generateToken();

            if (authResult.getTenant() != null) {
                tenantDAO.updateTokenForTenant(authResult.getTenant().getTenantId(), token);
            } else if (authResult.getStaff() != null) {
                staffDAO.updateTokenForStaff(authResult.getStaff().getStaffId(), token);
            }

            Cookie cookie = new Cookie("REMEMBER_TOKEN", token);
            cookie.setHttpOnly(true);
            cookie.setMaxAge(45 * 24 * 60 * 60); // 45day
            cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            response.addCookie(cookie);
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
