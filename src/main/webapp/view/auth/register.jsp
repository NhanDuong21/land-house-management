<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/register.css">
    <link rel="icon" type="image/png" href="<%=request.getContextPath()%>/assets/images/logo.png">
</head>
<body>
<%
    String ctx = request.getContextPath();
    String error = (String) request.getAttribute("error");

    String username = (String) request.getAttribute("username");
    String email = (String) request.getAttribute("email");
    String fullName = (String) request.getAttribute("fullName");
    String gender = (String) request.getAttribute("gender");
%>

<div class="auth-wrap">
    <div class="auth-card">
        <div class="brand">
            <img src="<%=ctx%>/assets/images/logo.png" alt="logo">
            <h2>Welcome to Landhouse</h2>
        </div>

        <% if (error != null) { %>
            <div class="alert"><%=error%></div>
        <% } %>

        <form method="post" action="<%=ctx%>/register" class="form">

            <label>Tài khoản<span>*</span></label>
            <input type="text" name="username" placeholder="Nhập tên đăng nhập" required
                   value="<%=username!=null?username:""%>">

            <label>Địa chỉ e-mail<span>*</span></label>
            <input type="email" name="email" placeholder="Nhập địa chỉ e-mail" required
                   value="<%=email!=null?email:""%>">

            <label>Họ và tên<span>*</span></label>
            <input type="text" name="fullName" placeholder="Nhập họ và tên" required
                   value="<%=fullName!=null?fullName:""%>">

            <label>Mật khẩu<span>*</span></label>
            <input type="password" name="password" placeholder="Nhập mật khẩu" required>

            <label>Xác nhận mật khẩu<span>*</span></label>
            <input type="password" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>

            <div class="gender">
                <span>Giới tính:<span class="req">*</span></span>

                <label>
                    <input type="radio" name="gender" value="1" <%= "1".equals(gender) ? "checked" : "" %> >
                    Nam
                </label>

                <label>
                    <input type="radio" name="gender" value="0" <%= "0".equals(gender) ? "checked" : "" %> >
                    Nữ
                </label>

                <label>
                    <input type="radio" name="gender" value="2" <%= "2".equals(gender) ? "checked" : "" %> >
                    Khác
                </label>
            </div>

            <button type="submit" class="btn">ĐĂNG KÝ NGAY</button>
        </form>

        <div class="bottom">
            Bạn đã có tài khoản?
            <a href="<%=ctx%>/login">Đăng nhập ngay</a>
        </div>
    </div>
</div>

</body>
</html>
