<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.authentication.AuthUser"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Home</title>

         <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/home.css"> 

 
    </head>

    <body>
        <%
            String ctx = request.getContextPath();

            AuthUser auth = null;
            if (session != null) {
                auth = (AuthUser) session.getAttribute("auth");
            }

            String fullName = "Guest";
            String role = "";

            if (auth != null) {
                if (auth.getFullName() != null && !auth.getFullName().trim().isEmpty()) {
                    fullName = auth.getFullName().trim();
                }
                if (auth.getRole() != null) {
                    role = auth.getRole().trim();
                }
            }
        %>

        <div class="wrap">

            <div class="top">
                <h2>🏠 Land House Management System</h2>

                <%-- Nếu chưa login --%>
                <% if (auth == null) {%>
                <div>
                    <a class="btn" href="<%=ctx%>/login">Login</a>
                </div>
                <% } else {%>
                <div>
                    <a class="btn gray" href="<%=ctx%>/profile">Profile</a>
                    <a class="btn red" href="<%=ctx%>/logout">Logout</a>
                </div>
                <% } %>
            </div>

            <hr>

            <%-- GUEST --%>
            <% if (auth == null) { %>
            <p>👋 Xin chào! Bạn chưa đăng nhập.</p>
            <p>Hãy bấm nút <b>Login</b> để vào hệ thống.</p>

            <%-- LOGGED IN --%>
            <% } else {%>
            <p>✅ Xin chào: <b><%=fullName%></b></p>
            <p>Vai trò: <b><%=role%></b></p>

            <div class="rolebox">
                <h3>🔧 Trang quản lý</h3>

                <% if ("TENANT".equalsIgnoreCase(role)) {%>
                <a class="btn" href="<%=ctx%>/tenant/dashboard">Vào trang Tenant</a>

                <% } else if ("MANAGER".equalsIgnoreCase(role)) {%>
                <a class="btn" href="<%=ctx%>/manager/dashboard">Vào trang Manager</a>

                <% } else if ("ADMIN".equalsIgnoreCase(role)) {%>
                <a class="btn" href="<%=ctx%>/admin/dashboard">Vào trang Admin</a>

                <% } else { %>
                <p style="color:red;">
                    ⚠ Không xác định role, kiểm tra lại auth.getRole()
                </p>
                <% } %>
            </div>

            <% }%>

        </div>

    </body>
</html>
