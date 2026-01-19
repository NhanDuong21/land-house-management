<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions"%>

<t:layout title="Home - LandHouse" active="home" cssFile="${pageContext.request.contextPath}/assets/css/home.css">

    <div class="home-wrapper">
        <c:forEach items="${roomList}" var="r">
            <div class="card room-card-horizontal">

                <div class="room-gallery">
                    <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" 
                         class="img-main" 
                         alt="Room ${r.roomNumber}">

                    <div class="img-thumbs">
                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" alt="thumbnail">
                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" alt="thumbnail">
                        <img src="${pageContext.request.contextPath}/assets/images/rooms/${not empty r.roomImage ? r.roomImage : 'logo.png'}" alt="thumbnail">
                    </div>
                </div>

                <div class="room-details">
                    <div class="room-title-label">PREMIUM ROOM #${r.roomNumber} - LANDHOUSE</div>

                    <div class="blue-stripe">
                        <span class="s-label">Monthly Rent:</span>
                        <span class="s-value">
                            <fmt:formatNumber value="${r.price}" type="currency" currencySymbol="" maxFractionDigits="0"/> VND
                        </span>
                    </div>

                    <div class="blue-stripe">
                        <span class="s-label">Acreage:</span>
                        <span class="s-value">${r.area} m²</span>
                    </div>

                    <div class="blue-stripe">
                        <span class="s-label">Floor Level:</span>
                        <span class="s-value">${r.floor}</span>
                    </div>

                    <div class="stripe-space"></div>

                    <div class="blue-stripe dark">
                        <span class="s-label">Max Capacity:</span>
                        <span class="s-value">${r.maxTenants} persons</span>
                    </div>

                    <div class="blue-stripe dark">
                        <span class="s-label">Mezzanine:</span>
                        <span class="s-value">${r.mezzanine ? 'Available' : 'Not Available'}</span>
                    </div>

                    <div class="blue-stripe dark">
                        <span class="s-label">Description:</span>
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