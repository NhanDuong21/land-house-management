<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>

<%-- Sử dụng profile.css làm base để không mất sidebar/topbar --%>
<t:layout title="Trang Chủ" active="home" cssFile="${pageContext.request.contextPath}/assets/css/home.css">

    <div class="home-wrapper">
        <c:forEach items="${roomList}" var="r">
            <%-- Dùng lại class .card của bạn để có cái khung trắng đẹp --%>
            <div class="card room-card-horizontal">

                <div class="room-gallery">
                    <%-- Ảnh chính lấy từ Database --%>
                    <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" 
                         class="img-main" 
                         alt="Phòng ${r.roomNumber}">

                    <div class="img-thumbs">
                        <%-- Tạm thời cho 3 ảnh nhỏ là ảnh chính để lấp đầy giao diện cho đẹp --%>
                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" alt="thumb">
                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" alt="thumb">
                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" alt="thumb">
                    </div>
                </div>

                <div class="room-details">
                    <div class="room-title-label">PHÒNG TRỌ CAO CẤP SỐ ${r.roomNumber} - LANDHOUSE</div>

                    <div class="blue-stripe">
                        <span class="s-label">Giá:</span>
                        <span class="s-value"><fmt:formatNumber value="${r.price}" type="currency" currencySymbol="" maxFractionDigits="0"/> VNĐ</span>
                    </div>

                    <div class="blue-stripe">
                        <span class="s-label">Diện tích:</span>
                        <span class="s-value">${r.area} m²</span>
                    </div>

                    <div class="blue-stripe">
                        <span class="s-label">Tầng:</span>
                        <span class="s-value">${r.floor}</span>
                    </div>

                    <div class="stripe-space"></div>

                    <div class="blue-stripe dark">
                        <span class="s-label">Số người tối đa:</span>
                        <span class="s-value">${r.maxTenants} người</span>
                    </div>

                    <div class="blue-stripe dark">
                        <span class="s-label">Gác lửng:</span>
                        <span class="s-value">${r.mezzanine ? 'Có gác' : 'Không gác'}</span>
                    </div>

                    <div class="blue-stripe dark">
                        <span class="s-label">Mô tả:</span>
                        <span class="s-value">${r.description}</span>
                    </div>
                </div>

            </div>
        </c:forEach>

        <div class="pagination-mock">
            <span> < 1 2 > </span>
        </div>
    </div>

</t:layout>