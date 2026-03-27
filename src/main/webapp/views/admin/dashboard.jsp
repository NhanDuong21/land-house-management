<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<t:layout>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/views/admin/dashboard.css"/>

    <div class="dashboard-wrapper">

        <!-- FX Background -->
        <div class="dashboard-bg">
            <span class="bg-orb orb-1"></span>
            <span class="bg-orb orb-2"></span>
            <span class="bg-orb orb-3"></span>
            <span class="bg-grid"></span>
            <span class="bg-noise"></span>
        </div>

        <!-- Header -->
        <div class="dashboard-title reveal-up" data-delay="0">
            <div class="dashboard-badge">ADMIN ANALYTICS</div>
            <h2>Admin Dashboard</h2>
            <p>Overview of your rental management system</p>
        </div>

        <!-- Cards -->
        <div class="dashboard-grid">

            <!-- Total Tenants -->
            <div class="dashboard-card card-tenants reveal-up" data-delay="80">
                <div class="card-blur"></div>
                <div class="card-shine"></div>
                <div class="card-top-line"></div>

                <div class="card-header">
                    <div>
                        <span class="card-label">Total Tenants</span>
                        <small>Active tenant accounts</small>
                    </div>
                    <div class="card-icon">
                        <i class="bi bi-people"></i>
                    </div>
                </div>

                <div class="card-value">
                    <h3 class="counter"
                        data-value="${totalTenants}"
                        data-suffix=""
                        data-duration="1500">${totalTenants}</h3>
                </div>

                <div class="card-chart">
                    <svg class="sparkline spark-blue" viewBox="0 0 100 36" preserveAspectRatio="none">
                        <polyline points="0,26 10,20 20,22 30,14 40,16 50,9 60,13 70,8 80,12 90,6 100,10"></polyline>
                    </svg>
                </div>
            </div>

            <!-- Available Rooms -->
            <div class="dashboard-card card-rooms reveal-up" data-delay="160">
                <div class="card-blur"></div>
                <div class="card-shine"></div>
                <div class="card-top-line"></div>

                <div class="card-header">
                    <div>
                        <span class="card-label">Available Rooms</span>
                        <small>Ready for rent</small>
                    </div>
                    <div class="card-icon">
                        <i class="bi bi-house"></i>
                    </div>
                </div>

                <div class="card-value">
                    <h3 class="counter"
                        data-value="${availableRooms}"
                        data-suffix=""
                        data-duration="1550">${availableRooms}</h3>
                </div>

                <div class="card-chart">
                    <svg class="sparkline spark-green" viewBox="0 0 100 36" preserveAspectRatio="none">
                        <polyline points="0,24 10,25 20,21 30,19 40,20 50,16 60,14 70,12 80,13 90,10 100,8"></polyline>
                    </svg>
                </div>
            </div>

            <!-- Maintenance -->
            <div class="dashboard-card card-maintenance alert-card reveal-up" data-delay="240">
                <div class="card-blur"></div>
                <div class="card-shine"></div>
                <div class="card-top-line"></div>

                <div class="card-header">
                    <div>
                        <span class="card-label">Maintenance Requests</span>
                        <small>Pending requests</small>
                    </div>
                    <div class="card-icon">
                        <i class="bi bi-tools"></i>
                    </div>
                </div>

                <div class="card-value">
                    <h3 class="counter"
                        data-value="${maintenanceRequests}"
                        data-suffix=""
                        data-duration="1650">${maintenanceRequests}</h3>
                </div>

                <div class="card-chart">
                    <svg class="sparkline spark-amber" viewBox="0 0 100 36" preserveAspectRatio="none">
                        <polyline points="0,14 10,16 20,12 30,13 40,9 50,11 60,8 70,12 80,7 90,9 100,6"></polyline>
                    </svg>
                </div>
            </div>

            <!-- Occupied -->
            <div class="dashboard-card card-occupied reveal-up" data-delay="320">
                <div class="card-blur"></div>
                <div class="card-shine"></div>
                <div class="card-top-line"></div>

                <div class="card-header">
                    <div>
                        <span class="card-label">Occupied Rooms</span>
                        <small>Currently rented</small>
                    </div>
                    <div class="card-icon">
                        <i class="bi bi-building"></i>
                    </div>
                </div>

                <div class="card-value">
                    <h3 class="counter"
                        data-value="${occupiedRooms}"
                        data-suffix=""
                        data-duration="1700">${occupiedRooms}</h3>
                </div>

                <div class="card-chart">
                    <svg class="sparkline spark-purple" viewBox="0 0 100 36" preserveAspectRatio="none">
                        <polyline points="0,28 10,26 20,24 30,21 40,18 50,15 60,12 70,10 80,9 90,7 100,5"></polyline>
                    </svg>
                </div>
            </div>

            <!-- Monthly Revenue -->
            <div class="dashboard-card card-monthly revenue-card reveal-up" data-delay="400">
                <div class="card-blur"></div>
                <div class="card-shine"></div>
                <div class="card-top-line"></div>

                <div class="card-header">
                    <div>
                        <span class="card-label">Monthly Revenue</span>
                        <small>This month's income</small>
                    </div>
                    <div class="card-icon">
                        <i class="bi bi-currency-dollar"></i>
                    </div>
                </div>

                <div class="card-value">
                    <h3 class="counter currency"
                        data-value="${monthlyRevenue}"
                        data-suffix=" đ"
                        data-duration="1900">
                        <fmt:formatNumber value="${monthlyRevenue}" type="number"/> đ
                    </h3>
                </div>

                <div class="card-chart">
                    <svg class="sparkline spark-pink" viewBox="0 0 100 36" preserveAspectRatio="none">
                        <polyline points="0,30 10,28 20,24 30,22 40,19 50,16 60,15 70,12 80,10 90,7 100,4"></polyline>
                    </svg>
                </div>
            </div>

            <!-- Total Revenue -->
            <div class="dashboard-card card-total revenue-card reveal-up" data-delay="480">
                <div class="card-blur"></div>
                <div class="card-shine"></div>
                <div class="card-top-line"></div>

                <div class="card-header">
                    <div>
                        <span class="card-label">Total Revenue</span>
                        <small>All-time revenue</small>
                    </div>
                    <div class="card-icon">
                        <i class="bi bi-graph-up"></i>
                    </div>
                </div>

                <div class="card-value">
                    <h3 class="counter currency"
                        data-value="${totalRevenue}"
                        data-suffix=" đ"
                        data-duration="2100">
                        <fmt:formatNumber value="${totalRevenue}" type="number"/> đ
                    </h3>
                </div>

                <div class="card-chart">
                    <svg class="sparkline spark-dark" viewBox="0 0 100 36" preserveAspectRatio="none">
                        <polyline points="0,31 10,29 20,26 30,24 40,20 50,18 60,15 70,12 80,9 90,6 100,3"></polyline>
                    </svg>
                </div>
            </div>

        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/pages/admin/dashboard.js"></script>

</t:layout>