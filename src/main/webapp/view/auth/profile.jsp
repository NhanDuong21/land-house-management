<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.authentication.AuthUser"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Profile</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/profile.css">
        <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/assets/images/logo.png">
    </head>

    <body>
        <%
            String ctx = request.getContextPath();
            AuthUser auth = (AuthUser) session.getAttribute("auth");

            String fullName = (auth != null && auth.getFullName() != null) ? auth.getFullName() : "User";
            String role = (auth != null && auth.getRole() != null) ? auth.getRole() : "";

            String username = (String) request.getAttribute("p_username");
            String email = (String) request.getAttribute("p_email");
            String phone = (String) request.getAttribute("p_phone");
            String identity = (String) request.getAttribute("p_identity");

            String msg = (String) request.getAttribute("msg");
            String error = (String) request.getAttribute("error");

            // mask CCCD: ********1234
            String maskedId = "";
            if (identity != null && identity.length() >= 4) {
                String last4 = identity.substring(identity.length() - 4);
                maskedId = "********" + last4;
            } else {
                maskedId = (identity != null ? identity : "");
            }
        %>

        <div class="layout">

            <!-- SIDEBAR (demo giống tenant menu như ảnh) -->
            <aside class="sidebar">
                <div class="logo-box">
                    <img src="<%=ctx%>/assets/images/logo.png" alt="LANDHOUSE" class="logo">
                </div>

                <div class="menu-title">Menu</div>

                <nav class="menu">
                    <% if ("TENANT".equalsIgnoreCase(role)) {%>
                    <a href="<%=ctx%>/tenant/room">Phòng của bạn</a>
                    <a href="<%=ctx%>/tenant/contract">Hợp đồng thuê</a>
                    <a href="<%=ctx%>/tenant/bill">Hóa đơn</a>
                    <a href="<%=ctx%>/tenant/payment-history">Lịch sử thanh toán</a>
                    <a href="<%=ctx%>/tenant/utility">Dịch vụ</a>
                    <a href="<%=ctx%>/tenant/rules">Quy định nhà trọ</a>
                    <% } else if ("MANAGER".equalsIgnoreCase(role)) {%>
                    <a href="<%=ctx%>/manager/dashboard">Manager Dashboard</a>
                    <% } else if ("ADMIN".equalsIgnoreCase(role)) {%>
                    <a href="<%=ctx%>/admin/dashboard">Admin Dashboard</a>
                    <% }%>

                    <a class="active" href="<%=ctx%>/profile">Thông tin tài khoản</a>
                    <a href="<%=ctx%>/home">Home</a>
                </nav>
            </aside>

            <!-- MAIN -->
            <main class="main">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="hamburger" title="menu">☰</div>

                    <div class="user-card">
                        <div class="avatar"><%= fullName.substring(0, 1).toUpperCase()%></div>
                        <div class="user-name">
                            <div class="name"><%= fullName%></div>
                            <div class="sub"><%= role%></div>
                        </div>
                        <a class="logout" href="<%=ctx%>/logout">Logout</a>
                    </div>
                </div>

                <% if (msg != null) {%>
                <div class="alert success"><%= msg%></div>
                <% } %>

                <% if (error != null) {%>
                <div class="alert error"><%= error%></div>
                <% }%>

                <!-- CARD: Thông tin tài khoản -->
                <section class="card">
                    <div class="card-title">Thông tin tài khoản</div>

                    <div class="form-grid">
                        <div class="field">
                            <label>Username</label>
                            <input type="text" value="<%= (username != null ? username : "")%>" readonly>
                        </div>

                        <div class="field">
                            <label>Email</label>
                            <input type="text" value="<%= (email != null ? email : "")%>" readonly>
                        </div>

                        <div class="field">
                            <label>Full name</label>
                            <input type="text" value="<%= fullName%>" readonly>
                        </div>

                        <div class="field">
                            <label>Số điện thoại</label>
                            <input type="text" value="<%= (phone != null ? phone : "")%>" readonly>
                        </div>

                        <div class="field full">
                            <label>Số Căn Cước Công Dân</label>
                            <input type="text" value="<%= maskedId%>" readonly>
                        </div>

                        <div class="actions">
                            <a class="btn" href="<%=ctx%>/profile/edit">Chỉnh sửa</a>
                        </div>
                    </div>
                </section>

                <!-- CARD: Thay đổi mật khẩu -->
                <section class="card">
                    <div class="card-title">Thay đổi mật khẩu</div>

                    <form method="post" action="<%=ctx%>/profile" class="pw-form">
                        <div class="field full">
                            <label>Mật khẩu cũ</label>
                            <input type="password" name="oldPassword" placeholder="Nhập mật khẩu cũ" required>
                        </div>

                        <div class="pw-row">
                            <div class="field">
                                <label>Nhập mật khẩu mới</label>
                                <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                            </div>

                            <div class="field">
                                <label>Nhập lại mật khẩu mới</label>
                                <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" required>
                            </div>
                        </div>

                        <div class="pw-actions">
                            <button type="submit" class="btn">Xác nhận thay đổi</button>
                        </div>
                    </form>
                </section>

            </main>
        </div>

    </body>
</html>
