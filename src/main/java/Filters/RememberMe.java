package Filters;

import java.io.IOException;

import DALs.AccountDAO;
import Models.Account;
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

        HttpSession session = request.getSession(false);

        // Nếu chưa login
        if (session == null || session.getAttribute("account") == null) {

            Cookie[] cookies = request.getCookies(); // client send all cookie of domain
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("Remember_me".equals(c.getName())) {

                        String token = c.getValue(); // get token(chuỗi random (UUID)) từ cookie
                        AccountDAO dao = new AccountDAO();
                        Account acc = dao.findByRememberToken(token); // check sự tồn tại của cookie

                        if (acc != null) { // cookie tồn tại => create new session vì trước đó user chưa login nên cần session mới để lưu account
                            HttpSession newSession = request.getSession(true);
                            newSession.setAttribute("account", acc);
                            newSession.setAttribute("role", acc.getRole());
                        }
                        break;
                    }
                }
            }
        }

        chain.doFilter(req, res); // allow request đi tiếp
    }
}
