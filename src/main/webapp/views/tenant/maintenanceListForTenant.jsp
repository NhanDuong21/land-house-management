<%-- 
    Document   : maintenanceListForTenant
    Created on : Mar 8, 2026, 3:29:55 PM
    Author     : truon
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<t:layout title="My Maintenance Requests"
          active="maintenance"
          cssFile="${pageContext.request.contextPath}/assets/css/views/maintenanceList.css">
    <div class="manage-maintenance container-fluid">
        <div class="page-header">
            <div>
                <h2>My Maintenance Requests</h2>
                <p>View all maintenance requests you submitted</p>
            </div>
            <a href="${pageContext.request.contextPath}/tenant/maintenance?action=create"
               class="action-btn">
                <i class="bi bi-plus-circle"></i>
                Create Request
            </a>
        </div>
        <div class="maintenance-card">
            <h5>My Requests (${totalRequest})</h5>
            <div class="maintenance-table-wrap">
                <table class="maintenance-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Room</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th style="width:120px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${requests}" var="r">
                            <tr>
                                <td class="mono">${r.requestId}</td>
                                <td class="fw-bold">${r.roomNumber}</td>
                                <td>${r.issueCategory}</td>
                                <td class="desc">${r.description}</td>
                                <td>
                                    <span class="status ${r.status}">${r.status}</span>
                                </td>
                                <td class="text-center align-middle">
                                    <a href="${pageContext.request.contextPath}/tenant/maintenance?action=view&id=${r.requestId}"
                                       class="action-btn">
                                        <i class="bi bi-eye"></i> View
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requests}">
                            <tr>
                                <td colspan="6" class="empty">No maintenance request found</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPage > 1}">
                <div class="pagination-wrapper">
                    <ul class="pagination">
                        <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${pageIndex - 1}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        <c:forEach begin="1" end="${totalPage}" var="i">
                            <li class="page-item ${i == pageIndex ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${pageIndex == totalPage ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${pageIndex + 1}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </div>
            </c:if>

        </div>
    </div>
</t:layout>