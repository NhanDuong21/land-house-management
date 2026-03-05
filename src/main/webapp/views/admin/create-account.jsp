<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<t:layout 
    title="Create Account"
    active="a_accounts"
    cssFile="${ctx}/assets/css/views/admin/create-account.css">




    <div class="create-container">

        <h2>Create New Account</h2>

        <c:if test="${not empty error}">
            <div class="ma-alert ma-alert-danger">
                ${error}
            </div>
        </c:if>

        <div class="profile-card">

            <h3 class="section-title">Create Account</h3>

            <form method="post" class="profile-form">

                <div class="form-grid">

                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" required>
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="phoneNumber" required>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label>Role</label>
                        <select name="role">
                            <option value="TENANT">Tenant</option>
                            <option value="MANAGER">Manager</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Date of Birth</label>
                        <input type="date" name="dob" required>
                    </div>

                    <div class="form-group">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="0">Male</option>
                            <option value="1">Female</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Citizen ID</label>
                        <input type="text" name="identityCode">
                    </div>

                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address">
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" required>
                    </div>

                </div>

                <div class="form-actions">

                    <a href="${ctx}/admin/accounts" class="btn-cancel">
                        Cancel
                    </a>

                    <button type="submit" class="btn-save">
                        Create Account
                    </button>

                </div>

            </form>

        </div>

    </div>
    <script src="${ctx}/assets/js/pages/admin/create-account.js"></script>

</t:layout>