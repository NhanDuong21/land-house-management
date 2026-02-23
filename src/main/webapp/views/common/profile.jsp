<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<t:layout title="Profile" active="${active}" cssFile="${pageContext.request.contextPath}/assets/css/views/profile.css">
    <jsp:body>

        <!-- Bootstrap (page-level) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/bootstrap.min.css">
        <!-- Bootstrap Icons (optional) -->
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

                        <!-- future edit -->
                        <a class="btn btn-primary rhp-btn disabled" href="javascript:void(0)" aria-disabled="true">
                            <i class="bi bi-pencil-square me-2"></i>
                            Edit Profile
                        </a>
                    </div>

                    <div class="row g-4">

                        <!-- Full name -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-person me-2"></i> Full Name
                            </label>
                            <input class="form-control rhp-input" value="${fullName}" readonly>
                        </div>

                        <!-- Phone -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-telephone me-2"></i> Phone Number
                            </label>
                            <input class="form-control rhp-input"
                                   value="<c:out value='${empty phone ? "-" : phone}'/>"
                                   readonly>
                        </div>

                        <!-- Email -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-envelope me-2"></i> Email
                            </label>
                            <input class="form-control rhp-input" value="${email}" readonly>
                        </div>

                        <!-- Gender -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-gender-ambiguous me-2"></i> Gender
                            </label>
                            <input class="form-control rhp-input"
                                   value="<c:out value='${empty gender ? "-" : gender}'/>"
                                   readonly>
                        </div>

                        <!-- DOB -->
                        <div class="col-12 col-md-6">
                            <label class="rhp-label">
                                <i class="bi bi-calendar-event me-2"></i> Date of Birth
                            </label>
                            <input class="form-control rhp-input"
                                   value="<c:out value='${empty dob ? "-" : dob}'/>"
                                   readonly>
                        </div>

                        <!-- Citizen ID -->
                        <div class="col-12">
                            <label class="rhp-label">
                                <i class="bi bi-credit-card-2-front me-2"></i> Citizen ID
                            </label>
                            <input class="form-control rhp-input"
                                   value="<c:out value='${empty identity ? "-" : identity}'/>"
                                   readonly>
                        </div>

                        <!-- Address (tenant only) -->
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

                    <c:if test="${not empty pwdMessage}">
                        <div class="alert ${pwdSuccess ? 'alert-success' : 'alert-danger'}">
                            <c:out value="${pwdMessage}"/>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/profile" class="rhp-form">
                        <input type="hidden" name="action" value="changePassword"/>

                        <div class="mb-3">
                            <label class="form-label rhp-form-label">Current Password</label>
                            <div class="input-group">
                                <input type="password" name="currentPassword"
                                       class="form-control rhp-input pwd-field"
                                       placeholder="Enter current password" required>
                                <button class="btn btn-outline-secondary toggle-password" type="button">
                                    <i class="bi bi-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label rhp-form-label">New Password</label>
                            <div class="input-group">
                                <input type="password" name="newPassword"
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
                                <input type="password" name="confirmPassword"
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