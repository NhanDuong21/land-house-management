package Filters;

import java.io.IOException;

import DALs.StaffDAO;
import DALs.TenantDAO;
import Models.authentication.AuthResult;
import Models.entity.Staff;
import Models.entity.Tenant;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private final TenantDAO tenantDAO = new TenantDAO();
    private final StaffDAO staffDAO = new StaffDAO();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String ctx = request.getContextPath();
        String uri = request.getRequestURI();

        // Cho qua public pages
        boolean isStatic = uri.startsWith(ctx + "/assets/");
        boolean isPublic = uri.equals(ctx + "/home")
                || uri.equals(ctx + "/login")
                || uri.equals(ctx + "/logout")
                || uri.equals(ctx + "/contact");

        if (isStatic || isPublic) {
            chain.doFilter(req, res);
            return;
        }

        // Lấy auth từ session
        HttpSession session = request.getSession(false);
        AuthResult auth = (session == null) ? null : (AuthResult) session.getAttribute("auth");

        // remember me
        if (auth == null) {
            String token = getCookieValue(request, "REMEMBER_TOKEN");
            if (token != null && !token.isBlank()) {

                // check tenant
                Tenant tenant = tenantDAO.findByTokenForTenant(token);
                if (tenant != null) {
                    AuthResult ar = new AuthResult("TENANT", tenant, null);
                    request.getSession(true).setAttribute("auth", ar);
                    auth = ar; // cập nhật lại auth để check role bên dưới
                } else {
                    // check staff
                    Staff staff = staffDAO.findByTokenForStaff(token);
                    if (staff != null) {
                        AuthResult ar = new AuthResult(staff.getStaffRole(), null, staff);
                        request.getSession(true).setAttribute("auth", ar);
                        auth = ar;
                    }
                }
            }
        }

        String role = (auth == null || auth.getRole() == null) ? "GUEST" : auth.getRole();

        // Chặn theo prefix
        if (uri.startsWith(ctx + "/tenant/") && !"TENANT".equalsIgnoreCase(role)) {
            response.sendRedirect(ctx + "/home");
            return;
        }

        if (uri.startsWith(ctx + "/manager/") && !"MANAGER".equalsIgnoreCase(role)) {
            response.sendRedirect(ctx + "/home");
            return;
        }

        if (uri.startsWith(ctx + "/admin/") && !"ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(ctx + "/home");
            return;
        }

        //cancel click back after logout
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        chain.doFilter(req, res);
    }

    private String getCookieValue(HttpServletRequest request, String name) {
        Cookie[] cookies = request.getCookies();
        if (cookies == null) {
            return null;
        }

        for (Cookie c : cookies) {
            if (name.equals(c.getName())) {
                return c.getValue();
            }
        }
        return null;
    }
}
