<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Manage Contracts"
               active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerContracts.css">

    <div class="mc-wrap">

        <div class="mc-head">
            <div class="mc-head-left">
                <div class="mc-title">Manage Contracts</div>
                <div class="mc-sub">View and manage all rental contracts</div>
            </div>

            <a class="mc-add-btn" href="${pageContext.request.contextPath}/manager/contracts/create">
                <span class="mc-plus">＋</span>
                <span>Add Contract</span>
            </a>
        </div>

        <div class="mc-search-card">
            <div class="mc-search">
                <span class="mc-search-icon">🔍</span>
                <input class="mc-search-input" type="text"
                       placeholder="Search by contract ID, room number, or tenant name..."
                       onkeydown="return false;">
            </div>
        </div>

        <div class="mc-card">
            <div class="mc-card-title">
                All Contracts (<c:out value="${empty contracts ? 0 : contracts.size()}"/>)
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
                                    <a class="mc-view-btn" href="#" onclick="return false;">
                                        <span class="mc-eye">👁️</span>
                                        <span>View</span>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                    </tbody>
                </table>
            </div>
        </div>

    </div>

</layout:layout>
