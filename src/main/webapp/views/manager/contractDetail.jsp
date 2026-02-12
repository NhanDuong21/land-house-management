<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Contract Detail" active="m_contracts">

    <div class="container mt-4" style="max-width:1100px;">

        <a href="${pageContext.request.contextPath}/manager/contracts"
           class="btn btn-outline-dark mb-3">
            ← Back
        </a>

        <c:set var="c" value="${contract}"/>

        <div class="card" style="border-radius:16px;">
            <div class="card-body" style="padding:18px;">

                <div class="d-flex justify-content-between align-items-center">
                    <div style="font-weight:900;font-size:20px;">
                        Contract #<fmt:formatNumber value="${c.contractId}" pattern="000000"/>
                    </div>

                    <c:choose>
                        <c:when test="${c.status eq 'ACTIVE'}">
                            <span class="badge bg-success" style="border-radius:999px;padding:8px 12px;">ACTIVE</span>
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
                        <div class="mt-2"><b>Tenant ID:</b> ${c.tenantId}</div>
                        <div class="mt-2"><b>Start Date:</b> ${c.startDate}</div>
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

                <c:if test="${not empty latestPayment}">
                    <hr/>
                    <div style="font-weight:900;">Latest Payment</div>
                    <div class="mt-2">
                        <b>Status:</b> ${latestPayment.status}
                        <span class="ms-2 badge bg-light text-dark" style="border:1px solid rgba(0,0,0,0.15);">
                            ${latestPayment.method}
                        </span>
                    </div>
                </c:if>

                <c:if test="${c.status eq 'PENDING'}">
                    <hr/>
                    <form method="post"
                          action="${pageContext.request.contextPath}/manager/contracts/confirm">
                        <input type="hidden" name="contractId" value="${c.contractId}"/>

                        <button class="btn btn-success w-100"
                                type="submit"
                                onclick="return confirm('Confirm hợp đồng này? Contract->ACTIVE, Room->OCCUPIED, Tenant->ACTIVE');">
                            Confirm Contract
                        </button>
                    </form>
                </c:if>

            </div>
        </div>

    </div>

</layout:layout>
