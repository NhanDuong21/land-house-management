<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<t:layout title="My Profile" active="${active}" cssFile="${pageContext.request.contextPath}/assets/css/views/profile.css">
    <jsp:body>

        <!-- Bootstrap CSS (page-level) -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base/bootstrap.min.css">

        <div class="rh-profile container-fluid py-3">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <h2 class="m-0">My Profile</h2>

                <!-- để sau làm edit -->
                <a class="btn btn-outline-secondary disabled" href="javascript:void(0)" aria-disabled="true">
                    Edit (coming soon)
                </a>
            </div>

            <div class="card rh-card mb-3">
                <div class="card-body d-flex align-items-center gap-3">
                    <div class="rh-avatar-wrap">
                        <img class="rh-avatar-img" src="${avatarUrl}" alt="Avatar">
                    </div>

                    <div class="flex-grow-1">
                        <div class="h5 mb-1">
                            <c:choose>
                                <c:when test="${empty fullName}">User</c:when>
                                <c:otherwise><c:out value="${fullName}"/></c:otherwise>
                            </c:choose>
                        </div>

                        <!-- ✅ role display: TENANT / MANAGER / ADMIN -->
                        <div class="text-muted small">
                            <c:out value="${roleDisplay}"/>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card rh-card">
                <div class="card-body">
                    <h5 class="card-title mb-3">Information</h5>

                    <div class="row gy-2">
                        <div class="col-12 col-md-4 text-muted">Full name</div>
                        <div class="col-12 col-md-8"><c:out value="${fullName}"/></div>

                        <div class="col-12 col-md-4 text-muted">Email</div>
                        <div class="col-12 col-md-8"><c:out value="${email}"/></div>

                        <div class="col-12 col-md-4 text-muted">Phone number</div>
                        <div class="col-12 col-md-8">
                            <c:choose>
                                <c:when test="${empty phone}">-</c:when>
                                <c:otherwise><c:out value="${phone}"/></c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-12 col-md-4 text-muted">Identity code</div>
                        <div class="col-12 col-md-8">
                            <c:choose>
                                <c:when test="${empty identity}">-</c:when>
                                <c:otherwise><c:out value="${identity}"/></c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-12 col-md-4 text-muted">Date of birth</div>
                        <div class="col-12 col-md-8">
                            <c:choose>
                                <c:when test="${empty dob}">-</c:when>
                                <c:otherwise><c:out value="${dob}"/></c:otherwise>
                            </c:choose>
                        </div>

                        <div class="col-12 col-md-4 text-muted">Gender</div>
                        <div class="col-12 col-md-8">
                            <c:choose>
                                <c:when test="${empty gender}">-</c:when>
                                <c:otherwise><c:out value="${gender}"/></c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${showAddress}">
                            <div class="col-12 col-md-4 text-muted">Address</div>
                            <div class="col-12 col-md-8">
                                <c:choose>
                                    <c:when test="${empty address}">-</c:when>
                                    <c:otherwise><c:out value="${address}"/></c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS bundle (includes Popper) -->
        <script src="${pageContext.request.contextPath}/assets/js/vendor/bootstrap.bundle.min.js"></script>

        <!-- Page JS -->
        <script src="${pageContext.request.contextPath}/assets/js/pages/profile.js"></script>

    </jsp:body>
</t:layout>