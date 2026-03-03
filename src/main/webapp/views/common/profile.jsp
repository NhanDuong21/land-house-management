<%-- 
    Document   : profile
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<t:layout title="Profile" active="${active}" cssFile="${pageContext.request.contextPath}/assets/css/views/profile.css">
    <jsp:body>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <div class="container-fluid py-4 rhp-wrap">

            <div class="rhp-header">
                <h1 class="rhp-title">Profile</h1>
                <div class="rhp-subtitle">View and manage your account information</div>
            </div>

            <!-- PERSONAL INFO -->
            <div class="card rhp-card">
                <div class="card-body p-4 p-md-5">

                    <div class="rhp-card-title mb-4">Personal Information</div>

                    <!-- Success -->
                    <c:if test="${param.p == '1'}">
                        <div class="alert alert-success">
                            <i class="bi bi-check-circle me-2"></i>
                            Updated successfully.
                        </div>
                    </c:if>

                    <!-- Error -->
                    <c:if test="${param.perr == '1'}">
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <strong>Update failed:</strong>
                            <c:choose>
                                <c:when test="${param.pc == 'FORBIDDEN'}">You are not allowed to perform this action.</c:when>
                                <c:when test="${param.pc == 'TENANT_NOT_ACTIVE'}">Your account is not active.</c:when>
                                <c:when test="${param.pc == 'PHONE_REQUIRED'}">Phone number is required.</c:when>
                                <c:when test="${param.pc == 'PHONE_FORMAT'}">Invalid phone number format.</c:when>
                                <c:when test="${param.pc == 'PHONE_EXISTS'}">This phone number is already used.</c:when>
                                <c:when test="${param.pc == 'EMAIL_REQUIRED'}">Email is required.</c:when>
                                <c:when test="${param.pc == 'EMAIL_FORMAT'}">Invalid email format.</c:when>
                                <c:when test="${param.pc == 'EMAIL_EXISTS'}">This email is already used.</c:when>
                                <c:when test="${param.pc == 'FULLNAME_REQUIRED'}">Full name is required.</c:when>
                                <c:when test="${param.pc == 'FULLNAME_LENGTH'}">Full name is too long.</c:when>
                                <c:when test="${param.pc == 'IDENTITY_LENGTH'}">Citizen ID is too long.</c:when>
                                <c:when test="${param.pc == 'DOB_FORMAT'}">Invalid date format (yyyy-mm-dd).</c:when>
                                <c:when test="${param.pc == 'GENDER_FORMAT'}">Invalid gender value.</c:when>
                                <c:when test="${param.pc == 'UPDATE_FAILED'}">Failed to update. Please try again.</c:when>
                                <c:otherwise>Unexpected error occurred.</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- MANAGER FORM -->
                    <c:if test="${profileType == 'MANAGER'}">
                        <form id="managerContactForm" method="post" action="${pageContext.request.contextPath}/profile">
                            <input type="hidden" name="action" value="updateStaffContact"/>
                        </form>
                    </c:if>

                    <!-- ADMIN FORM -->
                    <c:if test="${profileType == 'ADMIN'}">
                        <form id="adminProfileForm" method="post" action="${pageContext.request.contextPath}/profile">
                            <input type="hidden" name="action" value="updateStaffProfile"/>
                        </form>
                    </c:if>

                    <div class="row g-4">

                        <!-- FULL NAME -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label"><i class="bi bi-person me-2"></i> Full Name</label>
                            <c:choose>
                                <c:when test="${profileType == 'ADMIN'}">
                                    <input name="full_name" form="adminProfileForm"
                                           class="form-control rhp-input"
                                           value="<c:out value='${empty fullName ? "" : fullName}'/>"
                                           placeholder="Enter full name">
                                </c:when>
                                <c:otherwise>
                                    <input class="form-control rhp-input" value="${fullName}" readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- PHONE -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label"><i class="bi bi-telephone me-2"></i> Phone Number</label>

                            <c:choose>
                                <c:when test="${profileType == 'TENANT'}">
                                    <form method="post" action="${pageContext.request.contextPath}/profile" class="d-flex gap-2">
                                        <input type="hidden" name="action" value="updatePhone"/>
                                        <input name="phone" class="form-control rhp-input"
                                               value="<c:out value='${empty phone ? "" : phone}'/>"
                                               placeholder="Enter phone number">
                                        <button class="btn btn-primary rhp-btn" type="submit">Save</button>
                                    </form>
                                </c:when>

                                <c:when test="${profileType == 'MANAGER'}">
                                    <input name="phone" form="managerContactForm"
                                           class="form-control rhp-input"
                                           value="<c:out value='${empty phone ? "" : phone}'/>"
                                           placeholder="Phone">
                                </c:when>

                                <c:when test="${profileType == 'ADMIN'}">
                                    <input name="phone" form="adminProfileForm"
                                           class="form-control rhp-input"
                                           value="<c:out value='${empty phone ? "" : phone}'/>"
                                           placeholder="Phone">
                                </c:when>

                                <c:otherwise>
                                    <input class="form-control rhp-input"
                                           value="<c:out value='${empty phone ? "-" : phone}'/>"
                                           readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- EMAIL -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label"><i class="bi bi-envelope me-2"></i> Email</label>

                            <c:choose>
                                <c:when test="${profileType == 'MANAGER'}">
                                    <input name="email" form="managerContactForm"
                                           class="form-control rhp-input"
                                           value="<c:out value='${empty email ? "" : email}'/>"
                                           placeholder="Email">
                                </c:when>

                                <c:when test="${profileType == 'ADMIN'}">
                                    <input name="email" form="adminProfileForm"
                                           class="form-control rhp-input"
                                           value="<c:out value='${empty email ? "" : email}'/>"
                                           placeholder="Email">
                                </c:when>

                                <c:otherwise>
                                    <input class="form-control rhp-input" value="${email}" readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- GENDER -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label"><i class="bi bi-gender-ambiguous me-2"></i> Gender</label>

                            <c:choose>
                                <c:when test="${profileType == 'ADMIN'}">
                                    <select name="gender" form="adminProfileForm" class="form-select rhp-input">
                                        <option value="" <c:if test="${empty gender}">selected</c:if>>-</option>
                                        <option value="1" <c:if test="${gender == 'Male'}">selected</c:if>>Male</option>
                                        <option value="0" <c:if test="${gender == 'Female'}">selected</c:if>>Female</option>
                                        </select>
                                </c:when>
                                <c:otherwise>
                                    <input class="form-control rhp-input"
                                           value="<c:out value='${empty gender ? "-" : gender}'/>"
                                           readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- DOB -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label"><i class="bi bi-calendar-event me-2"></i> Date of Birth</label>

                            <c:choose>
                                <c:when test="${profileType == 'ADMIN'}">
                                    <input name="dob" form="adminProfileForm"
                                           class="form-control rhp-input"
                                           value="<c:out value='${empty dob ? "" : dob}'/>"
                                           placeholder="yyyy-mm-dd">
                                </c:when>
                                <c:otherwise>
                                    <input class="form-control rhp-input"
                                           value="<c:out value='${empty dob ? "-" : dob}'/>"
                                           readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- IDENTITY -->
                        <div class="col-12">
                            <label class="rhp-label"><i class="bi bi-credit-card-2-front me-2"></i> Citizen ID</label>

                            <c:choose>
                                <c:when test="${profileType == 'ADMIN'}">
                                    <input name="identity" form="adminProfileForm"
                                           class="form-control rhp-input"
                                           value="<c:out value='${empty identity ? "" : identity}'/>"
                                           placeholder="Citizen ID">
                                </c:when>
                                <c:otherwise>
                                    <input class="form-control rhp-input"
                                           value="<c:out value='${empty identity ? "-" : identity}'/>"
                                           readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- ADDRESS -->
                        <c:if test="${showAddress}">
                            <div class="col-12">
                                <label class="rhp-label"><i class="bi bi-geo-alt me-2"></i> Address</label>
                                <input class="form-control rhp-input"
                                       value="<c:out value='${empty address ? "-" : address}'/>"
                                       readonly>
                            </div>
                        </c:if>

                        <!-- SAVE BUTTONS -->
                        <c:if test="${profileType == 'MANAGER'}">
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary rhp-btn" form="managerContactForm">
                                    Save
                                </button>
                            </div>
                        </c:if>

                        <c:if test="${profileType == 'ADMIN'}">
                            <div class="col-12">
                                <button type="submit" class="btn btn-primary rhp-btn" form="adminProfileForm">
                                    Save
                                </button>
                            </div>
                        </c:if>

                    </div>

                    <!-- NOTE -->
                    <c:if test="${profileType == 'TENANT' || profileType == 'MANAGER'}">
                        <div class="alert alert-primary rhp-note mt-4 mb-0">
                            <strong>Note:</strong>
                            Personal information cannot be changed directly. Please contact the manager if you need to update your information.
                        </div>
                    </c:if>

                </div>
            </div>

            <!-- CHANGE PASSWORD -->
            <div class="card rhp-card mt-4">
                <div class="card-body p-4 p-md-5">
                    <div class="rhp-card-title mb-4">
                        <i class="bi bi-lock me-2"></i> Change Password
                    </div>

                    <c:if test="${param.pwd == '1'}">
                        <div class="alert alert-success">
                            <i class="bi bi-check-circle me-2"></i>
                            Password changed successfully.
                        </div>
                    </c:if>

                    <c:if test="${param.err == '1'}">
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <strong>Change password failed:</strong>
                            <c:choose>
                                <c:when test="${param.code == 'PWD_REQUIRED'}">New password and confirm password are required.</c:when>
                                <c:when test="${param.code == 'PWD_LENGTH'}">Password must be between 6 and 64 characters.</c:when>
                                <c:when test="${param.code == 'PWD_CONFIRM_MISMATCH'}">Confirm password does not match.</c:when>
                                <c:when test="${param.code == 'OLD_REQUIRED'}">Current password is required.</c:when>
                                <c:when test="${param.code == 'OLD_INCORRECT'}">Current password is incorrect.</c:when>
                                <c:when test="${param.code == 'UPDATE_FAILED'}">Failed to update password. Please try again.</c:when>
                                <c:otherwise>Unexpected error occurred.</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/change-password" class="rhp-form">

                        <div class="mb-3">
                            <label class="form-label rhp-form-label">Current Password</label>
                            <div class="input-group">
                                <input type="password" name="old_password"
                                       class="form-control rhp-input pwd-field"
                                       placeholder="Enter current password">
                                <button class="btn btn-outline-secondary toggle-password" type="button">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label rhp-form-label">New Password</label>
                            <div class="input-group">
                                <input type="password" name="new_password"
                                       class="form-control rhp-input pwd-field"
                                       placeholder="Enter new password" required>
                                <button class="btn btn-outline-secondary toggle-password" type="button">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label rhp-form-label">Confirm New Password</label>
                            <div class="input-group">
                                <input type="password" name="confirm_password"
                                       class="form-control rhp-input pwd-field"
                                       placeholder="Confirm new password" required>
                                <button class="btn btn-outline-secondary toggle-password" type="button">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary rhp-btn">
                            <i class="bi bi-check2 me-2"></i>
                            Change Password
                        </button>
                    </form>

                </div>
            </div>

        </div>

        <script src="${pageContext.request.contextPath}/assets/js/vendor/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/pages/profile.js"></script>

    </jsp:body>
</t:layout>