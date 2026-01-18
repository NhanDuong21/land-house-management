<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>

<t:layout title="Profile" active="profile">

    <%-- Hiển thị thông báo Success --%>
    <c:if test="${not empty msg}">
        <div class="alert success">${msg}</div>
    </c:if>

    <%-- Hiển thị thông báo Error --%>
    <c:if test="${not empty error}">
        <div class="alert error">${error}</div>
    </c:if>
    <%-- Lấy context path nếu chưa có --%>
    <c:set var="ctx" value="${pageContext.request.contextPath}" />
    <section class="card">
        <div class="card-title">Thông tin tài khoản</div>

        <div class="form-grid">
            <div class="field">
                <label>Username</label>
                <input type="text" value="${not empty p_username ? p_username : ''}" readonly>
            </div>

            <div class="field">
                <label>Email</label>
                <input type="text" value="${not empty p_email ? p_email : ''}" readonly>
            </div>

            <div class="field">
                <label>Full name</label>
                <%-- Lấy trực tiếp từ session auth --%>
                <input type="text" value="${not empty sessionScope.auth.fullName ? sessionScope.auth.fullName : 'User'}" readonly>
            </div>

            <div class="field">
                <label>Số điện thoại</label>
                <input type="text" value="${not empty p_phone ? p_phone : ''}" readonly>
            </div>

            <div class="field full">
                <label>Số Căn Cước Công Dân</label>
                <%-- Logic Masking (Ẩn số CCCD) bằng EL --%>
                <c:set var="idLen" value="${fn:length(p_identity)}" />
                <c:choose>
                    <c:when test="${idLen >= 4}">
                        <input type="text" value="********${fn:substring(p_identity, idLen - 4, idLen)}" readonly>
                    </c:when>
                    <c:otherwise>
                        <input type="text" value="${p_identity}" readonly>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="actions">
                <a class="btn" href="${pageContext.request.contextPath}/profile/edit">Chỉnh sửa</a>
            </div>
        </div>
    </section>

    <section class="card">
        <div class="card-title">Thay đổi mật khẩu</div>

        <form method="post" action="${pageContext.request.contextPath}/profile" class="pw-form">
            <div class="field full">
                <label>Mật khẩu cũ</label>
                <div style="position: relative; display: flex; align-items: center;">
                    <input type="password" name="oldPassword" id="oldPassword" placeholder="Nhập mật khẩu cũ" required style="width: 100%; padding-right: 40px;">
                    <img src="${ctx}/assets/images/eye-close.png" id="icon-oldPassword" onclick="togglePass('oldPassword')" style="position: absolute; right: 10px; width: 20px; cursor: pointer; opacity: 0.6;">
                </div>
            </div>

            <div class="pw-row">
                <div class="field">
                    <label>Nhập mật khẩu mới</label>
                    <div style="position: relative; display: flex; align-items: center;">
                        <input type="password" name="newPassword" id="newPassword" placeholder="Nhập mật khẩu mới" required style="width: 100%; padding-right: 40px;">
                        <img src="${ctx}/assets/images/eye-close.png" id="icon-newPassword" onclick="togglePass('newPassword')" style="position: absolute; right: 10px; width: 20px; cursor: pointer; opacity: 0.6;">
                    </div>
                </div>

                <div class="field">
                    <label>Nhập lại mật khẩu mới</label>
                    <div style="position: relative; display: flex; align-items: center;">
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Nhập lại mật khẩu mới" required style="width: 100%; padding-right: 40px;">
                        <img src="${ctx}/assets/images/eye-close.png" id="icon-confirmPassword" onclick="togglePass('confirmPassword')" style="position: absolute; right: 10px; width: 20px; cursor: pointer; opacity: 0.6;">
                    </div>
                </div>
            </div>

            <div class="pw-actions">
                <button type="submit" class="btn">Xác nhận thay đổi</button>
            </div>
        </form>
    </section>
    <script src="${ctx}/assets/js/hidePassword.js"></script>
</t:layout>