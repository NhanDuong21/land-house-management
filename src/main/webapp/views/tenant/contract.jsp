<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="My Contract" active="tenant_contract">

    <div class="container mt-4" style="max-width: 1100px;">
        <h3 style="font-weight: 800;">My Contract</h3>
        <div style="color:#64748b;font-weight:650;margin-top:6px;">
            View your rental contracts (PENDING / ACTIVE)
        </div>

        <div class="mt-4">
            <c:if test="${empty contracts}">
                <div class="alert alert-secondary">
                    You don't have any contract yet.
                </div>
            </c:if>

            <c:forEach var="c" items="${contracts}">
                <div class="card mb-3" style="border-radius:16px;">
                    <div class="card-body" style="padding:18px;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div style="font-weight:800;font-size:18px;">
                                Contract #<fmt:formatNumber value="${c.contractId}" pattern="000000"/>
                            </div>

                            <c:choose>
                                <c:when test="${c.status eq 'ACTIVE'}">
                                    <span class="badge bg-success" style="border-radius:999px;padding:8px 12px;">
                                        ACTIVE
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark" style="border-radius:999px;padding:8px 12px;">
                                        ${c.status}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <hr/>

                        <div class="row">
                            <div class="col-md-6">
                                <div><b>Room ID:</b> ${c.roomId}</div>
                                <div class="mt-2"><b>Start Date:</b> ${c.startDate}</div>
                                <div class="mt-2"><b>End Date:</b>
                                    <c:choose>
                                        <c:when test="${empty c.endDate}">-</c:when>
                                        <c:otherwise>${c.endDate}</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div><b>Monthly Rent:</b>
                                    <fmt:formatNumber value="${c.monthlyRent}" type="number" groupingUsed="true"/> đ
                                </div>
                                <div class="mt-2"><b>Deposit:</b>
                                    <fmt:formatNumber value="${c.deposit}" type="number" groupingUsed="true"/> đ
                                </div>
                            </div>
                        </div>

                        <c:if test="${c.status eq 'PENDING'}">
                            <div class="mt-3">
                                <a class="btn btn-dark"
                                   href="${pageContext.request.contextPath}/tenant/contract/detail?id=${c.contractId}">
                                    View Pending Contract
                                </a>
                            </div>
                        </c:if>

                        <c:if test="${c.status ne 'PENDING'}">
                            <div class="mt-3">
                                <a class="btn btn-outline-dark"
                                   href="${pageContext.request.contextPath}/tenant/contract/detail?id=${c.contractId}">
                                    View
                                </a>
                            </div>
                        </c:if>

                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

</layout:layout>
