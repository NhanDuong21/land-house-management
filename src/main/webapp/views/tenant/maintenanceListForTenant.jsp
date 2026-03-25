<%-- 
    Document   : maintenanceListForTenant
    Created on : Mar 8, 2026, 3:29:55 PM
    Author     : truon
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<t:layout title="My Maintenance Requests"
          active="maintenance"
          cssFile="${ctx}/assets/css/views/maintenanceListForTenant.css">

    <div class="mlt-container">

        <div class="mlt-header mlt-reveal">
            <div>
                <h2>My Maintenance Requests</h2>
                <p>View all maintenance requests you submitted</p>
            </div>

            <a href="${ctx}/tenant/maintenance?action=create" class="mlt-primary-btn mlt-ripple">
                <span class="mlt-btn-ico">
                    <i class="bi bi-plus-circle"></i>
                </span>
                <span class="mlt-btn-text">Create Request</span>
            </a>
        </div>

        <div class="mlt-card mlt-reveal">
            <div class="mlt-card-head">
                <div class="mlt-card-title">My Requests (${totalRequest})</div>
            </div>

            <div class="mlt-table-wrap">
                <table class="mlt-table">
                    <thead>
                        <tr>
                            <th style="width:80px;">ID</th>
                            <th style="width:90px;">Room</th>
                            <th style="width:160px;">Category</th>
                            <th>Description</th>
                            <th style="width:140px;">Status</th>
                            <th style="width:120px;">Action</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${requests}" var="r">
                            <tr class="mlt-row">
                                <td class="mlt-mono">${r.requestId}</td>
                                <td class="mlt-room">${r.roomNumber}</td>
                                <td>${r.issueCategory}</td>
                                <td class="mlt-desc" title="${r.description}">${r.description}</td>
                                <td>
                                    <span class="mlt-badge status-${r.status}">
                                        ${r.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="${ctx}/tenant/maintenance?action=view&id=${r.requestId}"
                                       class="mlt-action-btn mlt-ripple">
                                        <i class="bi bi-eye"></i>
                                        <span class="mlt-btn-text">View</span>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty requests}">
                            <tr>
                                <td colspan="6" class="mlt-empty">
                                    No maintenance request found
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPage > 1}">
                <div class="mlt-pager">
                    <ul class="mlt-pagination">
                        <li class="${pageIndex == 1 ? 'disabled' : ''}">
                            <a href="?page=${pageIndex - 1}" class="mlt-ripple" aria-label="Previous">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>

                        <c:forEach begin="1" end="${totalPage}" var="i">
                            <li class="${i == pageIndex ? 'active' : ''}">
                                <a href="?page=${i}" class="mlt-ripple">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="${pageIndex == totalPage ? 'disabled' : ''}">
                            <a href="?page=${pageIndex + 1}" class="mlt-ripple" aria-label="Next">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>

    <script src="${ctx}/assets/js/pages/maintenanceListForTenant.js"></script>
</t:layout>