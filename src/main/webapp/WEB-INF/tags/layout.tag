<%-- 
    Document   : layout
    Created on : 02/06/2026, 4:22:57 AM
    Author     : Duong Thien Nhan - CE190741
--%>
<%@tag pageEncoding="UTF-8" body-content="scriptless"%>
<%@tag import="Models.authentication.AuthResult"%>
<%@tag import="Models.entity.Tenant"%>
<%@tag import="Models.entity.Staff"%>

<%@attribute name="title" required="false" type="java.lang.String"%>
<%@attribute name="active" required="false" type="java.lang.String"%>
<%@attribute name="cssFile" required="false" type="java.lang.String"%>

<%
    String ctx = request.getContextPath();

    AuthResult auth = (AuthResult) session.getAttribute("auth");
    String role = (auth == null || auth.getRole() == null) ? "GUEST" : auth.getRole();

    Tenant tenant = (auth == null) ? null : auth.getTenant();
    Staff staff = (auth == null) ? null : auth.getStaff();

    String displayName = "Guest";
    if (!"GUEST".equalsIgnoreCase(role)) {
        displayName = (tenant != null && tenant.getFullName() != null) ? tenant.getFullName()
                : (staff != null && staff.getFullName() != null) ? staff.getFullName()
                : "User";
    }
    String firstLetter = (displayName != null && !displayName.isBlank())
            ? displayName.trim().substring(0, 1).toUpperCase()
            : "G";

    String _title = (title == null || title.isBlank()) ? "RentHouse" : title;
    String _active = (active == null) ? "" : active;

    // cssFile optional (page css)
    String pageCss = (cssFile == null || cssFile.isBlank()) ? null : cssFile;

    boolean isTenant = "TENANT".equalsIgnoreCase(role);
    boolean isManager = "MANAGER".equalsIgnoreCase(role);
    boolean isAdmin = "ADMIN".equalsIgnoreCase(role);
%>

<!doctype html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%=_title%></title>
        <link rel="icon" type="image/png"
              href="${pageContext.request.contextPath}/assets/images/favicon_logo.png">


        <link rel="stylesheet" href="<%=ctx%>/assets/css/layout.css">
        <% if (pageCss != null) {%>
        <link rel="stylesheet" href="<%=pageCss%>">
        <% }%>
    </head>

    <body>
        <div class="rh-layout">

            <!-- SIDEBAR -->
            <aside class="rh-sidebar" id="rhSidebar">
                <div class="rh-logo">
                    <a href="<%=ctx%>/home">
                        <img src="<%=ctx%>/assets/images/logo.png" alt="RentHouse">
                    </a>
                </div>

                <nav class="rh-menu">
                    <a class="rh-link <%= "home".equals(_active) ? "active" : ""%>" href="<%=ctx%>/home">Home</a>
                    <a class="rh-link <%= "contact".equals(_active) ? "active" : ""%>" href="<%=ctx%>/contact">Contact</a>

                    <% if (isTenant) {%>
                    <div class="rh-section">Tenant</div>
                    <a class="rh-link" href="<%=ctx%>/tenant/room">My Room</a>
                    <a class="rh-link" href="<%=ctx%>/tenant/contract">My Contract</a>
                    <a class="rh-link" href="<%=ctx%>/tenant/bill">My Bills</a>
                    <a class="rh-link" href="<%=ctx%>/maintenance">Maintenance Requests</a>
                    <a class="rh-link" href="<%=ctx%>/tenant/utility">Utility</a>
                    <a class="rh-link" href="<%=ctx%>/profile">Profile</a>
                    <% } %>

                    <% if (isManager || isAdmin) {%>
                    <div class="rh-section">Staff</div>
                    <a class="rh-link" href="<%=ctx%>/profile">Profile</a>
                    <% } %>

                    <div class="rh-spacer"></div>

                    <% if (isManager) {%>
                    <a class="rh-dashboard manager" href="<%=ctx%>/manager/home">Manager Dashboard</a>
                    <% } else if (isAdmin) {%>
                    <a class="rh-dashboard admin" href="<%=ctx%>/admin/home">Admin Dashboard</a>
                    <% }%>
                </nav>
            </aside>

            <!-- MAIN -->
            <main class="rh-main">

                <!-- HEADER -->
                <header class="rh-topbar">
                    <div class="rh-topbar-left">
                        <button class="rh-icon-btn" type="button" id="rhToggleSidebar">☰</button>
                    </div>

                    <div class="rh-topbar-right">
                        <!-- Filter icon chỉ là UI tượng trưng -->
                        <button class="rh-icon-btn" type="button" id="rhOpenFilter" title="Filter">🔎</button>

                        <div class="rh-user">
                            <div class="rh-avatar"><%=firstLetter%></div>
                            <div class="rh-user-meta">
                                <div class="rh-user-name"><%=displayName%></div>
                                <div class="rh-user-role"><%=role%></div>
                            </div>

                            <% if (auth == null) {%>
                            <a class="rh-btn primary" href="<%=ctx%>/login">Login</a>
                            <% } else {%>
                            <a class="rh-btn outline" href="<%=ctx%>/logout">Logout</a>
                            <% }%>
                        </div>
                    </div>
                </header>

                <!-- BODY -->
                <section class="rh-content">
                    <jsp:doBody/>
                </section>

                <!-- FOOTER -->
                <footer class="rh-footer">
                    <span>2026 © SWP391 - Group 4</span>
                    <span class="rh-dot">•</span>
                    <a href="https://github.com/NhanDuong21/land-house-management"
                       target="_blank">LandHouseManagement</a>
                </footer>


            </main>
        </div>

        <script src="<%=ctx%>/assets/js/layout.js"></script>
    </body>
</html>
