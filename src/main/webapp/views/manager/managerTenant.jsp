<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.entity.Tenant" %>

<html>
<head>
    <title>Tenant List</title>
</head>
<body>

<h2>Danh sách Tenant</h2>

<table border="1">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Identity Code</th>
        <th>Phone</th>
        <th>Email</th>
        <th>Date of Birth</th>
    </tr>

    <%
        List<Tenant> list = (List<Tenant>) request.getAttribute("tenants");
        for (Tenant t : list) {
    %>
    <tr>
        <td><%= t.getTenantId() %></td>
<td><%= t.getFullName() %></td>
<td><%= t.getIdentityCode() %></td>
<td><%= t.getPhoneNumber() %></td>
<td><%= t.getEmail() %></td>
<td><%= t.getDateOfBirth() %></td>
    </tr>
    <% } %>

</table>

</body>
</html>