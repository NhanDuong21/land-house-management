<%-- 
    Document   : contractDetail
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Contract Detail"
               active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/contractDetail.css?v=2">

    <div class="tcd-wrap">

        <a href="${pageContext.request.contextPath}/manager/contracts" class="tcd-back">
            ← Back
        </a>

        <c:set var="c" value="${contract}"/>

        <div class="tcd-card">
            <div class="tcd-card-body">

                <!-- Top -->
                <div class="tcd-top">
                    <div>
                        <div class="tcd-contract-id">
                            Contract #<fmt:formatNumber value="${c.contractId}" pattern="000000"/>
                        </div>
                        <div class="tcd-sub">
                            Complete rental agreement with legal terms and conditions
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${c.status eq 'ACTIVE'}">
                            <span class="tcd-badge tcd-badge-active">ACTIVE</span>
                        </c:when>
                        <c:otherwise>
                            <span class="tcd-badge tcd-badge-pending">${c.status}</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="tcd-divider"></div>

                <!-- Document header -->
                <div class="tcd-doc-title">ROOM RENTAL AGREEMENT</div>
                <div class="tcd-doc-meta">
                    Contract No: <fmt:formatNumber value="${c.contractId}" pattern="000000"/>
                </div>
                <div class="tcd-doc-meta tcd-doc-meta-2">
                    Dated: <fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/>
                </div>

                <div class="tcd-divider tcd-divider-soft"></div>

                <!-- PARTY A / PARTY B -->
                <div class="tcd-grid-2">

                    <!-- PARTY A -->
                    <div>
                        <div class="tcd-section-title">PARTY A (LANDLORD)</div>

                        <div class="tcd-line"><span class="tcd-label">Full Name:</span>
                            <span class="tcd-value"><c:out value="${empty c.landlordFullName ? '-' : c.landlordFullName}"/></span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Date of Birth:</span>
                            <span class="tcd-value">
                                <c:choose>
                                    <c:when test="${empty c.landlordDateOfBirth}">-</c:when>
                                    <c:otherwise><fmt:formatDate value="${c.landlordDateOfBirth}" pattern="dd/MM/yyyy"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Citizen ID:</span>
                            <span class="tcd-value"><c:out value="${empty c.landlordIdentityCode ? '-' : c.landlordIdentityCode}"/></span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Phone:</span>
                            <span class="tcd-value"><c:out value="${empty c.landlordPhoneNumber ? '-' : c.landlordPhoneNumber}"/></span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Email:</span>
                            <span class="tcd-value"><c:out value="${empty c.landlordEmail ? '-' : c.landlordEmail}"/></span>
                        </div>
                    </div>

                    <!-- PARTY B -->
                    <div>
                        <div class="tcd-section-title">PARTY B (TENANT)</div>

                        <div class="tcd-line"><span class="tcd-label">Full Name:</span>
                            <span class="tcd-value"><c:out value="${empty c.tenantName ? '-' : c.tenantName}"/></span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Date of Birth:</span>
                            <span class="tcd-value">
                                <c:choose>
                                    <c:when test="${empty c.tenantDateOfBirth}">-</c:when>
                                    <c:otherwise><fmt:formatDate value="${c.tenantDateOfBirth}" pattern="dd/MM/yyyy"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Citizen ID:</span>
                            <span class="tcd-value"><c:out value="${empty c.tenantIdentityCode ? '-' : c.tenantIdentityCode}"/></span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Phone:</span>
                            <span class="tcd-value"><c:out value="${empty c.tenantPhoneNumber ? '-' : c.tenantPhoneNumber}"/></span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Email:</span>
                            <span class="tcd-value"><c:out value="${empty c.tenantEmail ? '-' : c.tenantEmail}"/></span>
                        </div>

                        <div class="tcd-line"><span class="tcd-label">Address:</span>
                            <span class="tcd-value"><c:out value="${empty c.tenantAddress ? '-' : c.tenantAddress}"/></span>
                        </div>
                    </div>

                </div>

                <div class="tcd-divider tcd-divider-soft"></div>

                <!-- ARTICLE 1 -->
                <div class="tcd-article">
                    <div class="tcd-article-title">ARTICLE 1: RENTAL PROPERTY</div>

                    <div class="tcd-line"><span class="tcd-label">Room Number:</span>
                        <span class="tcd-value"><c:out value="${empty c.roomNumber ? '-' : c.roomNumber}"/></span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">Block:</span>
                        <span class="tcd-value"><c:out value="${empty c.blockName ? '-' : c.blockName}"/></span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">Floor:</span>
                        <span class="tcd-value"><c:out value="${empty c.floor ? '-' : c.floor}"/></span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">Area:</span>
                        <span class="tcd-value">
                            <c:choose>
                                <c:when test="${empty c.area}">-</c:when>
                                <c:otherwise><c:out value="${c.area}"/> m²</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">Maximum Occupants:</span>
                        <span class="tcd-value"><c:out value="${empty c.maxTenants ? '-' : c.maxTenants}"/></span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">Amenities:</span>
                        <span class="tcd-value">
                            <c:choose>
                                <c:when test="${c.hasAirConditioning}">Air Conditioning</c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                            <c:if test="${c.isMezzanine}">, Mezzanine</c:if>
                            </span>
                        </div>
                    </div>

                    <div class="tcd-divider tcd-divider-soft"></div>

                    <!-- ARTICLE 2 -->
                    <div class="tcd-article">
                        <div class="tcd-article-title">ARTICLE 2: RENTAL PERIOD</div>

                        <div class="tcd-line"><span class="tcd-label">Start Date:</span>
                            <span class="tcd-value"><fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/></span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">End Date:</span>
                        <span class="tcd-value">
                            <c:choose>
                                <c:when test="${empty c.endDate}">-</c:when>
                                <c:otherwise><fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="tcd-divider tcd-divider-soft"></div>

                <!-- ARTICLE 3 -->
                <div class="tcd-article">
                    <div class="tcd-article-title">ARTICLE 3: RENTAL FEE AND PAYMENT</div>

                    <div class="tcd-line"><span class="tcd-label">Monthly Rent:</span>
                        <span class="tcd-value">
                            <fmt:formatNumber value="${c.monthlyRent}" type="number" groupingUsed="true"/> ₫
                        </span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">Security Deposit:</span>
                        <span class="tcd-value">
                            <fmt:formatNumber value="${c.deposit}" type="number" groupingUsed="true"/> ₫
                        </span>
                    </div>

                    <div class="tcd-line"><span class="tcd-label">Payment Method:</span>
                        <span class="tcd-value">Bank transfer or cash</span>
                    </div>

                    <div class="tcd-note">
                        Note: Electricity and water charges are calculated separately based on actual usage.
                    </div>
                </div>

                <!-- Manager-only: show latest payment status if exists -->
                <c:if test="${not empty latestPayment}">
                    <div class="tcd-divider"></div>

                    <div class="tcd-alert tcd-alert-success" style="display:flex;align-items:center;gap:10px;">
                        Latest bank transfer:
                        <span class="tcd-pill">${latestPayment.status}</span>
                        <span style="opacity:.8;">
                            (Amount:
                            <fmt:formatNumber value="${latestPayment.amount}" type="number" groupingUsed="true"/> ₫)
                        </span>
                    </div>
                </c:if>

                <!-- Payment QR (manager view) -->
                <c:if test="${c.status eq 'PENDING'}">
                    <div class="tcd-divider"></div>

                    <div class="tcd-pay-wrap">
                        <div>
                            <div class="tcd-pay-title">Payment QR</div>
                            <div class="tcd-pay-sub">Quét QR để tenant chuyển khoản tiền cọc (deposit).</div>

                            <c:choose>
                                <c:when test="${not empty c.paymentQrData}">
                                    <div class="tcd-qr-box">
                                        <img class="tcd-qr-img"
                                             src="${pageContext.request.contextPath}${c.paymentQrData}"
                                             alt="Payment QR">
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="tcd-alert tcd-alert-warning">Contract chưa có QR. Vui lòng kiểm tra dữ liệu.</div>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${not empty latestPayment}">
                                <div class="tcd-pay-latest">
                                    Latest transfer status:
                                    <span class="tcd-pill">${latestPayment.status}</span>
                                </div>
                            </c:if>
                        </div>

                        <div>
                            <div class="tcd-pay-title">Manager note</div>
                            <div class="tcd-pay-sub">
                                Chờ tenant confirm transfer và/hoặc kiểm tra sao kê để duyệt hợp đồng.
                            </div>

                            <!-- Nếu bạn muốn đặt nút Confirm ngay tại detail thì bật phần này và trỏ đúng endpoint -->
                            <!--
                            <form class="tcd-form"
                                  method="post"
                                  action="${pageContext.request.contextPath}/manager/contracts/confirm">

                                <input type="hidden" name="contractId" value="${c.contractId}"/>

                                <button class="tcd-btn" type="submit"
                                        onclick="return confirm('Confirm contract này? Contract->ACTIVE, Room->OCCUPIED, Tenant->ACTIVE');">
                                    ✅ Confirm Contract
                                </button>

                                <div class="tcd-hint">
                                    Lưu ý: chỉ confirm khi đã nhận tiền cọc.
                                </div>
                            </form>
                            -->
                        </div>
                    </div>
                </c:if>

            </div>
        </div>
    </div>

</layout:layout>
