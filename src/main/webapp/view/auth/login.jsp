<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Login</title>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
    </head>

    <body>
        <div class="login-page">

            <!-- NỀN SÓNG XANH -->
            <div class="top-wave"></div>

            <!-- CARD LOGIN -->
            <div class="login-card">

                <!-- LOGO TRONG CARD -->
                <div class="logo">
                    <img src="<%=request.getContextPath()%>/assets/images/logo.png" alt="Logo">
                </div>

                <h2>Welcome Back !</h2>
                <p class="subtitle">Sign in to continue.</p>

                <form action="<%=request.getContextPath()%>/login" method="post">

                    <%
                        String error = (String) request.getAttribute("error");
                        String oldUsername = (String) request.getAttribute("username"); // LoginServlet có thể set lại
                        if (oldUsername == null) oldUsername = "";
                    %>

                    <% if (error != null) { %>
                        <p style="color:red; text-align:center; margin-bottom:10px;">
                            <%= error %>
                        </p>
                    <% } %>

                    <label>Username</label>
                    <input type="text" name="username" placeholder="Enter username" required
                           value="<%= oldUsername %>">

                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter password" required>

                    <!-- REMEMBER + FORGOT -->
                    <div class="options-row">
                        <label class="remember">
                            <input type="checkbox" name="remember" value="1">
                            Remember me
                        </label>

                        <a href="#" class="forgot">Forgot password?</a>
                    </div>

                    <button type="submit">LOGIN</button>

                    <%-- 
                        REMEMBER ME (TODO LATER)
                        - Nếu user tick remember => servlet sẽ tạo token + set cookie
                        - Cookie path phải là request.getContextPath()
                    --%>
                </form>

                <p class="switch">
                    Don't have an account?
                    <a href="<%=request.getContextPath()%>/register">Sign up</a>
                </p>

            </div>

            <!-- FOOTER -->
            <footer>
                <a href="https://github.com/NhanDuong21/land-house-management"
                   target="_blank"
                   rel="noopener noreferrer">
                    2026 © SWP391 - Group 4 - LandHouseManagement
                </a>
            </footer>

        </div>
    </body>
</html>
