<%-- 
    Document   : setPassword
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<layout:layout title="Set Password" active="">

    <div class="container mt-4" style="max-width:520px;">

        <h3 style="font-weight:800;">Set Password</h3>
        <div style="color:#64748b;font-weight:650;margin-top:6px;">
            Lần đầu đăng nhập, vui lòng đặt mật khẩu để dùng cho các lần sau.
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger mt-3">${error}</div>
        </c:if>

        <form class="mt-3"
              method="post"
              action="${pageContext.request.contextPath}/tenant/set-password">

            <div class="mb-3">
                <label class="form-label" style="font-weight:700;">New password</label>
                <input type="password" name="password" class="form-control" required />
            </div>

            <div class="mb-3">
                <label class="form-label" style="font-weight:700;">Confirm password</label>
                <input type="password" name="confirm" class="form-control" required />
            </div>

            <button class="btn btn-dark w-100" type="submit">Save Password</button>
        </form>

    </div>

</layout:layout>
