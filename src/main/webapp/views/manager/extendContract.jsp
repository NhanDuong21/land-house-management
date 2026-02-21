<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Extend Contract"
               active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerExtendContract.css?v=1">

    <c:set var="cur" value="${cur}"/>

    <div class="me-container">

        <a href="${pageContext.request.contextPath}/manager/contracts/detail?id=${cur.contractId}" class="me-back">
            ← Back to Contract Detail
        </a>

        <div class="me-card">
            <div class="me-card-head">
                <div>
                    <div class="me-title">
                        Extend Contract #<fmt:formatNumber value="${cur.contractId}" pattern="000000"/>
                    </div>
                    <div class="me-sub">
                        Room <b><c:out value="${cur.roomNumber}"/></b>
                        <span class="me-dot">•</span>
                        Tenant <b><c:out value="${cur.tenantName}"/></b>
                    </div>
                </div>
            </div>

            <c:if test="${param.err eq 'DATE'}">
                <div class="me-alert me-alert-danger">
                    End date must be greater than start date.
                </div>
            </c:if>

            <c:if test="${param.err eq 'QR'}">
                <div class="me-alert me-alert-danger">
                    Payment QR data is required.
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/manager/contracts/extend"
                  class="me-form">

                <!-- hidden refs -->
                <input type="hidden" name="oldContractId" value="${cur.contractId}"/>
                <input type="hidden" name="roomId" value="${cur.roomId}"/>
                <input type="hidden" name="tenantId" value="${cur.tenantId}"/>

                <div class="me-grid">

                    <div class="me-field">
                        <label class="me-label">Start Date (suggested)</label>
                        <input class="me-input" type="date" name="startDate"
                               value="<fmt:formatDate value='${suggestedStart}' pattern='yyyy-MM-dd'/>"
                               required>
                        <div class="me-hint">Suggested = old end date + 1 day</div>
                    </div>

                    <div class="me-field">
                        <label class="me-label">End Date</label>
                        <input class="me-input" type="date" name="endDate" required>
                    </div>

                    <div class="me-field">
                        <label class="me-label">Monthly Rent</label>
                        <input class="me-input" type="number" name="monthlyRent" min="0"
                               value="${cur.monthlyRent}" required>
                    </div>

                    <div class="me-field">
                        <label class="me-label">Deposit</label>
                        <input class="me-input" type="number" name="deposit" min="0"
                               value="${cur.deposit}" required>
                    </div>

                    <div class="me-field me-field-full">
                        <label class="me-label">Payment QR Data</label>
                        <input class="me-input" type="text" name="paymentQrData"
                               value="${cur.paymentQrData}" placeholder="/assets/images/qr/myqr.png" required>
                        <div class="me-hint">Keep same QR if using same bank account.</div>
                    </div>

                </div>

                <div class="me-actions">
                    <button type="submit" class="me-btn me-btn-primary"
                            onclick="return confirm('Create NEW PENDING renewal contract? Tenant will confirm transfer, then you confirm to activate.');">
                        Create Renewal (PENDING)
                    </button>

                    <a class="me-btn me-btn-ghost"
                       href="${pageContext.request.contextPath}/manager/contracts/detail?id=${cur.contractId}">
                        Cancel
                    </a>
                </div>

                <div class="me-note">
                    After creating, tenant will see a new <b>PENDING</b> contract in their account and confirm payment.
                </div>
            </form>
        </div>

    </div>

</layout:layout>