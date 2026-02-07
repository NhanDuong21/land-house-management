<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/login.css">
    </head>
    <body>

        <!-- overlay -->
        <div class="login-overlay">
            <div class="login-card">
                <h2 class="login-title">Login to RentHouse</h2>
                <p class="login-sub">Enter your credentials to access your account</p>

                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) {%>
                <div class="login-error"><%= error%></div>
                <% }%>

                <form action="<%=request.getContextPath()%>/login" method="post" class="login-form">
                    <div class="form-group">
                        <label class="login-label">Email</label>
                        <input class="login-input form-control" type="text" name="email" placeholder="your.email@example.com" required>
                    </div>

                    <div class="form-group">
                        <label class="login-label">Password</label>
                        <input class="login-input form-control" type="password" name="password" placeholder="Enter your password" required>
                    </div>
                    <label>
                        <input type="checkbox" name="remember" value="on">
                        Remember me
                    </label>

                    <button class="login-btn" type="submit">Login</button>
                </form>
            </div>
        </div>

    </body>
</html>
