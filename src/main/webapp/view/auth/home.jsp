<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.authentication.AuthUser"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Home</title>

        <!-- giữ theo contextPath như bạn đang làm -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">

        <style>
            :root{
                --sidebar-w: 290px;
                --bg: #f5f1ea;
                --sidebar: #14304a;
                --sidebar2: #1d4668;
                --white: #fff;
                --muted: rgba(255,255,255,0.75);
                --card: #ffffff;
                --shadow: 0 6px 18px rgba(0,0,0,0.10);
                --line: rgba(0,0,0,0.12);
                --accent: #86a0bf;
                --btn: #2d5f8f;
            }

            *{ box-sizing: border-box; }
            html,body{ height:100%; }
            body{
                margin:0;
                font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
                background: var(--bg);
                color:#1b1b1b;
            }

            /* App layout */
            .app{ display:flex; min-height:100vh; }

            /* Sidebar */
            .sidebar{
                width: var(--sidebar-w);
                background: linear-gradient(180deg, var(--sidebar) 0%, var(--sidebar2) 100%);
                color: var(--white);
                padding: 18px 14px;
                position: sticky;
                top:0;
                height: 100vh;
                overflow:auto;
            }
            .brand{
                display:flex;
                align-items:center;
                gap:10px;
                padding: 6px 10px 14px 10px;
                border-bottom: 1px solid rgba(255,255,255,0.12);
                margin-bottom: 12px;
            }
            .brand .logo{
                width:44px; height:44px;
                border-radius: 50%;
                background:#fff;
                color: var(--sidebar);
                display:flex; align-items:center; justify-content:center;
                font-weight: 800;
                letter-spacing: .5px;
            }
            .brand .name b{ display:block; font-size:14px; }
            .brand .name small{ color: var(--muted); }

            .menu-title{
                font-size: 13px;
                color: var(--muted);
                padding: 10px 10px 8px 10px;
                text-decoration: underline;
            }

            .nav{ display:flex; flex-direction:column; gap:10px; padding: 4px 6px 14px 6px; }
            .nav a{
                text-decoration:none;
                color:#fff;
                padding: 12px 12px;
                border-radius: 10px;
                background: rgba(255,255,255,0.08);
                display:flex;
                align-items:center;
                gap:10px;
                transition: .15s;
            }
            .nav a:hover{ background: rgba(255,255,255,0.14); }
            .nav a .icon{
                width:34px; height:34px;
                border-radius: 8px;
                background: rgba(255,255,255,0.12);
                display:flex; align-items:center; justify-content:center;
                font-weight:700;
            }
            .sidebar-footer{
                margin-top: 18px;
                padding: 10px 6px 6px 6px;
            }
            .contact-btn{
                width:100%;
                display:flex;
                align-items:center;
                justify-content:center;
                gap:10px;
                padding: 12px 12px;
                border-radius: 999px;
                background: #3aa64a;
                color:#fff;
                text-decoration:none;
                font-weight:700;
            }

            /* Main */
            .main{
                flex:1;
                padding: 16px 22px 40px 22px;
            }

            /* Topbar */
            .topbar{
                display:flex;
                align-items:center;
                justify-content: space-between;
                gap: 12px;
                padding: 10px 12px;
                background: rgba(255,255,255,0.55);
                border: 1px solid rgba(0,0,0,0.06);
                border-radius: 12px;
                margin-bottom: 16px;
            }
            .topbar .left{
                display:flex; align-items:center; gap:12px;
            }
            .hamburger{
                width:44px; height:40px;
                border-radius:10px;
                border: 1px solid rgba(0,0,0,0.10);
                background:#fff;
                cursor:pointer;
                display:flex; align-items:center; justify-content:center;
                font-size: 18px;
            }
            .topbar h1{
                margin:0;
                font-size: 16px;
                font-weight: 800;
            }

            /* User dropdown (góc phải như ảnh) */
            .userbox{
                position: relative;
            }
            .userbtn{
                display:flex;
                align-items:center;
                gap:10px;
                padding: 8px 10px;
                border-radius: 12px;
                background: #1a3956;
                color:#fff;
                border: none;
                cursor:pointer;
                min-width: 210px;
                justify-content: space-between;
            }
            .userbtn .info{
                display:flex; align-items:center; gap:10px;
            }
            .avatar{
                width:34px; height:34px;
                border-radius: 50%;
                background: rgba(255,255,255,0.25);
                display:flex; align-items:center; justify-content:center;
                font-weight:800;
            }
            .userbtn .name{
                display:flex; flex-direction:column; line-height:1.1;
                text-align:left;
            }
            .userbtn .name b{ font-size: 13px; }
            .userbtn .name small{ font-size: 12px; opacity: .85; }

            .dropdown{
                position:absolute;
                right:0;
                top: 52px;
                width: 240px;
                background: #90a6c3;
                border: 1px solid rgba(0,0,0,0.18);
                border-radius: 0 0 12px 12px;
                box-shadow: var(--shadow);
                display:none;
                overflow:hidden;
            }
            .dropdown a{
                display:flex;
                align-items:center;
                gap: 10px;
                padding: 12px 14px;
                color: #fff;
                text-decoration:none;
                border-top: 1px solid rgba(255,255,255,0.25);
                font-weight:700;
            }
            .dropdown a:hover{ background: rgba(0,0,0,0.08); }

            /* Cards list */
            .room-list{
                display:flex;
                flex-direction:column;
                gap: 18px;
                margin-top: 10px;
            }
            .room-card{
                background: rgba(255,255,255,0.55);
                border-radius: 12px;
                padding: 16px;
                border: 1px solid rgba(0,0,0,0.06);
            }
            .room-inner{
                background: var(--card);
                border-radius: 10px;
                padding: 14px;
                box-shadow: var(--shadow);
                display:grid;
                grid-template-columns: 520px 1fr;
                gap: 20px;
                align-items: start;
            }

            .gallery .main-img{
                width:100%;
                height: 240px;
                border: 2px solid rgba(0,0,0,0.18);
                border-radius: 6px;
                background: #eee;
                overflow:hidden;
            }
            .gallery .main-img img{
                width:100%; height:100%;
                object-fit: cover;
                display:block;
            }
            .thumbs{
                display:flex;
                gap: 14px;
                margin-top: 12px;
                justify-content: center;
            }
            .thumb{
                width: 120px;
                height: 70px;
                border: 2px solid rgba(0,0,0,0.18);
                border-radius: 4px;
                overflow:hidden;
                background:#eee;
            }
            .thumb img{ width:100%; height:100%; object-fit: cover; display:block; }

            .info-box{
                border: 2px solid rgba(0,0,0,0.30);
                border-radius: 6px;
                padding: 12px;
            }
            .info-title{
                font-weight: 900;
                font-size: 18px;
                margin: 0 0 10px 0;
                letter-spacing: .3px;
            }
            .info-row{
                display:grid;
                grid-template-columns: 140px 1fr;
                gap: 10px;
                margin: 10px 0;
                align-items:center;
            }
            .badge{
                background: var(--accent);
                color:#0d1b28;
                padding: 6px 10px;
                font-weight: 800;
                border-radius: 3px;
            }
            .value{
                background: var(--accent);
                color:#0d1b28;
                padding: 6px 10px;
                font-weight: 800;
                border-radius: 3px;
                text-align:center;
            }

            /* Role button area */
            .role-actions{
                display:flex;
                gap: 10px;
                flex-wrap: wrap;
                margin-top: 8px;
            }
            .btn{
                display:inline-flex;
                align-items:center;
                justify-content:center;
                padding: 10px 14px;
                border-radius: 10px;
                background: var(--btn);
                color:#fff;
                text-decoration:none;
                font-weight:800;
                border: 1px solid rgba(0,0,0,0.10);
            }
            .btn.gray{ background:#5a6b7c; }

            /* Guest simple */
            .guest-wrap{
                max-width: 920px;
                margin: 30px auto;
                padding: 18px;
                background: rgba(255,255,255,0.7);
                border-radius: 14px;
                border: 1px solid rgba(0,0,0,0.06);
            }
            .guest-header{
                display:flex;
                align-items:center;
                justify-content: space-between;
                gap: 12px;
                padding: 14px 16px;
                background:#fff;
                border-radius: 12px;
                box-shadow: var(--shadow);
            }
            .guest-header h1{ margin:0; font-size: 18px; }
            .guest-links a{ margin-left: 10px; }

            /* Responsive */
            @media (max-width: 1200px){
                .room-inner{ grid-template-columns: 1fr; }
                .sidebar{ width: 260px; }
            }
        </style>
    </head>

    <body>
        <%
            AuthUser auth = null;
            if (session != null) {
                auth = (AuthUser) session.getAttribute("auth"); // đúng theo LoginServlet
            }
            String ctx = request.getContextPath();
        %>

        <%-- =========================
             GUEST (chưa login)
             ========================= --%>
        <% if (auth == null) { %>
            <div class="guest-wrap">
                <div class="guest-header">
                    <h1>Land House Management System</h1>
                    <div class="guest-links">
                        <a class="btn" href="<%=ctx%>/login">Login</a>
                        <a class="btn gray" href="<%=ctx%>/register">Register</a>
                    </div>
                </div>

                <h2 style="margin-top:18px;">Welcome to our system</h2>
                <p>This is the public home page. Anyone can access.</p>

                <ul>
                    <li>Browse available houses</li>
                    <li>View rooms</li>
                    <li>Contact manager</li>
                </ul>

                <%-- Demo card cho guest xem (sau này bạn loop data) --%>
                <div class="room-list">
                    <div class="room-card">
                        <div class="room-inner">
                            <div class="gallery">
                                <div class="main-img">
                                    <img src="<%=ctx%>/assets/img/room-demo-1.jpg" alt="Room" onerror="this.src='<%=ctx%>/assets/img/no-image.png'">
                                </div>
                                <div class="thumbs">
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-1.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-2.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-3.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                </div>
                            </div>

                            <div class="info-box">
                                <div class="info-title">PHÒNG TRỌ CAO CẤP CÓ NỘI THẤT TẠI CẦN THƠ</div>

                                <div class="info-row">
                                    <div class="badge">Giá:</div>
                                    <div class="value">2 Triệu 400 nghìn</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Diện tích:</div>
                                    <div class="value">16 m²</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Hướng nhà:</div>
                                    <div class="value">Tây Bắc</div>
                                </div>

                                <div style="height:10px;"></div>

                                <div class="info-row">
                                    <div class="badge">Vị trí:</div>
                                    <div class="value">Quận Ninh Kiều</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Lộ giới:</div>
                                    <div class="value">4,5 m</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Ngày đăng:</div>
                                    <div class="value">25/12/2025</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        <% } else { %>

        <%-- =========================
             LOGGED IN (có auth)
             ========================= --%>
        <div class="app">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="brand">
                    <div class="logo">LH</div>
                    <div class="name">
                        <b>LANDHOUSE</b>
                        <small>Management</small>
                    </div>
                </div>

                <div class="menu-title">Menu</div>

                <div class="nav">

                    <%-- Tenant menu như ảnh --%>
                    <% if ("TENANT".equalsIgnoreCase(auth.getRole())) { %>
                        <a href="<%=ctx%>/tenant/room">
                            <span class="icon">🏠</span> Phòng của bạn
                        </a>
                        <a href="<%=ctx%>/tenant/contract">
                            <span class="icon">📄</span> Hợp đồng thuê
                        </a>
                        <a href="<%=ctx%>/tenant/bill">
                            <span class="icon">🧾</span> Hóa đơn
                        </a>
                        <a href="<%=ctx%>/tenant/payment-history">
                            <span class="icon">💰</span> Lịch sử thanh toán
                        </a>
                        <a href="<%=ctx%>/tenant/utility">
                            <span class="icon">💡</span> Dịch vụ
                        </a>
                        <a href="<%=ctx%>/tenant/rules">
                            <span class="icon">📌</span> Quy định nhà trọ
                        </a>
                        <a href="<%=ctx%>/tenant/notification">
                            <span class="icon">🔔</span> Thông báo
                        </a>
                    <% } %>

                    <%-- Admin/Manager: để menu basic + button qua trang quản trị --%>
                    <% if ("ADMIN".equalsIgnoreCase(auth.getRole())) { %>
                        <a href="<%=ctx%>/admin/dashboard">
                            <span class="icon">🛠</span> Trang Admin
                        </a>
                    <% } %>

                    <% if ("MANAGER".equalsIgnoreCase(auth.getRole())) { %>
                        <a href="<%=ctx%>/manager/dashboard">
                            <span class="icon">📊</span> Trang Manager
                        </a>
                    <% } %>

                    <a href="<%=ctx%>/home">
                        <span class="icon">🏡</span> Home
                    </a>
                </div>

                <div class="sidebar-footer">
                    <a class="contact-btn" href="<%=ctx%>/contact">
                        ☎ Liên hệ
                    </a>
                </div>
            </aside>

            <!-- MAIN -->
            <main class="main">

                <!-- TOPBAR -->
                <div class="topbar">
                    <div class="left">
                        <button class="hamburger" type="button" onclick="toggleSidebar()">☰</button>
                        <h1>Land House Management System</h1>
                    </div>

                    <!-- Role buttons nhanh (theo yêu cầu) -->
                    <div class="role-actions">
                        <% if ("ADMIN".equalsIgnoreCase(auth.getRole())) { %>
                            <a class="btn" href="<%=ctx%>/admin/dashboard">Vào trang Admin</a>
                        <% } else if ("MANAGER".equalsIgnoreCase(auth.getRole())) { %>
                            <a class="btn" href="<%=ctx%>/manager/dashboard">Vào trang Manager</a>
                        <% } %>
                    </div>

                    <!-- USER DROPDOWN -->
                    <div class="userbox">
                        <button class="userbtn" type="button" onclick="toggleDropdown()">
                            <span class="info">
                                <span class="avatar"><%= (auth.getFullName() != null && !auth.getFullName().isBlank()) ? auth.getFullName().substring(0,1).toUpperCase() : "U" %></span>
                                <span class="name">
                                    <b><%= auth.getFullName() %></b>
                                    <small><%= auth.getRole() %></small>
                                </span>
                            </span>
                            <span>▾</span>
                        </button>

                        <div class="dropdown" id="userDropdown">
                            <a href="<%=ctx%>/profile">👤 Xem hồ sơ</a>
                            <a href="<%=ctx%>/logout">🚪 Đăng xuất</a>
                        </div>
                    </div>
                </div>

                <!-- CONTENT (demo giống ảnh, sau này bạn loop data từ DB) -->
                <div class="room-list">

                    <div class="room-card">
                        <div class="room-inner">
                            <div class="gallery">
                                <div class="main-img">
                                    <img src="<%=ctx%>/assets/img/room-demo-1.jpg" alt="Room"
                                         onerror="this.src='<%=ctx%>/assets/img/no-image.png'">
                                </div>
                                <div class="thumbs">
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-1.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-2.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-3.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                </div>
                            </div>

                            <div class="info-box">
                                <div class="info-title">PHÒNG TRỌ CAO CẤP CÓ NỘI THẤT TẠI CẦN THƠ</div>

                                <div class="info-row">
                                    <div class="badge">Giá:</div>
                                    <div class="value">2 Triệu 400 nghìn</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Diện tích:</div>
                                    <div class="value">16 m²</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Hướng nhà:</div>
                                    <div class="value">Tây Bắc</div>
                                </div>

                                <div style="height:10px;"></div>

                                <div class="info-row">
                                    <div class="badge">Vị trí:</div>
                                    <div class="value">Quận Ninh Kiều</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Lộ giới:</div>
                                    <div class="value">4,5 m</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Ngày đăng:</div>
                                    <div class="value">25/12/2025</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="room-card">
                        <div class="room-inner">
                            <div class="gallery">
                                <div class="main-img">
                                    <img src="<%=ctx%>/assets/img/room-demo-4.jpg" alt="Room"
                                         onerror="this.src='<%=ctx%>/assets/img/no-image.png'">
                                </div>
                                <div class="thumbs">
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-4.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-5.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                    <div class="thumb"><img src="<%=ctx%>/assets/img/room-demo-6.jpg" alt="" onerror="this.src='<%=ctx%>/assets/img/no-image.png'"></div>
                                </div>
                            </div>

                            <div class="info-box">
                                <div class="info-title">PHÒNG TRỌ CAO CẤP CÓ NỘI THẤT TẠI CẦN THƠ</div>

                                <div class="info-row">
                                    <div class="badge">Giá:</div>
                                    <div class="value">3 Triệu</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Diện tích:</div>
                                    <div class="value">20 m²</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Hướng nhà:</div>
                                    <div class="value">Tây Bắc</div>
                                </div>

                                <div style="height:10px;"></div>

                                <div class="info-row">
                                    <div class="badge">Vị trí:</div>
                                    <div class="value">Quận Ninh Kiều</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Lộ giới:</div>
                                    <div class="value">4,5 m</div>
                                </div>
                                <div class="info-row">
                                    <div class="badge">Ngày đăng:</div>
                                    <div class="value">20/12/2025</div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </main>

        </div>

        <script>
            function toggleDropdown(){
                var dd = document.getElementById("userDropdown");
                if(!dd) return;
                dd.style.display = (dd.style.display === "block") ? "none" : "block";
            }

            // click ngoài dropdown thì đóng
            document.addEventListener("click", function(e){
                var dd = document.getElementById("userDropdown");
                if(!dd) return;

                var userbtn = document.querySelector(".userbtn");
                if(!userbtn) return;

                if(!userbtn.contains(e.target) && !dd.contains(e.target)){
                    dd.style.display = "none";
                }
            });

            function toggleSidebar(){
                var sb = document.querySelector(".sidebar");
                if(!sb) return;
                if(sb.style.display === "none"){
                    sb.style.display = "block";
                }else{
                    sb.style.display = "none";
                }
            }
        </script>

        <% } %>
    </body>
</html>
