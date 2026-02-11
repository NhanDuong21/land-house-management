<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="layout" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<layout:layout title="Create Contract"
               active="m_contracts">

    <div class="container mt-4" style="max-width:800px">

        <h3>Create New Contract</h3>

        <form method="post"
              action="${pageContext.request.contextPath}/manager/contracts/create">

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

            <!-- Tenant info -->
            <div class="mb-3">
                <label class="form-label">Tenant Name</label>
                <input type="text" name="tenantName" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="text" name="phone" class="form-control" required>
            </div>

            <hr/>

            <div class="mb-3">
                <label class="form-label">Monthly Rent</label>
                <input type="number" name="rent" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Deposit</label>
                <input type="number" name="deposit" class="form-control" required>
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
