package Filters;

import java.io.IOException;

import DALs.contract.ContractDAO;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

/**
 * 1. Cơ chế "Kí sinh" vào Request (Request-based Execution) Thay vì tạo một con
 * Bot chạy ngầm trong Server (tốn tài nguyên), Filter này "kí sinh" vào mỗi lần
 * người dùng truy cập trang web.
 *
 *  *Khi có bất kỳ request nào gửi đến (không phải file tĩnh như ảnh, css),
 * Filter sẽ kiểm tra xem đã đến lúc cần quét dữ liệu chưa.
 *
 *  *2. Logic "Phanh" (Throttling) để tránh quá tải Đây là phần quan trọng nhất
 * của đoạn code: THROTTLE_MS = 60_000 (1 phút).
 *
 *  *Vấn đề: Nếu trang web có 1000 người truy cập cùng lúc, hệ thống sẽ gọi DB
 * 1000 lần để quét hợp đồng hết hạn -> Gây lag/chết Database.
 *
 *  *Giải pháp: * Code sử dụng ServletContext (biến môi trường toàn cục của ứng
 * dụng) để lưu lại mốc thời gian cuối cùng nó chạy (EXPIRE_LAST_RUN_MS).
 *
 *  *Mỗi khi có người vào, nó lấy Thời gian hiện tại - Thời gian chạy lần cuối.
 *
 *  *Nếu chưa đủ 60 giây, nó sẽ return ngay lập tức (không làm gì cả).
 *
 *  *Nếu đã qua 60 giây, nó cập nhật lại mốc thời gian mới và thực hiện
 * runExpireJobSafely(). giống logic đặt đồng hồ ở quán cafe
 *
 * @author Duong Thien Nhan - CE190741
 */
@WebFilter("/*")
public class ContractExpireFilter implements Filter {

    private static final String CTX_KEY_LAST_RUN = "EXPIRE_LAST_RUN_MS";
    private static final long THROTTLE_MS = 60_000; // 1 phut de demo cho le, dung nghiep vu co the de 1d

    private final ContractDAO contractDAO = new ContractDAO();

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;

        String ctx = request.getContextPath();
        String uri = request.getRequestURI();

        boolean isStatic = uri.startsWith(ctx + "/assets/");
        if (!isStatic) {
            runWithThrottle(request);
        }

        chain.doFilter(req, res);
    }

    private void runWithThrottle(HttpServletRequest request) {
        var app = request.getServletContext();
        long now = System.currentTimeMillis();

        Object lastObj = app.getAttribute(CTX_KEY_LAST_RUN);
        long last = (lastObj instanceof Long) ? (Long) lastObj : 0L;

        if (now - last < THROTTLE_MS) {
            return;
        }

        app.setAttribute(CTX_KEY_LAST_RUN, now);
        contractDAO.runExpireJobSafely();
    }
}
