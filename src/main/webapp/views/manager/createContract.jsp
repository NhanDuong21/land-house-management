<%-- 
    Document   : createContract
    Author     : Duong Thien Nhan - CE190741
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<layout:layout title="Create Contract" active="m_contracts"
               cssFile="${pageContext.request.contextPath}/assets/css/views/managerCreateContracts.css">

    <div class="container mt-4 contract-create" style="max-width:900px">
        <div class="contract-card">
            <div class="contract-header">
                <div>
                    <h3 class="contract-title">Create New Contract</h3>
                    <p class="contract-subtitle">Fill tenant info & contract terms to generate and send OTP.</p>
                </div>
                <span class="contract-badge">Manager</span>
            </div>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger contract-alert">
                    <strong>Oops!</strong> ${param.error}
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/manager/contracts/create" class="contract-form">

                <!-- Room -->
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
                        <div class="helper-text">Choose an available room to attach to this contract.</div>
                    </div>
                </div>

                <!-- Tenant info -->
                <div class="section">
                    <div class="section-title">Tenant Information</div>

                    <div class="grid-2">
                        <div class="mb-3">
                            <label class="form-label">Tenant Name</label>
                            <input type="text" name="tenantName" class="form-control" required placeholder="e.g. Nguyen Van A">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Citizen ID</label>
                            <input type="text" name="identityCode" class="form-control" required placeholder="e.g. 012345678901">
                        </div>
                    </div>

                    <div class="grid-2">
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" required placeholder="e.g. tenant@email.com">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Phone</label>
                            <input type="text" name="phone" class="form-control" required placeholder="e.g. 09xxxxxxxx">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Address</label>
                        <input type="text" name="address" class="form-control" required placeholder="Street, ward, district...">
                    </div>

                    <div class="grid-2">
                        <div class="mb-3">
                            <label class="form-label">Date of Birth</label>
                            <input type="date" name="dob" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Gender</label>
                            <select name="gender" class="form-control" required>
                                <option value="">-- Select --</option>
                                <option value="0">Female</option>
                                <option value="1">Male</option>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Contract -->
                <div class="section">
                    <div class="section-title">Contract Terms</div>

                    <div class="grid-2">
                        <div class="mb-3">
                            <label class="form-label">Monthly Rent</label>
                            <input type="number" name="rent" class="form-control" required min="0" placeholder="e.g. 3500000">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Deposit</label>
                            <input type="number" name="deposit" class="form-control" required min="0" placeholder="e.g. 7000000">
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

                <div class="actions">
                    <button class="btn btn-dark btn-submit" type="submit">
                        Create Contract & Send OTP
                    </button>
                </div>
            </form>
        </div>
    </div>

</layout:layout>
