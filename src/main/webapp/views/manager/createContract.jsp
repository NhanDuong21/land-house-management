<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<layout:layout title="Create Contract" active="m_contracts">

    <div class="container mt-4" style="max-width:800px">
        <h3>Create New Contract</h3>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" style="margin-top:12px;">
                ${param.error}
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/manager/contracts/create">

            <!-- Room -->
            <div class="mb-3">
                <label class="form-label">Room</label>
                <select name="roomId" class="form-control" required>
                    <c:forEach var="r" items="${rooms}">
                        <option value="${r.roomId}">
                            ${r.roomNumber} - ${r.price}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <hr/>

            <!-- Tenant info (ALL REQUIRED) -->
            <div class="mb-3">
                <label class="form-label">Tenant Name</label>
                <input type="text" name="tenantName" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Citizen ID</label>
                <input type="text" name="identityCode" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="text" name="phone" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Address</label>
                <input type="text" name="address" class="form-control" required>
            </div>

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

            <hr/>

            <!-- Contract (ALL REQUIRED) -->
            <div class="mb-3">
                <label class="form-label">Monthly Rent</label>
                <input type="number" name="rent" class="form-control" required min="0">
            </div>

            <div class="mb-3">
                <label class="form-label">Deposit</label>
                <input type="number" name="deposit" class="form-control" required min="0">
            </div>

            <div class="mb-3">
                <label class="form-label">Start Date</label>
                <input type="date" name="startDate" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">End Date</label>
                <input type="date" name="endDate" class="form-control" required>
            </div>

            <button class="btn btn-dark">Create Contract & Send OTP</button>
        </form>
    </div>

</layout:layout>
