<%-- 
    Document   : layout
    Created on : Nov 2, 2025, 3:01:05 AM
    Author     : Duong Thien Nhan - CE190741
--%>

<%@tag body-content="scriptless" pageEncoding="UTF-8"%>
<%@tag import="Models.authentication.AuthUser"%>

<%@attribute name="title" required="false" type="java.lang.String"%>
<%@attribute name="active" required="false" type="java.lang.String"%>
<%@attribute name="cssFile" required="false" type="java.lang.String"%>

<%
    // 1. KHÔNG khai báo lại biến 'request'. Sử dụng trực tiếp biến ẩn 'request'.
    String ctx = request.getContextPath();

    // 2. Lấy session trực tiếp từ biến ẩn 'session'
    AuthUser auth = null;
    if (session != null) {
        auth = (AuthUser) session.getAttribute("auth");
    }

    // 3. Xử lý logic hiển thị (Giữ nguyên logic của bạn nhưng dùng biến an toàn hơn)
    String fullName = (auth != null && auth.getFullName() != null && !auth.getFullName().isBlank())
            ? auth.getFullName().trim() : "Guest";
    
    String role = (auth != null && auth.getRole() != null) ? auth.getRole().trim() : "";
    
    // Sửa lỗi substring nếu fullName rỗng
    String first = (fullName != null && !fullName.isEmpty()) ? fullName.substring(0, 1).toUpperCase() : "G";

    String _title = (title != null && !title.isBlank()) ? title : "LandHouse";
    String _active = (active != null) ? active : "";
    String _css = (cssFile != null && !cssFile.isBlank()) ? cssFile : (ctx + "/assets/css/profile.css");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%=_title%></title>
    <link rel="stylesheet" href="<%=_css%>">
    <link rel="stylesheet" href="<%=ctx%>/assets/css/style.css">
    <link rel="icon" type="image/png" href="<%=ctx%>/assets/images/logo.png">
</head>

<body>
<div class="layout">

    <aside class="sidebar" id="mySidebar">
        <div class="logo-box">
            <img src="<%=ctx%>/assets/images/logo.png" alt="LANDHOUSE" class="logo">
        </div>

        <div class="menu-title">Menu</div>

        <nav class="menu">
            <%-- TENANT menu --%>
            <% if ("TENANT".equalsIgnoreCase(role)) { %>
                <a class="<%="tenant-room".equals(_active) ? "active" : ""%>" href="<%=ctx%>/tenant/room">Phòng của bạn</a>
                <a class="<%="tenant-contract".equals(_active) ? "active" : ""%>" href="<%=ctx%>/tenant/contract">Hợp đồng thuê</a>
                <a class="<%="tenant-bill".equals(_active) ? "active" : ""%>" href="<%=ctx%>/tenant/bill">Hóa đơn</a>
                <a class="<%="tenant-history".equals(_active) ? "active" : ""%>" href="<%=ctx%>/tenant/payment-history">Lịch sử thanh toán</a>
                <a class="<%="tenant-utility".equals(_active) ? "active" : ""%>" href="<%=ctx%>/tenant/utility">Dịch vụ</a>
                <a class="<%="tenant-rules".equals(_active) ? "active" : ""%>" href="<%=ctx%>/tenant/rules">Quy định nhà trọ</a>
            <% } %>

            <%-- MANAGER menu --%>
            <% if ("MANAGER".equalsIgnoreCase(role)) { %>
                <a class="<%="manager-dashboard".equals(_active) ? "active" : ""%>" href="<%=ctx%>/manager/dashboard">Manager Dashboard</a>
            <% } %>

            <%-- ADMIN menu --%>
            <% if ("ADMIN".equalsIgnoreCase(role)) { %>
                <a class="<%="admin-dashboard".equals(_active) ? "active" : ""%>" href="<%=ctx%>/admin/dashboard">Admin Dashboard</a>
            <% } %>

            <a class="<%="profile".equals(_active) ? "active" : ""%>" href="<%=ctx%>/profile">Thông tin tài khoản</a>
            <a class="<%="home".equals(_active) ? "active" : ""%>" href="<%=ctx%>/home">Home</a>
        </nav>
    </aside>

    <main class="main">
        <div class="topbar">
           <div class="hamburger" id="toggleBtn" title="menu">☰</div>

            <div class="user-card">
                <div class="avatar"><%=first%></div>
                <div class="user-name">
                    <div class="name text-truncate" style="max-width: 150px;"><%=fullName%></div>
                    <div class="sub"><%=(role.isBlank() ? "GUEST" : role)%></div>
                </div>

                <% if (auth == null) { %>
                    <a class="logout" href="<%=ctx%>/login">Login</a>
                <% } else { %>
                    <a class="logout" href="<%=ctx%>/logout">Logout</a>
                <% } %>
            </div>
        </div>
        <jsp:doBody />
    </main>
    <script src="<%=ctx%>/assets/js/hideMenu.js"></script>
</div>
</body>
</html>