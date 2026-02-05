<%-- 
    Document   : login
    Created on : 02/06/2026, 4:22:57 AM
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/login.css">
</head>
<body>
<div class="login-box">
    <h2>Đăng nhập</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
        <p style="color:red;"><%= error %></p>
    <% } %>

    <form action="<%=request.getContextPath()%>/login" method="post">
        <div>
            <label>Email:</label>
            <input type="text" name="email"/>
        </div>
        <div>
            <label>Mật khẩu:</label>
            <input type="password" name="password"/>
        </div>
        <button type="submit">Login</button>
    </form>
</div>
</body>

</html>
