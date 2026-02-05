<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="Home - RentHouse" active="home" cssFile="${pageContext.request.contextPath}/assets/css/home.css">

    <c:set var="ctx" value="${pageContext.request.contextPath}" />

    <!-- defaults -->
    <c:set var="PRICE_MIN" value="0" />
    <c:set var="PRICE_MAX" value="10000000" />
    <c:set var="AREA_MIN" value="0" />
    <c:set var="AREA_MAX" value="50" />

    <c:set var="minPrice" value="${empty minPrice ? PRICE_MIN : minPrice}" />
    <c:set var="maxPrice" value="${empty maxPrice ? PRICE_MAX : maxPrice}" />
    <c:set var="minArea"  value="${empty minArea  ? AREA_MIN  : minArea}" />
    <c:set var="maxArea"  value="${empty maxArea  ? AREA_MAX  : maxArea}" />

    <div class="home-head">
        <div>
            <h1 class="home-title">Available Rooms</h1>
            <div class="home-sub">Browse our collection of available rooms and find your perfect home</div>
        </div>

        <div class="home-actions">
            <div class="home-count">
                <c:choose>
                    <c:when test="${empty rooms}">0 rooms</c:when>
                    <c:otherwise>${rooms.size()} rooms</c:otherwise>
                </c:choose>
            </div>

            <button class="home-filter-btn" type="button" id="btnOpenFilter">
                🔎 Filter
            </button>
        </div>
    </div>

    <!-- ROOMS GRID -->
    <c:choose>
        <c:when test="${empty rooms}">
            <div class="home-empty">
                Không tìm thấy phòng phù hợp.
            </div>
        </c:when>
        <c:otherwise>
            <div class="room-grid">
                <c:forEach var="r" items="${rooms}">
                    <div class="room-card">
                        <div class="room-img">
                            <c:choose>
                                <c:when test="${not empty r.roomImage}">
                                    <img src="${ctx}/assets/images/rooms/${r.roomImage}" alt="Room">
                                </c:when>
                                <c:otherwise>
                                    <div class="room-img-placeholder">No Image</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="room-badge">AVAILABLE</div>
                        </div>

                        <div class="room-body">
                            <div class="room-name">${r.roomNumber}</div>
                            <div class="room-meta">
                                <span>Area: ${r.area} m²</span>
                                <c:if test="${not empty r.floor}">
                                    <span>• Floor: ${r.floor}</span>
                                </c:if>
                                <span>• Max ${r.maxTenants}</span>
                            </div>

                            <div class="room-tags">
                                <c:if test="${r.airConditioning}">
                                    <span class="tag">AC</span>
                                </c:if>
                                <c:if test="${r.mezzanine}">
                                    <span class="tag">Mezzanine</span>
                                </c:if>
                            </div>

                            <div class="room-price">
                                <fmt:formatNumber value="${r.price}" type="number" groupingUsed="true"/> đ / month
                            </div>

                            <c:if test="${not empty r.description}">
                                <div class="room-desc">${r.description}</div>
                            </c:if>

                            <a class="room-btn" href="${ctx}/room?id=${r.roomId}">Xem chi tiết</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <!-- FILTER MODAL (UI tượng trưng, submit GET đúng HomeController) -->
    <div class="rh-modal" id="filterModal" aria-hidden="true">
        <div class="rh-modal-backdrop" id="filterBackdrop"></div>

        <div class="rh-modal-dialog" role="dialog" aria-modal="true">
            <div class="rh-modal-header">
                <div>
                    <div class="rh-modal-title">Filter Rooms</div>
                    <div class="rh-modal-sub">Set your preferences to find the perfect room</div>
                </div>
                <button class="rh-modal-close" type="button" id="btnCloseFilter">✕</button>
            </div>

            <form method="get" action="${ctx}/home" class="rh-modal-body">

                <!-- Price -->
                <div class="filter-block">
                    <div class="filter-row">
                        <div class="filter-label">Price Range</div>
                        <div class="filter-value">
                            <span id="priceMinText"></span> - <span id="priceMaxText"></span>
                        </div>
                    </div>

                    <div class="dual-range">
                        <input type="range" id="priceMin" min="${PRICE_MIN}" max="${PRICE_MAX}" step="50000" value="${minPrice}">
                        <input type="range" id="priceMax" min="${PRICE_MIN}" max="${PRICE_MAX}" step="50000" value="${maxPrice}">
                    </div>

                    <input type="hidden" name="minPrice" id="minPriceHidden" value="${minPrice}">
                    <input type="hidden" name="maxPrice" id="maxPriceHidden" value="${maxPrice}">
                </div>

                <!-- Area -->
                <div class="filter-block">
                    <div class="filter-row">
                        <div class="filter-label">Area (m²)</div>
                        <div class="filter-value">
                            <span id="areaMinText"></span> - <span id="areaMaxText"></span>
                        </div>
                    </div>

                    <div class="dual-range">
                        <input type="range" id="areaMin" min="${AREA_MIN}" max="${AREA_MAX}" step="1" value="${minArea}">
                        <input type="range" id="areaMax" min="${AREA_MIN}" max="${AREA_MAX}" step="1" value="${maxArea}">
                    </div>

                    <input type="hidden" name="minArea" id="minAreaHidden" value="${minArea}">
                    <input type="hidden" name="maxArea" id="maxAreaHidden" value="${maxArea}">
                </div>

                <!-- AC -->
                <div class="filter-block">
                    <div class="filter-label">Has Air Conditioning</div>
                    <div class="choice-group" data-target="hasAC">
                        <button type="button" class="choice" data-value="any">Any</button>
                        <button type="button" class="choice" data-value="yes">Yes</button>
                        <button type="button" class="choice" data-value="no">No</button>
                    </div>
                    <input type="hidden" name="hasAC" id="hasACHidden" value="${empty hasAC ? 'any' : hasAC}">
                </div>

                <!-- Mezz -->
                <div class="filter-block">
                    <div class="filter-label">Has Mezzanine</div>
                    <div class="choice-group" data-target="hasMezzanine">
                        <button type="button" class="choice" data-value="any">Any</button>
                        <button type="button" class="choice" data-value="yes">Yes</button>
                        <button type="button" class="choice" data-value="no">No</button>
                    </div>
                    <input type="hidden" name="hasMezzanine" id="hasMezzHidden" value="${empty hasMezzanine ? 'any' : hasMezzanine}">
                </div>

                <div class="rh-modal-footer">
                    <a class="btn-reset" href="${ctx}/home">Reset</a>
                    <button class="btn-apply" type="submit">Apply Filters</button>
                </div>
            </form>
        </div>
    </div>

    <!-- init for js -->
    <script>
        window.RH_INIT = {
            ctx: "${ctx}",
            hasAC: "${empty hasAC ? 'any' : hasAC}",
            hasMezzanine: "${empty hasMezzanine ? 'any' : hasMezzanine}"
        };
    </script>
    <script src="${ctx}/assets/js/home.js"></script>
</t:layout>
