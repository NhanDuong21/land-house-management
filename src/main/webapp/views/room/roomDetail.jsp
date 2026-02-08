<%-- 
    Document   : detail room 
    Created on : 02/06/2026, 6:22:57 AM
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout-fragment cssFile="${pageContext.request.contextPath}/assets/css/roomDetail.css">
    <c:set var="r" value="${room}" />
    <c:set var="ctx" value="${pageContext.request.contextPath}" />


    <div class="rd-head">
        <h2 class="rd-title">Room Details - ${r.roomNumber}</h2>
        <div class="rd-sub">Complete information about this room including features, amenities, and pricing</div>
    </div>

    <div class="rd-image">
        <c:choose>
            <c:when test="${not empty r.images}">
                <img id="mainImg" class="rd-main"
                     src="${ctx}/assets/images/rooms/${r.images[0].imageUrl}" alt="Room">

                <div class="rd-thumbs">
                    <c:forEach var="img" items="${r.images}">
                        <img class="rd-thumb"
                             src="${ctx}/assets/images/rooms/${img.imageUrl}"
                             alt=""
                             onclick="document.getElementById('mainImg').src = this.src">
                    </c:forEach>
                </div>
            </c:when>

            <c:otherwise>
                <c:choose>
                    <c:when test="${not empty r.roomImage}">
                        <img class="rd-main" src="${ctx}/assets/images/rooms/${r.roomImage}" alt="Room">
                    </c:when>
                    <c:otherwise>
                        <div class="rd-image-placeholder">No Image</div>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>

        <div class="rd-badge">${r.status}</div>
    </div>

    <div class="rd-grid">
        <div class="rd-card">
            <div class="rd-card-title">Basic Information</div>
            <div class="rd-row"><span>Room:</span><b>${r.roomNumber}</b></div>
            <div class="rd-row"><span>Block:</span><b>${r.blockName}</b></div>
            <div class="rd-row"><span>Area:</span><b>${r.area} m²</b></div>
            <div class="rd-row"><span>Floor:</span><b><c:out value="${r.floor}"/></b></div>
            <div class="rd-row"><span>Maximum occupancy:</span><b><c:out value="${r.maxTenants}"/></b></div>
        </div>

        <div class="rd-card">
            <div class="rd-card-title">Room Features</div>
            <div class="rd-row">
                <span>Air-Conditioner:</span>
                <b><c:if test="${r.airConditioning}">Yes</c:if><c:if test="${!r.airConditioning}">No</c:if></b>
                </div>
                <div class="rd-row">
                    <span>Mezzanine:</span>
                        <b><c:if test="${r.mezzanine}">Yes</c:if><c:if test="${!r.mezzanine}">No</c:if></b>
                </div>
            </div>
        </div>

        <div class="rd-price">
            <div class="rd-price-value">
            <fmt:formatNumber value="${r.price}" type="number" groupingUsed="true"/> đ/month
        </div>

    </div>

    <c:if test="${not empty r.description}">
        <div class="rd-price-sub">Description:</div>
        <div class="rd-desc">${r.description}</div>
    </c:if>
</t:layout-fragment>
