<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Extend Contract"
               active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerCreateContracts.css">

    <c:set var="cur" value="${cur}"/>

    <div class="mc-wrap">
        <a href="${pageContext.request.contextPath}/manager/contracts/detail?id=${cur.contractId}" class="tcd-back">
            ← Back to Contract Detail
        </a>

        <div class="mc-card" style="margin-top:12px;">
            <div class="mc-card-title">
                Extend Contract #<fmt:formatNumber value="${cur.contractId}" pattern="000000"/>
                • Room <b><c:out value="${cur.roomNumber}"/></b>
                • Tenant <b><c:out value="${cur.tenantName}"/></b>
            </div>

            <c:if test="${param.err eq 'DATE'}">
                <div style="margin:12px 0;padding:12px 14px;border-radius:14px;background:#fef2f2;border:1px solid #fecaca;color:#991b1b;font-weight:800;">
                    ❌ End date must be greater than start date.
                </div>
            </c:if>
            <c:if test="${param.err eq 'QR'}">
                <div style="margin:12px 0;padding:12px 14px;border-radius:14px;background:#fef2f2;border:1px solid #fecaca;color:#991b1b;font-weight:800;">
                    ❌ Payment QR data is required.
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/manager/contracts/extend"
                  style="margin-top:14px; display:grid; gap:12px; max-width:720px;">

                <!-- hidden refs -->
                <input type="hidden" name="oldContractId" value="${cur.contractId}"/>
                <input type="hidden" name="roomId" value="${cur.roomId}"/>
                <input type="hidden" name="tenantId" value="${cur.tenantId}"/>

                <div>
                    <div style="font-weight:900;margin-bottom:6px;">Start Date (suggested)</div>
                    <input class="mc-search-input" type="date" name="startDate"
                           value="<fmt:formatDate value='${suggestedStart}' pattern='yyyy-MM-dd'/>"
                           required>
                    <div style="margin-top:6px; color:#64748b; font-weight:700;">
                        Suggested = old end date + 1 day
                    </div>
                </div>

                <div>
                    <div style="font-weight:900;margin-bottom:6px;">End Date</div>
                    <input class="mc-search-input" type="date" name="endDate" required>
                </div>

                <div>
                    <div style="font-weight:900;margin-bottom:6px;">Monthly Rent</div>
                    <input class="mc-search-input" type="number" name="monthlyRent" min="0"
                           value="${cur.monthlyRent}" required>
                </div>

                <div>
                    <div style="font-weight:900;margin-bottom:6px;">Deposit</div>
                    <input class="mc-search-input" type="number" name="deposit" min="0"
                           value="${cur.deposit}" required>
                </div>

                <div>
                    <div style="font-weight:900;margin-bottom:6px;">Payment QR Data</div>
                    <input class="mc-search-input" type="text" name="paymentQrData"
                           value="${cur.paymentQrData}" placeholder="/assets/images/qr/myqr.png" required>
                    <div style="margin-top:6px; color:#64748b; font-weight:700;">
                        Keep same QR if using same bank account.
                    </div>
                </div>

                <div style="display:flex; gap:10px; flex-wrap:wrap; margin-top:8px;">
                    <button type="submit" class="mc-add-btn" style="padding:10px 14px;"
                            onclick="return confirm('Create NEW PENDING renewal contract? Tenant will confirm transfer, then you confirm to activate.');">
                        ✅ Create Renewal (PENDING)
                    </button>

                    <a class="mc-add-btn"
                       href="${pageContext.request.contextPath}/manager/contracts/detail?id=${cur.contractId}"
                       style="padding:10px 14px; background:#e2e8f0; color:#0f172a;">
                        Cancel
                    </a>
                </div>

                <div style="margin-top:10px; color:#475569; font-weight:700;">
                    After creating, tenant will see a new <b>PENDING</b> contract in their account and confirm payment.
                </div>
            </form>
        </div>
    </div>

</layout:layout>
