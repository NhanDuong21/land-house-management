<%-- 
    Document   : contract
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="My Contracts"
               active="tenant_contract"
               cssFile="${pageContext.request.contextPath}/assets/css/views/tenantContracts.css">

    <div class="container tc-wrap">

        <h1 class="tc-title">
            <i class="bi bi-file-earmark-text me-2"></i>
            My Contracts
        </h1>
        <div class="tc-sub">
            <i class="bi bi-info-circle me-2"></i>
            View your rental contracts
        </div>

        <div class="tc-board">

            <c:if test="${empty contracts}">
                <div class="tc-empty">
                    <i class="bi bi-inbox me-2"></i>
                    You don't have any contracts yet.
                </div>
            </c:if>

            <c:if test="${not empty contracts}">
                <div class="tc-grid">

                    <c:forEach var="c" items="${contracts}">
                        <div class="tc-card">

                            <!-- Header -->
                            <div class="tc-card-head">
                                <div class="tc-card-left">
                                    <div class="tc-doc">
                                        <i class="bi bi-file-earmark-text"></i>
                                    </div>

                                    <div>
                                        <div class="tc-card-title">
                                            Contract #<fmt:formatNumber value="${c.contractId}" pattern="000000"/>
                                        </div>
                                        <div class="tc-card-meta">
                                            <i class="bi bi-door-open me-1"></i>
                                            <c:out value="${c.roomNumber}"/>
                                            <c:if test="${not empty c.blockName}">
                                                - <c:out value="${c.blockName}"/>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <c:choose>
                                    <c:when test="${c.status eq 'ACTIVE'}">
                                        <span class="tc-badge active">
                                            <i class="bi bi-check-circle me-1"></i> ACTIVE
                                        </span>
                                    </c:when>
                                    <c:when test="${c.status eq 'PENDING'}">
                                        <span class="tc-badge pending">
                                            <i class="bi bi-clock-history me-1"></i> PENDING
                                        </span>
                                    </c:when>
                                    <c:when test="${c.status eq 'CANCELLED'}">
                                        <span class="tc-badge cancelled">
                                            <i class="bi bi-x-circle me-1"></i> CANCELLED
                                        </span>
                                    </c:when>
                                    <c:when test="${c.status eq 'ENDED'}">
                                        <span class="tc-badge ended">
                                            <i class="bi bi-flag me-1"></i> ENDED
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="tc-badge ended">
                                            <i class="bi bi-question-circle me-1"></i>
                                            <c:out value="${c.status}"/>
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="tc-divider"></div>

                            <!-- Rows -->
                            <div class="tc-rows">

                                <div class="tc-row">
                                    <div class="tc-ico">
                                        <i class="bi bi-door-open"></i>
                                    </div>
                                    <div>
                                        <div class="tc-label">Room</div>
                                        <div class="tc-value">
                                            <c:out value="${c.roomNumber}"/>
                                            <c:if test="${not empty c.blockName}">
                                                - <c:out value="${c.blockName}"/>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <div class="tc-row">
                                    <div class="tc-ico">
                                        <i class="bi bi-calendar-event"></i>
                                    </div>
                                    <div>
                                        <div class="tc-label">Duration</div>
                                        <div class="tc-value">
                                            <fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/>
                                            -
                                            <c:choose>
                                                <c:when test="${empty c.endDate}">...</c:when>
                                                <c:otherwise>
                                                    <fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>

                                <div class="tc-row">
                                    <div class="tc-ico">
                                        <i class="bi bi-cash-coin"></i>
                                    </div>
                                    <div>
                                        <div class="tc-label">Monthly Rent</div>
                                        <div class="tc-value">
                                            <fmt:formatNumber value="${c.monthlyRent}" type="number" groupingUsed="true"/> đ
                                        </div>
                                    </div>
                                </div>

                            </div>

                            <div class="tc-actions">
                                <a class="tc-view-btn"
                                   href="${pageContext.request.contextPath}/tenant/contract/detail?id=${c.contractId}">
                                    <i class="bi bi-eye me-2"></i> View
                                </a>
                            </div>

                        </div>
                    </c:forEach>

                </div>
            </c:if>

        </div>
    </div>

</layout:layout>