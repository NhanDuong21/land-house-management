<%--
    Document   : login
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Login - RentHouse</title>

        <link rel="icon" type="image/png"
              href="${pageContext.request.contextPath}/assets/images/logo/favicon_logo.png">

        <!-- Bootstrap base -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/base/bootstrap.min.css">
        <!-- Bootstrap Icons (layout của bạn dùng CDN, login không qua layout nên tự include) -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <!-- Page CSS -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/views/login.css">
    </head>

    <body>
        <div class="login-shell">

            <!-- LEFT: BRAND -->
            <section class="login-brand">
                <div class="brand-top">
                    <div class="brand-mark">
                        <img src="<%=request.getContextPath()%>/assets/images/logo/logo.png" alt="RentHouse"/>
                    </div>

                    <div class="brand-name">RentHouse</div>
                    <div class="brand-tagline">
                        Quản lý nhà trọ • Hợp đồng • Hóa đơn • Bảo trì
                    </div>

                    <div class="brand-pills">
                        <span class="pill"><i class="bi bi-building"></i> Rooms</span>
                        <span class="pill"><i class="bi bi-file-earmark-text"></i> Contracts</span>
                        <span class="pill"><i class="bi bi-receipt"></i> Bills</span>
                        <span class="pill"><i class="bi bi-tools"></i> Maintenance</span>
                    </div>
                </div>

                <div class="brand-card">
                    <div class="brand-card-title">Tối ưu cho quản lý nhà trọ</div>
                    <div class="brand-card-sub">
                        Theo dõi phòng trống, tenant, hợp đồng và hóa đơn nhanh – gọn – rõ ràng.
                    </div>

                    <div class="brand-stats">
                        <div class="stat">
                            <div class="stat-ico"><i class="bi bi-house-door"></i></div>
                            <div class="stat-body">
                                <div class="stat-num">Rooms</div>
                                <div class="stat-text">Danh sách phòng & trạng thái</div>
                            </div>
                        </div>

                        <div class="stat">
                            <div class="stat-ico"><i class="bi bi-clipboard-check"></i></div>
                            <div class="stat-body">
                                <div class="stat-num">Contracts</div>
                                <div class="stat-text">Tạo & quản lý hợp đồng thuê</div>
                            </div>
                        </div>

                        <div class="stat">
                            <div class="stat-ico"><i class="bi bi-lightning-charge"></i></div>
                            <div class="stat-body">
                                <div class="stat-num">Utilities</div>
                                <div class="stat-text">Điện nước & thanh toán</div>
                            </div>
                        </div>
                    </div>

                    <div class="brand-note">
                        <i class="bi bi-shield-check"></i>
                        Bảo mật tài khoản và phân quyền theo vai trò.
                    </div>
                </div>

                <div class="brand-footer">
                    <span>2026 © SWP391 - Group 4</span>
                </div>
            </section>

            <!-- RIGHT: LOGIN PANEL -->
            <section class="login-panel">
                <div class="login-card">

                    <div class="login-head">
                        <div class="login-title">Đăng nhập</div>
                        <div class="login-sub">Vào hệ thống quản lý RentHouse</div>
                    </div>

                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) {%>
                    <div class="login-error">
                        <i class="bi bi-x-circle-fill"></i>
                        <span><%= error%></span>
                    </div>
                    <% }%>

                    <!-- TABS -->
                    <div class="login-tabs" role="tablist" aria-label="Login method">
                        <button type="button"
                                class="tab-btn is-active"
                                id="tabPassword"
                                data-target="formPassword"
                                aria-selected="true">
                            <i class="bi bi-lock"></i> Password
                        </button>
    
                        <button type="button"
                                class="tab-btn"
                                id="tabOtp"
                                data-target="formOtp"
                                aria-selected="false">
                            <i class="bi bi-key"></i> OTP
                        </button>
                    </div>

                    <!-- PASSWORD LOGIN -->
                    <form action="<%=request.getContextPath()%>/login"
                          method="post"
                          class="login-form"
                          id="formPassword">

                        <input type="hidden" name="mode" value="PASSWORD"/>

                        <div class="field">
                            <label class="field-label">Email</label>
                            <div class="field-control">
                                <span class="field-icon"><i class="bi bi-envelope"></i></span>
                                <input class="field-input"
                                       type="text"
                                       name="email"
                                       placeholder="your.email@example.com"
                                       autocomplete="username"
                                       required>
                            </div>
                        </div>

                        <div class="field">
                            <label class="field-label">Password</label>
                            <div class="field-control">
                                <span class="field-icon"><i class="bi bi-shield-lock"></i></span>
                                <input class="field-input"
                                       type="password"
                                       name="password"
                                       id="passwordInput"
                                       placeholder="Enter your password"
                                       autocomplete="current-password"
                                       required>

                                <button class="field-suffix-btn"
                                        type="button"
                                        id="togglePassword"
                                        aria-label="Show/Hide password">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="login-row">
                            <label class="check">
                                <input type="checkbox" name="remember" value="on">
                                <span>Remember me</span>
                            </label>

                            <a class="login-link" href="#" onclick="return false;">
                                Forgot password?
                            </a>
                        </div>

                        <button class="login-btn" type="submit">
                            <i class="bi bi-box-arrow-in-right"></i> Login
                        </button>

                        <div class="login-hint">
                            Lần đầu đăng nhập? Chọn tab <strong>OTP</strong>.
                        </div>
                    </form>

                    <!-- OTP LOGIN -->
                    <form action="<%=request.getContextPath()%>/login"
                          method="post"
                          class="login-form"
                          id="formOtp"
                          style="display:none;">

                        <input type="hidden" name="mode" value="OTP"/>

                        <div class="field">
                            <label class="field-label">Email</label>
                            <div class="field-control">
                                <span class="field-icon"><i class="bi bi-envelope"></i></span>
                                <input class="field-input"
                                       type="text"
                                       name="email"
                                       placeholder="your.email@example.com"
                                       autocomplete="username"
                                       required>
                            </div>
                        </div>

                        <div class="field">
                            <label class="field-label">OTP</label>
                            <div class="field-control">
                                <span class="field-icon"><i class="bi bi-key-fill"></i></span>
                                <input class="field-input"
                                       type="text"
                                       name="otp"
                                       inputmode="numeric"
                                       maxlength="6"
                                       placeholder="Nhập OTP 6 số"
                                       required>
                            </div>
                        </div>

                        <button class="login-btn" type="submit">
                            <i class="bi bi-box-arrow-in-right"></i> Login bằng OTP
                        </button>

                        <div class="login-hint">
                            OTP chỉ dùng cho lần đầu / khi hệ thống yêu cầu xác thực.
                        </div>
                    </form>

                </div>
            </section>
        </div>

        <script src="<%=request.getContextPath()%>/assets/js/vendor/bootstrap.bundle.min.js"></script>
        <script src="<%=request.getContextPath()%>/assets/js/pages/login.js"></script>
    </body>
</html>