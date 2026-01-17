package Filters;

import java.io.IOException;

import DALs.StaffDAO;
import DALs.TenantDAO;
import Models.authentication.AuthUser;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class RememberMe implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        String uri = request.getRequestURI();

        // BỎ QUA FILTER VỚI CÁC URL PUBLIC
        if (uri.endsWith("/login")
                || uri.endsWith("/register")
                || uri.contains("/assets/")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);

        // Nếu chưa login thì check cookie remember
        if (session == null || session.getAttribute("auth") == null) {

            String token = null;

            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("Remember_me".equals(c.getName())) {
                        token = c.getValue();
                        break;
                    }
                }
            }

            if (token != null && !token.isBlank()) {

                // thử tìm trong staff trước
                StaffDAO sdao = new StaffDAO();
                AuthUser authUser = sdao.findByRememberToken(token);

                // nếu staff null -> thử tenant
                if (authUser == null) {
                    TenantDAO tdao = new TenantDAO();
                    authUser = tdao.findByRememberToken(token);
                }

                // nếu tìm thấy -> tạo session mới
                if (authUser != null) {
                    HttpSession newSession = request.getSession(true);
                    newSession.setAttribute("auth", authUser);
                    newSession.setAttribute("role", authUser.getRole());
                }
            }
        }

        chain.doFilter(req, res);
    }
}
