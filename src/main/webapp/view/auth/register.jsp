<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Account | Landhouse</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/register.css">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/assets/images/logo.png">
</head>
<body>
<%
    String ctx = request.getContextPath();
    // Get attributes from Servlet
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success"); // Added for success logs

    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    String fullName = (String) request.getAttribute("fullName");
    String gender = (String) request.getAttribute("gender");
%>

<div class="auth-wrap">
    <div class="auth-card">
        <div class="brand">
            <img src="<%=ctx%>/assets/images/logo.png" alt="Landhouse Logo">
            <h2>Welcome to Landhouse</h2>
            <p style="color: #666; margin-bottom: 20px;">Join our community today</p>
        </div>

        <%-- Error Alert --%>
        <% if (error != null) { %>
            <div class="alert alert-danger" style="background: #fee2e2; color: #dc2626; padding: 12px; border-radius: 6px; margin-bottom: 15px; border: 1px solid #fecaca;">
                <%=error%>
            </div>
        <% } %>

        <%-- Success Alert --%>
        <% if (success != null || "1".equals(request.getParameter("registered"))) { %>
            <div class="alert alert-success" style="background: #dcfce7; color: #16a34a; padding: 12px; border-radius: 6px; margin-bottom: 15px; border: 1px solid #bbf7d0;">
                Registration successful! <a href="<%=ctx%>/login" style="font-weight: bold; color: #16a34a;">Login here</a>
            </div>
        <% } %>

        <form method="post" action="<%=ctx%>/register" class="form">

            <label>Username<span>*</span></label>
            <input type="text" name="username" placeholder="Enter your username" required
                   value="<%=username != null ? username : ""%>">

            <label>Email Address<span>*</span></label>
            <input type="email" name="email" placeholder="example@domain.com" required
                   value="<%=email != null ? email : ""%>">

            <label>Full Name<span>*</span></label>
            <input type="text" name="fullName" placeholder="Enter your full name" required
                   value="<%=fullName != null ? fullName : ""%>">

            <label>Password<span>*</span></label>
            <input type="password" name="password" placeholder="Create a password" required>

            <label>Confirm Password<span>*</span></label>
            <input type="password" name="confirmPassword" placeholder="Confirm your password" required>

            <div class="gender">
                <span style="display: block; margin-bottom: 8px; font-weight: 600;">Gender:<span class="req">*</span></span>

                <div style="display: flex; gap: 15px;">
                    <label style="font-weight: normal; cursor: pointer;">
                        <input type="radio" name="gender" value="1" <%= "1".equals(gender) ? "checked" : "" %> >
                        Male
                    </label>

                    <label style="font-weight: normal; cursor: pointer;">
                        <input type="radio" name="gender" value="0" <%= "0".equals(gender) ? "checked" : "" %> >
                        Female
                    </label>

                    <label style="font-weight: normal; cursor: pointer;">
                        <input type="radio" name="gender" value="2" <%= "2".equals(gender) ? "checked" : "" %> >
                        Other
                    </label>
                </div>
            </div>

            <button type="submit" class="btn" style="margin-top: 20px;">REGISTER NOW</button>
        </form>

        <div class="bottom" style="margin-top: 20px; text-align: center; font-size: 0.9rem;">
            Already have an account? 
            <a href="<%=ctx%>/login" style="color: #2563eb; text-decoration: none; font-weight: 600;">Login here</a>
        </div>
    </div>
</div>

</body>
</html>