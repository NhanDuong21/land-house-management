<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<t:layout title="My Room"
          active="t_room"
          cssFile="${ctx}/assets/css/views/tenantMyRoom.css">

    <div class="mr-container">

        <c:choose>
            <c:when test="${empty myRoom}">
                <div class="mr-empty">
                    <div class="mr-empty-ico"><i class="bi bi-door-closed"></i></div>
                    <h3>Bạn chưa có phòng đang thuê</h3>
                    <p>Vui lòng xem hợp đồng để kiểm tra thông tin thuê phòng.</p>

                    <div class="mr-empty-actions">
                        <a class="mr-btn primary" href="${ctx}/tenant/contract">
                            <i class="bi bi-file-earmark-text"></i>
                            Xem hợp đồng
                        </a>
                        <a class="mr-btn outline" href="${ctx}/home">
                            <i class="bi bi-house-door"></i>
                            Về trang chủ
                        </a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>

                <!-- Header -->
                <div class="mr-header">
                    <div>
                        <div class="mr-title">
                            <h2>My Room</h2>
                            <span class="mr-room-no">#${myRoom.roomNumber}</span>

                            <!-- STATUS BADGE -->
                            <c:if test="${not empty myRoom.roomStatus}">
                                <span class="mr-status mr-status-${myRoom.roomStatus}">
                                    <i class="bi bi-dot"></i> ${myRoom.roomStatus}
                                </span>
                            </c:if>
                        </div>

                        <div class="mr-sub">
                            <span><i class="bi bi-building"></i> Khu: <b>${myRoom.blockName}</b></span>
                            <span class="mr-dot">•</span>
                            <span><i class="bi bi-layers"></i> Tầng: <b>${myRoom.floor}</b></span>
                        </div>
                    </div>

                    <div class="mr-actions">
                        <a class="mr-btn outline" href="${ctx}/tenant/contract">
                            <i class="bi bi-file-earmark-text"></i>
                            My Contract
                        </a>
                        <a class="mr-btn primary" href="${ctx}/maintenance">
                            <i class="bi bi-tools"></i>
                            Maintenance
                        </a>
                    </div>
                </div>

                <div class="mr-grid">

                    <!-- Cover (clickable) -->
                    <div class="mr-card mr-cover">
                        <button class="mr-cover-btn"
                                type="button"
                                data-cover="1"
                                <c:if test="${not empty myRoom.coverImage}">
                                    data-src="${ctx}/assets/images/rooms/${myRoom.coverImage}"
                                </c:if>
                                aria-label="Open cover image">
                            <div class="mr-cover-wrap">
                                <c:choose>
                                    <c:when test="${not empty myRoom.coverImage}">
                                        <img class="mr-cover-img"
                                             src="${ctx}/assets/images/rooms/${myRoom.coverImage}"
                                             alt="Room cover" />
                                        <div class="mr-cover-hint">
                                            <i class="bi bi-arrows-fullscreen"></i> Xem ảnh
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mr-cover-placeholder">
                                            <i class="bi bi-image"></i>
                                            <div>No cover image</div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </button>
                    </div>

                    <!-- Info -->
                    <div class="mr-card mr-info">
                        <div class="mr-info-head">
                            <div class="mr-info-title">Thông tin phòng</div>
                            <div class="mr-badges">
                                <span class="mr-badge ${myRoom.airConditioning ? 'ok' : 'off'}">
                                    <i class="bi ${myRoom.airConditioning ? 'bi-snow' : 'bi-slash-circle'}"></i>
                                    AC: ${myRoom.airConditioning ? 'Có' : 'Không'}
                                </span>

                                <span class="mr-badge ${myRoom.mezzanine ? 'ok' : 'off'}">
                                    <i class="bi ${myRoom.mezzanine ? 'bi-layers-fill' : 'bi-layers'}"></i>
                                    Gác: ${myRoom.mezzanine ? 'Có' : 'Không'}
                                </span>
                            </div>
                        </div>

                        <div class="mr-kpis">
                            <div class="mr-kpi">
                                <div class="mr-kpi-ico"><i class="bi bi-cash-stack"></i></div>
                                <div>
                                    <div class="mr-kpi-label">Giá</div>
                                    <div class="mr-kpi-value">${myRoom.price} <span class="mr-unit">/ tháng</span></div>
                                </div>
                            </div>

                            <div class="mr-kpi">
                                <div class="mr-kpi-ico"><i class="bi bi-aspect-ratio"></i></div>
                                <div>
                                    <div class="mr-kpi-label">Diện tích</div>
                                    <div class="mr-kpi-value">${myRoom.area} <span class="mr-unit">m²</span></div>
                                </div>
                            </div>

                            <div class="mr-kpi">
                                <div class="mr-kpi-ico"><i class="bi bi-people"></i></div>
                                <div>
                                    <div class="mr-kpi-label">Tối đa</div>
                                    <div class="mr-kpi-value">${myRoom.maxTenants} <span class="mr-unit">người</span></div>
                                </div>
                            </div>
                        </div>

                        <div class="mr-desc">
                            <div class="mr-desc-title">Mô tả</div>
                            <div class="mr-desc-text">
                                <c:out value="${empty myRoom.description ? 'Chưa có mô tả.' : myRoom.description}" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Gallery -->
                <div class="mr-card mr-gallery">
                    <div class="mr-gallery-head">
                        <div class="mr-gallery-title">
                            <i class="bi bi-images"></i> Ảnh phòng
                        </div>
                        <div class="mr-gallery-sub">
                            Click vào ảnh để xem lớn
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty myRoom.images && empty myRoom.coverImage}">
                            <div class="mr-gallery-empty">
                                <i class="bi bi-image-alt"></i>
                                Chưa có ảnh phòng
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mr-gallery-grid">

                                <!-- Put cover as first thumb (optional) -->
                                <c:if test="${not empty myRoom.coverImage}">
                                    <button class="mr-thumb mr-thumb-cover"
                                            type="button"
                                            data-src="${ctx}/assets/images/rooms/${myRoom.coverImage}">
                                        <img src="${ctx}/assets/images/rooms/${myRoom.coverImage}" alt="Cover" />
                                        <span class="mr-thumb-tag"><i class="bi bi-star-fill"></i> Cover</span>
                                    </button>
                                </c:if>

                                <c:forEach items="${myRoom.images}" var="img">
                                    <button class="mr-thumb"
                                            type="button"
                                            data-src="${ctx}/assets/images/rooms/${img.imageUrl}">
                                        <img src="${ctx}/assets/images/rooms/${img.imageUrl}" alt="Room image" />
                                    </button>
                                </c:forEach>

                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Lightbox modal -->
                <div class="mr-lightbox" id="mrLightbox" aria-hidden="true">
                    <div class="mr-lightbox-backdrop" data-close="1"></div>

                    <div class="mr-lightbox-box" role="dialog" aria-modal="true">
                        <button class="mr-lb-close" type="button" title="Close" data-close="1">
                            <i class="bi bi-x-lg"></i>
                        </button>

                        <button class="mr-lb-nav prev" type="button" title="Previous">
                            <i class="bi bi-chevron-left"></i>
                        </button>

                        <div class="mr-lb-skeleton" id="mrLbSkel">
                            <div class="mr-skel-hint">
                                <i class="bi bi-hourglass-split"></i> Loading...
                            </div>
                        </div>

                        <img class="mr-lb-img" id="mrLbImg" alt="Preview"/>

                        <button class="mr-lb-nav next" type="button" title="Next">
                            <i class="bi bi-chevron-right"></i>
                        </button>

                        <div class="mr-lb-meta">
                            <span id="mrLbCount">1/1</span>
                        </div>
                    </div>
                </div>

                <script src="${ctx}/assets/js/pages/tenantMyRoom.js"></script>
            </c:otherwise>
        </c:choose>

    </div>

</t:layout>