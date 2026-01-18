<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<t:layout title="Home" active="home">
    <c:set var="auth" value="${sessionScope.auth}" />
    <c:set var="role" value="${auth.role}" />
    <c:set var="fullName" value="${empty auth.fullName ? 'Guest' : auth.fullName}" />

    <div class="card" style="margin-top:30px;">
        <div class="card-title">Trang chủ</div>

        <div style="margin-top:28px;">
            <c:if test="${empty auth}">
                <p>👋 Xin chào! Bạn chưa đăng nhập.</p>
                <p>Hãy bấm nút <b>Login</b> để vào hệ thống.</p>
                <a class="btn" href="${pageContext.request.contextPath}/login">Login</a>
            </c:if>

            <c:if test="${not empty auth}">
                <p>✅ Xin chào: <b>${fullName}</b></p>
                <p>Vai trò: <b>${role}</b></p>

                <div style="margin-top:18px;">
                    <h3 style="margin:0 0 12px 0;">🔧 Trang quản lý</h3>

                    <c:choose>
                        <c:when test="${role eq 'TENANT'}">
                            <a class="btn" href="${pageContext.request.contextPath}/tenant/dashboard">Vào trang Tenant</a>
                        </c:when>
                        <c:when test="${role eq 'MANAGER'}">
                            <a class="btn" href="${pageContext.request.contextPath}/manager/dashboard">Vào trang Manager</a>
                        </c:when>
                        <c:when test="${role eq 'ADMIN'}">
                            <a class="btn" href="${pageContext.request.contextPath}/admin/dashboard">Vào trang Admin</a>
                        </c:when>
                        <c:otherwise>
                            <p style="color:red; font-weight:700;">⚠ Không xác định role</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </div>
</t:layout>