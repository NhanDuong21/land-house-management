<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Account"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <!-- nếu sau này có css giống login -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
    </head>
    <body>

        <%          
            Account acc = null;
            if (session != null) {
                acc = (Account) session.getAttribute("account");
            }
        %>

        <!-- HEADER -->
        <div class="header">
            <h1>Land House Management System</h1>

            <% if (acc == null) { %>
                <!-- GUEST -->
                <a href="login">Login</a>
                |
                <a href="register">Register</a>
            <% } else { %>
                <!-- LOGGED IN -->
                Welcome, <b><%= acc.getUsername() %></b>
                |
                <a href="logout">Logout</a>
            <% } %>
        </div>

        <hr/>

        <!-- CONTENT -->
        <h2>Welcome to our system</h2>
        <p>This is the public home page. Anyone can access.</p>

        <!-- DEMO CONTENT -->
        <ul>
            <li>Browse available houses</li>
            <li>View rooms</li>
            <li>Contact manager</li>
        </ul>

    </body>
</html>
