<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="My Contracts" active="tenant_contract">

    <div class="container" style="max-width: 980px; margin-top: 28px;">

        <div style="font-size:34px;font-weight:900;letter-spacing:-0.02em;">My Contracts</div>
        <div style="color:#64748b;font-weight:650;margin-top:6px;">
            View your rental contracts
        </div>

        <div class="card mt-4" style="border-radius:18px;">
            <div class="card-body" style="padding: 18px;">

                <c:if test="${empty contracts}">
                    <div style="color:#64748b;font-weight:700;padding:10px 6px;">
                        You don't have any contracts yet.
                    </div>
                </c:if>

                <c:forEach var="c" items="${contracts}">
                    <div style="
                         border:1px solid rgba(2,6,23,0.08);
                         border-radius:16px;
                         padding:18px;
                         margin-bottom:14px;
                         background:#fff;">

                        <!-- Header -->
                        <div style="display:flex;justify-content:space-between;align-items:center;">
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div style="
                                     width:42px;height:42px;border-radius:12px;
                                     background:rgba(37,99,235,0.10);
                                     display:flex;align-items:center;justify-content:center;
                                     font-size:18px;">
                                    📄
                                </div>

                                <div>
                                    <div style="font-size:18px;font-weight:900;">
                                        Contract #<fmt:formatNumber value="${c.contractId}" pattern="000000"/>
                                    </div>
                                    <div style="color:#64748b;font-weight:650;margin-top:2px;">
                                        <c:out value="${c.status}"/>
                                    </div>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${c.status eq 'ACTIVE'}">
                                    <span style="
                                          padding:8px 12px;border-radius:999px;
                                          background:#dcfce7;color:#166534;
                                          border:1px solid #86efac;
                                          font-weight:900;font-size:12px;">
                                        ACTIVE
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="
                                          padding:8px 12px;border-radius:999px;
                                          background:#fffbeb;color:#92400e;
                                          border:1px solid #fcd34d;
                                          font-weight:900;font-size:12px;">
                                        PENDING
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <hr style="margin:14px 0;opacity:0.12;"/>

                        <!-- Body rows -->
                        <div style="display:grid;grid-template-columns: 1fr;gap:14px;">

                            <!-- Room -->
                            <div style="display:flex;gap:12px;">
                                <div style="width:26px;opacity:0.75;">📍</div>
                                <div>
                                    <div style="font-weight:900;">Room</div>
                                    <div style="color:#475569;font-weight:650;margin-top:2px;">
                                        <c:out value="${c.roomNumber}"/>
                                        <c:if test="${not empty c.blockName}">
                                            - <c:out value="${c.blockName}"/>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Duration -->
                            <div style="display:flex;gap:12px;">
                                <div style="width:26px;opacity:0.75;">📅</div>
                                <div>
                                    <div style="font-weight:900;">Duration</div>
                                    <div style="color:#475569;font-weight:650;margin-top:2px;">
                                        <fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/>
                                        -
                                        <c:choose>
                                            <c:when test="${empty c.endDate}">
                                                ...
                                            </c:when>
                                            <c:otherwise>
                                                <fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Monthly Rent -->
                            <div style="display:flex;gap:12px;">
                                <div style="width:26px;opacity:0.75;">💲</div>
                                <div>
                                    <div style="font-weight:900;">Monthly Rent</div>
                                    <div style="color:#475569;font-weight:650;margin-top:2px;">
                                        <fmt:formatNumber value="${c.monthlyRent}" type="number" groupingUsed="true"/> đ
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div style="margin-top:14px;">
                            <a class="btn btn-outline-dark"
                               href="${pageContext.request.contextPath}/tenant/contract/detail?id=${c.contractId}"
                               style="border-radius:12px;font-weight:800;">
                                View
                            </a>
                        </div>

                    </div>
                </c:forEach>

            </div>
        </div>

    </div>

</layout:layout>
