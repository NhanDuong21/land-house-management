<%-- 
    Document   : bills
    Created on : Feb 15, 2026, 10:56:52 PM
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

        <!-- DECOR BACKGROUND -->
        <div class="mb-blob mb-blob-1"></div>
        <div class="mb-blob mb-blob-2"></div>
        <div class="mb-blob mb-blob-3"></div>

        <!-- HEADER -->
        <div class="mb-header mb-reveal">
            <div>
                <h2>Manage Billing</h2>
                <p>View and manage all tenant bills</p>
            </div>

            <a href="${pageContext.request.contextPath}/manager/billing/generate"
               class="mb-generate-btn">
                <span>+</span> Generate Bill
            </a>
        </div>

        <!-- SEARCH -->
        <div class="mb-search-box mb-reveal">
            <div class="mb-search-form">
                <div class="mb-search-input-wrap">
                    <span class="mb-search-icon">⌕</span>
                    <input type="text"
                           id="keyword"
                           class="searchBill"
                           placeholder="Search by Bill ID, room number...">
                </div>

                <button class="date-btn" type="button" id="monthTrigger" aria-label="Filter by month">
                    <span class="date-btn-icon">🗓</span>
                    <span class="date-btn-text">Month</span>
                    <input type="month" id="billDate" class="bill-date">
                </button>

                <select id="status">
                    <option value="">All status</option>
                    <option value="PAID">PAID</option>
                    <option value="UNPAID">UNPAID</option>
                    <option value="CANCELLED">CANCELLED</option>
                </select>
            </div>
        </div>

        <!-- TABLE CARD -->
        <div class="mb-card mb-reveal">

            <div class="mb-card-top">
                <div class="mb-card-title" id="billCountTitle">
                    All Bills (${totalBills-1})
                </div>
                <div class="mb-card-subtitle">
                    Billing overview
                </div>
            </div>

            <div class="mb-table-wrap">
                <table class="mb-table">
                    <thead>
                        <tr>
                            <th>Bill ID</th>
                            <th>Room</th>
                            <th>Month</th>
                            <th>Due Date</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Payment Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody id="billTable">
                        <c:forEach var="b" items="${bill}" varStatus="loop">
                            <tr class="bill-row"
                                style="--row-delay: ${loop.index * 0.05}s;"
                                data-bill-id="${b.billId}"
                                data-room-number="${b.roomNumber}"
                                data-status="${b.status}"
                                data-payment-status="${empty b.paymentStatus ? 'NO REQUEST' : b.paymentStatus}">
                                <td class="billId bill-mono">${b.billId}</td>

                                <td class="roomNumber room-strong">${b.roomNumber}</td>

                                <td>
                                    <span class="dateBill">
                                        <fmt:formatDate value="${b.month}" pattern="dd/MM/yyyy"/>
                                    </span>
                                </td>

                                <td>
                                    <fmt:formatDate value="${b.dueDate}" pattern="dd/MM/yyyy"/>
                                </td>

                                <td class="bill-amount">
                                    <fmt:formatNumber value="${b.totalAmount}" 
                                                      type="number" groupingUsed="true"/> đ
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${b.status eq 'PAID'}">
                                            <span class="mb-badge paid">PAID</span>
                                        </c:when>

                                        <c:when test="${b.status eq 'CANCELLED'}">
                                            <span class="mb-badge cancelled">CANCELLED</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="mb-badge unpaid">UNPAID</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${empty b.paymentStatus}">
                                            <span class="mb-badge nopayment">NO REQUEST</span>
                                        </c:when>

                                        <c:when test="${b.paymentStatus eq 'PENDING'}">
                                            <span class="mb-badge pending">PENDING</span>
                                        </c:when>

                                        <c:when test="${b.paymentStatus eq 'CONFIRMED'}">
                                            <span class="mb-badge paid">CONFIRMED</span>
                                        </c:when>

                                        <c:when test="${b.paymentStatus eq 'REJECTED'}">
                                            <span class="mb-badge cancelled">REJECTED</span>
                                        </c:when>
                                    </c:choose>
                                </td>

                                <td class="mb-actions">

                                    <!-- VIEW -->
                                    <a href="${pageContext.request.contextPath}/manager/billing/detail?billId=${b.billId}"
                                       class="mb-view-btn">
                                        👁 View
                                    </a>

                                    <!-- EDIT -->
                                    <c:choose>
                                        <c:when test="${b.status eq 'UNPAID' and b.paymentStatus ne 'PENDING'}">
                                            <a href="${pageContext.request.contextPath}/manager/billing/editBill?billId=${b.billId}"
                                               class="mb-edit-btn">
                                                ✏️ Edit Bill
                                            </a>
                                        </c:when>

                                        <c:otherwise>
                                            <button class="mb-edit-btn disabled" disabled>
                                                ✏️ Edit Bill
                                            </button>
                                        </c:otherwise>
                                    </c:choose>

                                </td>
                            </tr>
                        </c:forEach>

                        <tr id="notFoundBill" style="display: none;">
                            <td colspan="8" class="mb-empty">
                                No bills found.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
                <div class="mb-pagination">

                    <!-- Previous -->
                    <c:if test="${currentPage > 1}">
                        <a class="page-btn"
                           href="${pageContext.request.contextPath}/manager/billing?page=${currentPage - 1}">
                            « Previous
                        </a>
                    </c:if>

                    <!-- Page numbers -->
                    <c:forEach begin="1" end="${totalPages}" var="p">
                        <a class="page-btn ${p == currentPage ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/manager/billing?page=${p}">
                            ${p}
                        </a>
                    </c:forEach>

                    <!-- Next -->
                    <c:if test="${currentPage < totalPages}">
                        <a class="page-btn"
                           href="${pageContext.request.contextPath}/manager/billing?page=${currentPage + 1}">
                            Next »
                        </a>
                    </c:if>

                </div>
            </c:if>

        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/pages/managerBills.js"></script>
</layout:layout>