<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Login - RentHouse</title>

  <link rel="icon" type="image/png"
        href="${pageContext.request.contextPath}/assets/images/logo/favicon_logo.png">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/base/bootstrap.min.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/views/login.css">
</head>

<body>
  <div class="login-shell">
    <!-- Left: Brand / illustration -->
    <section class="login-brand">
      <div class="brand-top">
        <div class="brand-mark">
          <img src="<%=request.getContextPath()%>/assets/images/logo/logo.png" alt="RentHouse"/>
        </div>
        <div class="brand-name">RentHouse</div>
        <div class="brand-tagline">Quản lý nhà trọ • Hợp đồng • Hóa đơn • Bảo trì</div>
      </div>

      <div class="brand-card">
        <div class="brand-card-title">Nhanh gọn cho quản lý</div>
        <div class="brand-card-sub">
          Theo dõi phòng trống, tenant, hợp đồng và hóa đơn trên một dashboard.
        </div>

        <div class="brand-stats">
          <div class="stat">
            <div class="stat-num">Rooms</div>
            <div class="stat-text">Quản lý danh sách phòng</div>
          </div>
          <div class="stat">
            <div class="stat-num">Bills</div>
            <div class="stat-text">Điện nước & thanh toán</div>
          </div>
          <div class="stat">
            <div class="stat-num">Support</div>
            <div class="stat-text">Bảo trì & yêu cầu</div>
          </div>
        </div>
      </div>

      <div class="brand-footer">
        <span>2026 © SWP391 - Group 4</span>
      </div>
    </section>

    <!-- Right: Form -->
    <section class="login-panel">
      <div class="login-card">
        <div class="login-head">
          <div class="login-title">Welcome back</div>
          <div class="login-sub">Đăng nhập để vào hệ thống quản lý nhà trọ</div>
        </div>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
          <div class="login-error"><%= error %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/login" method="post" class="login-form">
          <div class="field">
            <label class="field-label">Email</label>
            <div class="field-control">
              <span class="field-icon">📧</span>
              <input class="field-input" type="text" name="email"
                     placeholder="your.email@example.com" required>
            </div>
          </div>

          <div class="field">
            <label class="field-label">Password</label>
            <div class="field-control">
              <span class="field-icon">🔒</span>
              <input class="field-input" type="password" name="password"
                     placeholder="Enter your password" required>
            </div>
          </div>

          <div class="login-row">
            <label class="check">
              <input type="checkbox" id="remember" name="remember" value="on">
              <span>Remember me</span>
            </label>

            <a class="login-link" href="#" onclick="return false;">Forgot password?</a>
          </div>

          <button class="login-btn" type="submit">Login</button>

        </form>
      </div>
    </section>
  </div>

  <script src="<%=request.getContextPath()%>/assets/js/vendor/bootstrap.bundle.min.js"></script>
</body>
</html>
