<%-- 
    Document   : manageUtilities
    Created on : Feb 17, 2026, 10:12:56 PM
    Author     : truon
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="Manage Utilities" active="m_utilities">
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/managerUtilities.css">

    <!-- Page Header -->
    <div class="rh-page-header">
        <div>
            <h1 class="rh-title">Manage Utilities</h1>
            <p class="rh-subtitle">
                Manage utility services and view subscribers
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/manager/add-utility"
           class="rh-btn primary">
            + Add Utility
        </a>
    </div>

    <!-- Card -->
    <div class="rh-card">

        <div class="rh-card-header">
            All Utilities (${utilities.size()})
        </div>

        <div class="rh-table-wrapper">
            <table class="rh-table">
                <thead>
                    <tr>
                        <th>Utility Name</th>
                        <th>Price</th>
                        <th>View Subscribers</th>
                        <th style="text-align:right;">Actions</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="u" items="${utilities}">
                        <tr>
                            <td>
                                <strong>${u.utilityName}</strong>
                            </td>

                            <td>
                                ${u.standardPrice} đ/${u.unit}
                            </td>

                            <td>
                                <a href="${pageContext.request.contextPath}/manager/view-subscribers?utilityId=${u.utilityId}"
                                   class="rh-btn outline small">
                                    View
                                </a>
                            </td>

                            <td class="rh-actions" style="text-align:right;">
                                <a href="${pageContext.request.contextPath}/manager/edit-utility?utilityId=${u.utilityId}"
                                   class="rh-btn outline small">
                                    Edit
                                </a>

                                <a href="${pageContext.request.contextPath}/manager/delete-utility?utilityId=${u.utilityId}"
                                   class="rh-btn danger small"
                                   onclick="return confirm('Are you sure you want to delete this utility?');">
                                    Delete
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty utilities}">
                        <tr>
                            <td colspan="4" style="text-align:center; opacity:0.6;">
                                No utilities found.
                            </td>
                        </tr>
                    </c:if>

                </tbody>
            </table>
        </div>

    </div>

</t:layout>
