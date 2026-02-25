<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<t:layout title="Profile" active="${active}" cssFile="${pageContext.request.contextPath}/assets/css/views/profile.css">
    <jsp:body>

        <!-- Bootstrap (page-level) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <div class="container-fluid py-4 rhp-wrap">

            <!-- Page title -->
            <div class="rhp-header">
                <h1 class="rhp-title">Profile</h1>
                <div class="rhp-subtitle">View and manage your account information</div>
            </div>

            <!-- Personal information card -->
            <div class="card rhp-card">
                <div class="card-body p-4 p-md-5">

                    <div class="d-flex align-items-center justify-content-between mb-4">
                        <div class="rhp-card-title">Personal Information</div>
                    </div>

                    <!-- Phone update result (separate params from change-password) -->
                    <c:if test="${param.p == '1'}">
                        <div class="alert alert-success">
                            <i class="bi bi-check-circle me-2"></i>
                            Phone number updated successfully.
                        </div>
                    </c:if>

                    <c:if test="${param.perr == '1'}">
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <strong>Update phone failed:</strong>
                            <c:choose>
                                <c:when test="${param.pc == 'TENANT_NOT_ACTIVE'}">
                                    Your account is not active.
                                </c:when>
                                <c:when test="${param.pc == 'PHONE_REQUIRED'}">
                                    Phone number is required.
                                </c:when>
                                <c:when test="${param.pc == 'PHONE_FORMAT'}">
                                    Invalid phone number format.
                                </c:when>
                                <c:when test="${param.pc == 'PHONE_EXISTS'}">
                                    This phone number is already used.
                                </c:when>
                                <c:when test="${param.pc == 'UPDATE_FAILED'}">
                                    Failed to update. Please try again.
                                </c:when>
                                <c:otherwise>
                                    Unexpected error occurred.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <div class="row g-4">

                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-person me-2"></i> Full Name
                            </label>
                            <input class="form-control rhp-input" value="${fullName}" readonly>
                        </div>

                        <!-- PHONE: tenant can update (service will block if not ACTIVE) -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-telephone me-2"></i> Phone Number
                            </label>

                            <c:choose>
                                <c:when test="${profileType == 'TENANT'}">
                                    <form method="post" action="${pageContext.request.contextPath}/profile" class="d-flex gap-2">
                                        <input type="hidden" name="action" value="updatePhone"/>
                                        <input name="phone" class="form-control rhp-input"
                                               value="<c:out value='${empty phone ? "" : phone}'/>"
                                               placeholder="Enter phone number">
                                        <button type="submit" class="btn btn-primary rhp-btn">
                                            Save
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <input class="form-control rhp-input"
                                           value="<c:out value='${empty phone ? "-" : phone}'/>"
                                           readonly>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-envelope me-2"></i> Email
                            </label>
                            <input class="form-control rhp-input" value="${email}" readonly>
                        </div>

                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-gender-ambiguous me-2"></i> Gender
                            </label>
                            <input class="form-control rhp-input"
                                   value="<c:out value='${empty gender ? "-" : gender}'/>"
                                   readonly>
                        </div>

                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-calendar-event me-2"></i> Date of Birth
                            </label>
                            <input class="form-control rhp-input"
                                   value="<c:out value='${empty dob ? "-" : dob}'/>"
                                   readonly>
                        </div>

                        <div class="col-12">
                            <label class="rhp-label">
                                <i class="bi bi-credit-card-2-front me-2"></i> Citizen ID
                            </label>
                            <input class="form-control rhp-input"
                                   value="<c:out value='${empty identity ? "-" : identity}'/>"
                                   readonly>
                        </div>

                        <c:if test="${showAddress}">
                            <div class="col-12">
                                <label class="rhp-label">
                                    <i class="bi bi-geo-alt me-2"></i> Address
                                </label>
                                <input class="form-control rhp-input"
                                       value="<c:out value='${empty address ? "-" : address}'/>"
                                       readonly>
                            </div>
                        </c:if>

                    </div>

                    <div class="alert alert-primary rhp-note mt-4 mb-0">
                        <strong>Note:</strong>
                        Personal information cannot be changed directly. Please contact the manager if you need to update your information.
                    </div>
                </div>
            </div>

            <!-- Change password -->
            <div class="card rhp-card mt-4">
                <div class="card-body p-4 p-md-5">
                    <div class="rhp-card-title mb-4">
                        <i class="bi bi-lock me-2"></i> Change Password
                    </div>

                    <!-- Success -->
                    <c:if test="${param.pwd == '1'}">
                        <div class="alert alert-success">
                            <i class="bi bi-check-circle me-2"></i>
                            Password changed successfully.
                        </div>
                    </c:if>

                    <!-- Error mapping (password only) -->
                    <c:if test="${param.err == '1'}">
                        <div class="alert alert-danger">
                            <i class="bi bi-exclamation-triangle me-2"></i>
                            <strong>Change password failed:</strong>
                            <c:choose>
                                <c:when test="${param.code == 'PWD_REQUIRED'}">
                                    New password and confirm password are required.
                                </c:when>
                                <c:when test="${param.code == 'PWD_LENGTH'}">
                                    Password must be between 6 and 64 characters.
                                </c:when>
                                <c:when test="${param.code == 'PWD_CONFIRM_MISMATCH'}">
                                    Confirm password does not match.
                                </c:when>
                                <c:when test="${param.code == 'OLD_REQUIRED'}">
                                    Current password is required.
                                </c:when>
                                <c:when test="${param.code == 'OLD_INCORRECT'}">
                                    Current password is incorrect.
                                </c:when>
                                <c:when test="${param.code == 'UPDATE_FAILED'}">
                                    Failed to update password. Please try again.
                                </c:when>
                                <c:otherwise>
                                    Unexpected error occurred.
                                </c:otherwise>
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