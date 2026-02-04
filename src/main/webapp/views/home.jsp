<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.authentication.AuthResult"%>
<%@page import="Models.entity.Tenant"%>
<%@page import="Models.entity.Staff"%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Home - RentHouse</title>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body class="bg-light">

<%
    AuthResult auth = (AuthResult) session.getAttribute("auth");
    String role = (auth == null) ? "GUEST" : auth.getRole();
    Tenant tenant = (auth == null) ? null : auth.getTenant();
    Staff staff = (auth == null) ? null : auth.getStaff();
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="<%=request.getContextPath()%>/home">RentHouse</a>

        <div class="d-flex gap-2">
            <% if ("GUEST".equals(role)) { %>
                <a class="btn btn-outline-light" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
            <% } else { %>
                <span class="navbar-text text-white-50">
                    Xin chào
                    <%= (tenant != null) ? tenant.getFullName() : staff.getFullName() %>
                    (<%= role %>)
                </span>
                <a class="btn btn-outline-light" href="<%=request.getContextPath()%>/logout">Đăng xuất</a>
            <% } %>
        </div>
    </div>
</nav>

<div class="container py-5">
    <div class="row g-4">
        <div class="col-lg-6">
            <h1 class="fw-bold">Trang chủ</h1>
            <p class="text-muted">Các nút sẽ thay đổi theo role sau khi đăng nhập.</p>

            <% if ("GUEST".equals(role)) { %>
                <a class="btn btn-primary" href="<%=request.getContextPath()%>/login">Đăng nhập ngay</a>
            <% } %>

            <%-- TENANT --%>
            <% if ("TENANT".equals(role) && tenant != null) { %>

                <% if (tenant.isMustSetPassword()) { %>
                    <div class="alert alert-warning mt-3">
                        Bạn cần đặt mật khẩu trước khi dùng đầy đủ chức năng.
                    </div>
                    <a class="btn btn-warning" href="<%=request.getContextPath()%>/tenant/set-password">
                        Đặt mật khẩu
                    </a>
                <% } else { %>
                    <div class="mt-3 d-flex gap-2 flex-wrap">
                        <a class="btn btn-primary" href="<%=request.getContextPath()%>/tenant/contract">Hợp đồng của tôi</a>
                        <a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/maintenance">Yêu cầu sửa chữa</a>
                    </div>

                    <% if ("LOCKED".equalsIgnoreCase(tenant.getAccountStatus())) { %>
                        <div class="alert alert-info mt-3">
                            Tài khoản đang LOCKED (chưa active). Bạn chỉ dùng được một số chức năng.
                        </div>
                    <% } %>
                <% } %>
            <% } %>

            <%-- MANAGER --%>
            <% if ("MANAGER".equals(role)) { %>
                <div class="mt-3">
                    <a class="btn btn-success" href="<%=request.getContextPath()%>/manager/home">Manager Dashboard</a>
                </div>
            <% } %>

            <%-- ADMIN --%>
            <% if ("ADMIN".equals(role)) { %>
                <div class="mt-3">
                    <a class="btn btn-danger" href="<%=request.getContextPath()%>/admin/home">Admin Dashboard</a>
                </div>
            <% } %>
        </div>

        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">Chức năng</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item">Phòng / Hợp đồng</li>
                        <li class="list-group-item">Hóa đơn / Thanh toán</li>
                        <li class="list-group-item">Maintenance Request</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/js/main.js"></script>
</body>
</html>
