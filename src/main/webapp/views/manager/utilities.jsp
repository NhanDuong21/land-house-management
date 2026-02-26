<%-- 
    Document   : utilities
    Created on : Feb 25, 2026, 2:44:36 PM
    Author     : DELL
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<layout:layout title="Manage Utilities"
               active="m_utilities"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerUtilities.css">
    <div class="mb-container">
        <!-- Header -->
        <div class="mb-header">
            <div>
                <h2>Manage Utilities</h2>
                <p>Manage utility services and view subscribers</p>
            </div>
            <a href="${pageContext.request.contextPath}/manager/utilities/create"
               class="mb-generate-btn">
                + Add Utility
            </a>
        </div>

        <!-- TABLE CARD -->
        <div class="mb-card">

            <div class="mb-card-title">
                All Utilities (<c:out value="${empty utilities ? 0 : utilities.size()}"/>)
            </div>

            <table class="mb-table">
                <thead>
                    <tr>
                        <th>Utility Name</th>
                        <th>Price</th>
                        <th>View Subscribers</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="u" items="${utilities}">
                        <tr>
                            <td>${u.utilityName}</td>
                            <td>
                                <fmt:formatNumber value="${u.standardPrice}"
                                                  type="number" groupingUsed="true"/> đ/${u.unit}
                            </td>

                            <td>
                                <a href="${pageContext.request.contextPath}/manager/utilities/subscribers?id=${u.utilityId}&name=${u.utilityName}"
                                   class="mb-view-btn">
                                    👁 View
                                </a>
                            </td>

                            <td class="action-buttons">
                                <a href="${pageContext.request.contextPath}/manager/utilities/edit?id=${u.utilityId}"
                                   class="mb-edit-btn">
                                    <i class="bi bi-pencil-square"></i>
                                    Edit
                                </a>
                                <a href="${pageContext.request.contextPath}/manager/utilities/delete?id=${u.utilityId}"
                                   class="mb-delete-btn"
                                   onclick="return confirm('Are you sure you want to delete this utility?')">
                                    <i class="bi bi-trash-fill"></i>
                                    Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty utilities}">
                        <tr>
                            <td colspan="4" class="mb-empty">No utilities found.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</layout:layout>