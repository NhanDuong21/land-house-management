<%-- 
    Document   : bills
    Created on : Feb 15, 2026, 10:56:52 PM
    Author     : To Thi Thao Trang - CE191027
--%>

<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Billing detail"
               active="m_bills"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerBills.css">

<div class="mb-container">

    <!-- HEADER -->
    <div class="mb-header">
        <div>
            <h2>Manage Billing</h2>
            <p>View and manage all tenant bills</p>
        </div>

        <a href="${pageContext.request.contextPath}/manager/bills/create"
           class="mb-generate-btn">
            + Generate Bill
        </a>
    </div>

    <!-- SEARCH -->
    <div class="mb-search-box">
        <input type="text" placeholder="Search by room number...">
    </div>

    <!-- TABLE CARD -->
    <div class="mb-card">

        <div class="mb-card-title">
            All Bills (<c:out value="${empty bill ? 0 : bill.size()}"/>)
        </div>

        <table class="mb-table">
            <thead>
                <tr>
                    <th>Bill ID</th>
                    <th>Room</th>
                    <th>Month</th>
                    <th>Total Amount</th>
                    <th>Due Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="b" items="${bill}">
                    <tr>
                        <td>${b.billId}</td>
                        <td>${b.roomNumber}</td>
                        <td>
                            <fmt:formatDate value="${b.month}" pattern="MMMM"/>
                        </td>
                        <td>
                            <fmt:formatNumber value="${b.totalAmount}" 
                                              type="number" groupingUsed="true"/> đ
                        </td>
                        <td>
                            <fmt:formatDate value="${b.dueDate}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${b.status eq 'PAID'}">
                                    <span class="mb-badge paid">PAID</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="mb-badge unpaid">UNPAID</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/bills/detail?billId=${b.billId}"
                               class="mb-view-btn">
                                👁 View
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty bill}">
                    <tr>
                        <td colspan="7" class="mb-empty">
                            No bills found.
                        </td>
                    </tr>
                </c:if>

            </tbody>
        </table>

    </div>
</div>

</layout:layout>
