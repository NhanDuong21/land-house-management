<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="Manager Dashboard - RentHouse"
          active=""
          cssFile="${pageContext.request.contextPath}/assets/css/views/managerDashboard.css">

    <c:set var="ctx" value="${pageContext.request.contextPath}" />

    <div class="dash-head">
        <div>
            <h1 class="dash-title">Manager Dashboard</h1>
            <div class="dash-sub">Overview of your rental property management</div>
        </div>

        <div class="dash-actions">
            <a class="dash-btn" href="${ctx}/home">Tenant View</a>
        </div>
    </div>

    <!-- TOP CARDS -->
    <div class="dash-cards">
        <div class="dash-card">
            <div class="dash-card-top">
                <div class="dash-card-label">Total Tenants</div>
                <div class="dash-card-icon" aria-hidden="true">👥</div>
            </div>
            <div class="dash-card-value">
                <c:out value="${empty totalTenants ? 0 : totalTenants}" />
            </div>
        </div>

        <div class="dash-card">
            <div class="dash-card-top">
                <div class="dash-card-label">Available Rooms</div>
                <div class="dash-card-icon green" aria-hidden="true">🏠</div>
            </div>
            <div class="dash-card-value">
                <c:out value="${empty availableRooms ? 0 : availableRooms}" />
            </div>
        </div>

        <div class="dash-card">
            <div class="dash-card-top">
                <div class="dash-card-label">Maintenance Requests</div>
                <div class="dash-card-icon orange" aria-hidden="true">🛠️</div>
            </div>
            <div class="dash-card-value">
                <c:out value="${empty maintenanceRequests ? 0 : maintenanceRequests}" />
            </div>
        </div>
    </div>

    <!-- RECENT ACTIVITY -->
    <div class="dash-panel">
        <div class="dash-panel-title">Recent Activity</div>

        <!-- placeholder tĩnh cho khung UI (sau này bạn gắn data) -->
        <div class="activity-item">
            <div class="activity-main">
                <div class="activity-title">New tenant registered</div>
                <div class="activity-sub">Room A101 - John Doe</div>
            </div>
            <div class="activity-time">2 hours ago</div>
        </div>

        <div class="activity-divider"></div>

        <div class="activity-item">
            <div class="activity-main">
                <div class="activity-title">Maintenance request submitted</div>
                <div class="activity-sub">Room B203 - Air conditioning</div>
            </div>
            <div class="activity-time">5 hours ago</div>
        </div>

        <div class="activity-divider"></div>

        <div class="activity-item">
            <div class="activity-main">
                <div class="activity-title">Payment received</div>
                <div class="activity-sub">Room C305 - Monthly rent</div>
            </div>
            <div class="activity-time">1 day ago</div>
        </div>
    </div>

</t:layout>
