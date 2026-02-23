<%--
    Document   : createContractExisting
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<layout:layout title="Create Contract (Existing Tenant)" active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerCreateContracts.css?v=1">

    <div class="mcc-wrap">

        <!-- Page header -->
        <div class="mcc-pagehead">
            <div class="mcc-pagehead-left">
                <div class="mcc-title">
                    <i class="bi bi-person-check"></i>
                    Create Contract (Existing Tenant)
                </div>
                <div class="mcc-subtitle">
                    Select a tenant account &amp; contract terms to create a PENDING contract.
                </div>

                <div class="mcc-breadcrumb">
                    <span class="mcc-bc-item">
                        <i class="bi bi-speedometer2"></i>
                        Manager
                    </span>
                    <span class="mcc-bc-sep">/</span>
                    <span class="mcc-bc-item">
                        <i class="bi bi-file-earmark-text"></i>
                        Contracts
                    </span>
                    <span class="mcc-bc-sep">/</span>
                    <span class="mcc-bc-item active">Create Existing</span>
                </div>
            </div>

            <div class="mcc-pagehead-right">
                <span class="mcc-badge">
                    <i class="bi bi-shield-check"></i>
                    Manager
                </span>
            </div>
        </div>

        <!-- Card -->
        <div class="mcc-card">

            <c:if test="${not empty param.error}">
                <div class="mcc-alert mcc-alert-danger">
                    <div class="mcc-alert-ic"><i class="bi bi-exclamation-triangle-fill"></i></div>
                    <div class="mcc-alert-tx">
                        <div class="mcc-alert-title">Oops!</div>
                        <div class="mcc-alert-sub">${param.error}</div>
                    </div>
                </div>
            </c:if>

            <form method="post"
                  action="${pageContext.request.contextPath}/manager/contracts/create-existing"
                  class="mcc-form">

                <!-- ROOM -->
                <div class="mcc-section">
                    <div class="mcc-section-head">
                        <div class="mcc-section-title">
                            <i class="bi bi-door-open"></i>
                            Room
                        </div>
                        <div class="mcc-section-desc">Choose an AVAILABLE room.</div>
                    </div>

                    <div class="mcc-field">
                        <label class="mcc-label">
                            <i class="bi bi-building"></i>
                            Select room
                        </label>

                        <div class="mcc-control">
                            <select name="roomId" class="form-control mcc-control-input" required>
                                <c:forEach var="r" items="${rooms}">
                                    <option value="${r.roomId}">
                                        ${r.roomNumber} - ${r.price}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mcc-help">
                            <i class="bi bi-info-circle"></i>
                            Make sure this room is available and suitable for the tenant.
                        </div>
                    </div>
                </div>

                <!-- TENANT -->
                <div class="mcc-section">
                    <div class="mcc-section-head">
                        <div class="mcc-section-title">
                            <i class="bi bi-person-lines-fill"></i>
                            Existing Tenant
                        </div>
                        <div class="mcc-section-desc">Select a tenant account from the system.</div>
                    </div>

                    <div class="mcc-field">
                        <label class="mcc-label">
                            <i class="bi bi-person-badge"></i>
                            Select tenant account
                        </label>

                        <div class="mcc-control">
                            <select name="tenantId" class="form-control mcc-control-input" required>
                                <c:forEach var="t" items="${tenants}">
                                    <option value="${t.tenantId}">
                                        ${t.fullName} - ${t.email} - ${t.phoneNumber}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mcc-help">
                            <i class="bi bi-lightning-charge"></i>
                            A new PENDING contract will be created for this tenant (no OTP flow).
                        </div>
                    </div>
                </div>

                <!-- CONTRACT TERMS -->
                <div class="mcc-section">
                    <div class="mcc-section-head">
                        <div class="mcc-section-title">
                            <i class="bi bi-journal-text"></i>
                            Contract Terms
                        </div>
                        <div class="mcc-section-desc">Set rental pricing and contract period.</div>
                    </div>

                    <div class="mcc-grid-2">
                        <div class="mcc-field">
                            <label class="mcc-label">
                                <i class="bi bi-wallet2"></i>
                                Monthly Rent
                            </label>
                            <div class="mcc-control">
                                <input type="number" name="rent" class="form-control mcc-control-input"
                                       required min="0"
                                       placeholder="e.g. 3500000">
                            </div>
                        </div>

                        <div class="mcc-field">
                            <label class="mcc-label">
                                <i class="bi bi-safe2"></i>
                                Deposit
                            </label>
                            <div class="mcc-control">
                                <input type="number" name="deposit" class="form-control mcc-control-input"
                                       required min="0"
                                       placeholder="e.g. 7000000">
                            </div>
                        </div>
                    </div>

                    <div class="mcc-grid-2">
                        <div class="mcc-field">
                            <label class="mcc-label">
                                <i class="bi bi-calendar2-check"></i>
                                Start Date
                            </label>
                            <div class="mcc-control">
                                <input type="date" name="startDate" class="form-control mcc-control-input" required>
                            </div>
                        </div>

                        <div class="mcc-field">
                            <label class="mcc-label">
                                <i class="bi bi-calendar2-x"></i>
                                End Date
                            </label>
                            <div class="mcc-control">
                                <input type="date" name="endDate" class="form-control mcc-control-input" required>
                            </div>
                        </div>
                    </div>

                    <div class="mcc-help mcc-help-compact">
                        <i class="bi bi-info-circle"></i>
                        This flow creates a PENDING contract directly (no OTP confirmation required).
                    </div>
                </div>

                <!-- ACTIONS -->
                <div class="mcc-actions mcc-actions-split">
                    <a class="mcc-btn mcc-btn-ghost"
                       href="${pageContext.request.contextPath}/manager/contracts">
                        <i class="bi bi-arrow-left"></i>
                        Cancel
                    </a>

                    <button class="mcc-btn mcc-btn-primary" type="submit">
                        <i class="bi bi-check2-circle"></i>
                        Create Contract (PENDING)
                    </button>
                </div>

            </form>
        </div>
    </div>

</layout:layout>