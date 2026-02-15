<%-- 
    Document   : contract
    Author     : Duong Thien Nhan - CE190741
--%>
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

        <c:if test="${param.confirmed eq '1'}">
            <div style="margin:12px 0;padding:12px 14px;border-radius:14px;background:#ecfdf3;border:1px solid #86efac;color:#166534;font-weight:800;">
                ✅ Confirm contract successfully.
            </div>
        </c:if>

        <c:if test="${param.err eq '1'}">
            <div style="margin:12px 0;padding:12px 14px;border-radius:14px;background:#fef2f2;border:1px solid #fecaca;color:#991b1b;font-weight:800;">
                ❌ Confirm failed.
                <c:if test="${not empty param.code}">
                    <span style="margin-left:10px;font-weight:900;">(code: ${param.code})</span>
                </c:if>

                <c:if test="${param.code eq 'NEED_TENANT_PAYMENT'}">
                    <div style="margin-top:6px;color:#7f1d1d;font-weight:700;">
                        Vui lòng chờ TENANT confirm payment
                    </div>
                </c:if>
            </div>
        </c:if>

        <!-- SEARCH BAR (giữ form nhưng JS sẽ chặn submit) -->
        <div class="mc-search-card">
            <form id="mcSearchForm" class="mc-search" method="get"
                  action="${pageContext.request.contextPath}/manager/contracts"
                  style="display:flex; align-items:center; gap:10px;">

                <span class="mc-search-icon">🔍</span>

                <input id="mcQ" class="mc-search-input" type="text" name="q"
                       value="${q}"
                       placeholder="Search by contract ID, room number, or tenant name...">

                <select id="mcStatus" name="status" class="mc-search-input" style="max-width:180px;">
                    <option value="" ${empty status ? "selected" : ""}>All Status</option>
                    <option value="PENDING"   ${status eq 'PENDING' ? "selected" : ""}>PENDING</option>
                    <option value="ACTIVE"    ${status eq 'ACTIVE' ? "selected" : ""}>ACTIVE</option>
                    <option value="ENDED"     ${status eq 'ENDED' ? "selected" : ""}>ENDED</option>
                    <option value="CANCELLED" ${status eq 'CANCELLED' ? "selected" : ""}>CANCELLED</option>
                </select>

                <select id="mcPageSize" name="pageSize" class="mc-search-input" style="max-width:120px;">
                    <option value="5"  ${pageSize == 5 ? "selected" : ""}>5 / page</option>
                    <option value="10" ${pageSize == 10 ? "selected" : ""}>10 / page</option>
                    <option value="20" ${pageSize == 20 ? "selected" : ""}>20 / page</option>
                    <option value="50" ${pageSize == 50 ? "selected" : ""}>50 / page</option>
                </select>

                <!-- nút Search bạn có thể giữ hoặc xóa -->
                <button type="submit" class="mc-add-btn" style="padding:10px 14px;">
                    Search
                </button>

                <c:if test="${not empty q || not empty status}">
                    <a href="${pageContext.request.contextPath}/manager/contracts"
                       class="mc-add-btn"
                       style="padding:10px 14px; background:#e2e8f0; color:#0f172a;">
                        Clear
                    </a>
                </c:if>
            </form>
        </div>

        <!-- TABLE FRAGMENT WRAPPER -->
        <div id="contractTableWrapper">
            <jsp:include page="_contracts_table.jsp"/>
        </div>

    </div>

    <script>
        window.__CTX = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/pages/managerContracts.js"></script>

</layout:layout>
