<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>LandHouse Login</title>
</head>
<body>
<h2>Login</h2>

<% String err = (String) request.getAttribute("error"); %>
<% if (err != null) { %>
    <p style="color:red;"><%= err %></p>
<% } %>

<form action="<%=request.getContextPath()%>/login" method="post">
    <div>
        Username: <input type="text" name="username" required />
    </div>
    <div>
        Password: <input type="password" name="password" required />
    </div>
    <button type="submit">Login</button>
</form>
</body>
</html>
