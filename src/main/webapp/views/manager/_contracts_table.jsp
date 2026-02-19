<%-- 
    Document   : contract_table
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="mc-card">
    <div class="mc-card-title">
        <c:choose>
            <c:when test="${not empty q || not empty status}">
                Results: <c:out value="${total}"/> contracts
                <c:if test="${not empty q}"> | keyword: "<c:out value="${q}"/>"</c:if>
                <c:if test="${not empty status}"> | status: <b><c:out value="${status}"/></b></c:if>
            </c:when>
            <c:otherwise>
                All Contracts (<c:out value="${total}"/>)
            </c:otherwise>
        </c:choose>
    </div>

    <div class="mc-table-wrap">
        <table class="mc-table">
            <thead>
                <tr>
                    <th>Contract ID</th>
                    <th>Room</th>
                    <th>Tenant Name</th>
                    <th>Start Date</th>
                    <th>Monthly Rent</th>
                    <th>Status</th>
                    <th class="mc-th-action">Action</th>
                </tr>
            </thead>

            <tbody>
                <c:if test="${empty contracts}">
                    <tr>
                        <td colspan="7" style="padding:18px 12px;color:#64748b;font-weight:700;">
                            No contracts found.
                        </td>
                    </tr>
                </c:if>

                <c:forEach var="c" items="${contracts}">
                    <tr>
                        <td class="mc-mono">${c.displayId}</td>
                        <td>${c.roomNumber}</td>
                        <td>${c.tenantName}</td>
                        <td>
                            <fmt:formatDate value="${c.startDate}" pattern="MMMM d, yyyy"/>
                        </td>
                        <td class="mc-money">
                            <fmt:formatNumber value="${c.monthlyRent}" type="number" groupingUsed="true"/> đ
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${c.status eq 'ACTIVE'}">
                                    <span class="mc-badge active">ACTIVE</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="mc-badge pending">${c.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="mc-td-action">
                            <a class="mc-view-btn"
                               href="${pageContext.request.contextPath}/manager/contracts/detail?id=${c.contractId}">
                                <span class="mc-eye">👁️</span>
                                <span>View</span>
                            </a>

                            <c:if test="${c.status eq 'PENDING'}">
                                <form method="post"
                                      action="${pageContext.request.contextPath}/manager/contracts/confirm"
                                      style="display:inline;">
                                    <input type="hidden" name="contractId" value="${c.contractId}"/>

                                    <button type="submit"
                                            class="mc-view-btn"
                                            style="margin-left:10px;"
                                            onclick="return confirm('Confirm contract này? Contract->ACTIVE, Room->OCCUPIED, Tenant->ACTIVE');">
                                        ✅ Confirm
                                    </button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:14px; flex-wrap:wrap; gap:10px;">

            <div style="color:#475569; font-weight:700;">
                Page <c:out value="${page}"/> / <c:out value="${totalPages}"/> • Total: <c:out value="${total}"/>
            </div>

            <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap;">

                <c:url var="baseUrl" value="/manager/contracts">
                    <c:param name="q" value="${q}"/>
                    <c:param name="status" value="${status}"/>
                    <c:param name="pageSize" value="${pageSize}"/>
                    <c:param name="ajax" value="1"/>
                </c:url>

                <a class="mc-view-btn" href="${baseUrl}&page=${p}">...</a>


                <c:choose>
                    <c:when test="${page > 1}">
                        <a class="mc-view-btn" href="${baseUrl}&page=${page - 1}">← Prev</a>
                    </c:when>
                    <c:otherwise>
                        <span class="mc-view-btn" style="opacity:.5; cursor:not-allowed;">← Prev</span>
                    </c:otherwise>
                </c:choose>

                <c:set var="start" value="${page - 3}"/>
                <c:set var="end" value="${page + 3}"/>
                <c:if test="${start < 1}"><c:set var="start" value="1"/></c:if>
                <c:if test="${end > totalPages}"><c:set var="end" value="${totalPages}"/></c:if>

                <c:forEach var="p" begin="${start}" end="${end}">
                    <c:choose>
                        <c:when test="${p == page}">
                            <span class="mc-view-btn" style="background:#0ea5e9;color:white;border:none;">
                                <c:out value="${p}"/>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <a class="mc-view-btn" href="${baseUrl}&page=${p}">
                                <c:out value="${p}"/>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:choose>
                    <c:when test="${page < totalPages}">
                        <a class="mc-view-btn" href="${baseUrl}&page=${page + 1}">Next →</a>
                    </c:when>
                    <c:otherwise>
                        <span class="mc-view-btn" style="opacity:.5; cursor:not-allowed;">Next →</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </c:if>
</div>
