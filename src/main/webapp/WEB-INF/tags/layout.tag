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

    // 3. Xử lý logic hiển thị
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
                    <a href="<%=ctx%>/home">
                        <img src="<%=ctx%>/assets/images/logo.png" alt="LANDHOUSE" class="logo">
                    </a>
                </div>

                <div class="menu-title">Menu</div>

                <nav class="menu">
                    <%
                        boolean isTenant = "TENANT".equalsIgnoreCase(role);
                        boolean isGuest = (role == null || role.isBlank());
                    %>
                    <a class="<%="profile".equals(_active) ? "active" : ""%>" href="<%=ctx%>/profile">Account information</a>
                    <%-- TENANT menu (Hiển thị cho Tenant HOẶC Guest) --%>
                    <%-- Manager và Admin sẽ không thấy menu này (vì isTenant và isGuest đều false) --%>
                    <% if (isTenant || isGuest) {%>
                    <a class="<%="tenant-room".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/room" : ctx + "/login"%>">
                        Your room
                    </a>

                    <a class="<%="tenant-contract".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/contract" : ctx + "/login"%>">
                        Contracts
                    </a>

                    <a class="<%="tenant-bill".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/bill" : ctx + "/login"%>">
                        Bill
                    </a>

                    <a class="<%="tenant-history".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/payment-history" : ctx + "/login"%>">
                        Payment history
                    </a>

                    <a class="<%="tenant-utility".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/utility" : ctx + "/login"%>">
                        Utility
                    </a>

                    <a class="<%="tenant-request".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/request" : ctx + "/login"%>">
                        Mantain Request
                    </a>

                    <a class="<%="tenant-rules".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/rules" : ctx + "/login"%>">
                        Regulations for lodging houses
                    </a>

                    <a class="<%="tenant-notification".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/notification" : ctx + "/login"%>">
                        Notification
                    </a>

                    <a class="<%="tenant-contact".equals(_active) ? "active" : ""%>" 
                       href="<%= isTenant ? ctx + "/tenant/contact" : ctx + "/login"%>">
                        Contact
                    </a>
                    <% } %>

                    <%-- MANAGER menu --%>
                    <% if ("MANAGER".equalsIgnoreCase(role)) {%>
                    <a class="<%="manager-dashboard".equals(_active) ? "active" : ""%>" href="<%=ctx%>/manager/dashboard">Manager Dashboard</a>
                    <% } %>

                    <%-- ADMIN menu --%>
                    <% if ("ADMIN".equalsIgnoreCase(role)) {%>
                    <a class="<%="admin-dashboard".equals(_active) ? "active" : ""%>" href="<%=ctx%>/admin/dashboard">Admin Dashboard</a>
                    <% }%>
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

                        <% if (auth == null) {%>
                        <a class="logout" href="<%=ctx%>/login">Login</a>
                        <% } else {%>
                        <a class="logout" href="<%=ctx%>/logout">Logout</a>
                        <% }%>
                    </div>
                </div>
                <jsp:doBody />
                <footer class="main-footer">
                    <div class="footer-line"></div> <a href="https://github.com/NhanDuong21/land-house-management"
                                                       target="_blank"
                                                       rel="noopener noreferrer">
                        2026 © SWP391 - Group 4 - LandHouseManagement
                    </a>
                </footer>
            </main>

            <script src="<%=ctx%>/assets/js/hideMenu.js"></script>
        </div>
    </body>
</html>