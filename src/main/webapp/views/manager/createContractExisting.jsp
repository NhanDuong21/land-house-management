<%-- 
    Document   : createContractExisting
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<layout:layout title="Create Contract (Existing Tenant)" active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerCreateContracts.css?v=1">

    <div class="container mt-4 contract-create" style="max-width:900px">
        <div class="contract-card">

            <div class="contract-header">
                <div>
                    <h3 class="contract-title">Create Contract (Existing Tenant)</h3>
                    <p class="contract-subtitle">
                        Select a tenant account & contract terms to create a PENDING contract.
                    </p>
                </div>
                <span class="contract-badge">Manager</span>
            </div>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger contract-alert">
                    <strong>Oops!</strong> ${param.error}
                </div>
            </c:if>

            <form method="post"
                  action="${pageContext.request.contextPath}/manager/contracts/create-existing"
                  class="contract-form">

                <!-- ROOM -->
                <div class="section">
                    <div class="section-title">Room</div>

                    <div class="mb-3">
                        <label class="form-label">Select room</label>
                        <select name="roomId" class="form-control" required>
                            <c:forEach var="r" items="${rooms}">
                                <option value="${r.roomId}">
                                    ${r.roomNumber} - ${r.price}
                                </option>
                            </c:forEach>
                        </select>

                        <div class="helper-text">
                            Choose an AVAILABLE room.
                        </div>
                    </div>
                </div>

                <!-- TENANT -->
                <div class="section">
                    <div class="section-title">Existing Tenant</div>

                    <div class="mb-3">
                        <label class="form-label">Select tenant account</label>
                        <select name="tenantId" class="form-control" required>
                            <c:forEach var="t" items="${tenants}">
                                <option value="${t.tenantId}">
                                    ${t.fullName} - ${t.email} - ${t.phoneNumber}
                                </option>
                            </c:forEach>
                        </select>

                        <div class="helper-text">
                            A new PENDING contract will be created for this tenant (no OTP flow).
                        </div>
                    </div>
                </div>

                <!-- CONTRACT TERMS -->
                <div class="section">
                    <div class="section-title">Contract Terms</div>

                    <div class="grid-2">
                        <div class="mb-3">
                            <label class="form-label">Monthly Rent</label>
                            <input type="number" name="rent" class="form-control"
                                   required min="0"
                                   placeholder="e.g. 3500000">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Deposit</label>
                            <input type="number" name="deposit" class="form-control"
                                   required min="0"
                                   placeholder="e.g. 7000000">
                        </div>
                    </div>

                    <div class="grid-2">
                        <div class="mb-3">
                            <label class="form-label">Start Date</label>
                            <input type="date" name="startDate" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">End Date</label>
                            <input type="date" name="endDate" class="form-control" required>
                        </div>
                    </div>
                </div>

                <!-- ACTIONS -->
                <div class="actions actions-row">
                    <a class="btn btn-outline-dark btn-cancel"
                       href="${pageContext.request.contextPath}/manager/contracts">
                        Cancel
                    </a>

                    <button class="btn btn-dark btn-submit" type="submit">
                        Create Contract (PENDING)
                    </button>
                </div>

            </form>
        </div>
    </div>

</layout:layout>