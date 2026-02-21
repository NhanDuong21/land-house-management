<%-- 
    Document   : setPassword
    Author     : Duong Thien Nhan - CE190741
--%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<layout:layout title="Set Password" active=""
               cssFile="${pageContext.request.contextPath}/assets/css/views/tenantSetPassword.css">

    <div class="container mt-4 sp-wrap" style="max-width:520px;">

        <div class="sp-card">
            <div class="sp-head">
                <h3 class="sp-title">Set Password</h3>
                <div class="sp-sub">
                    Lần đầu đăng nhập, vui lòng đặt mật khẩu để dùng cho các lần sau.
                </div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger sp-alert">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <form class="sp-form"
                  method="post"
                  action="${pageContext.request.contextPath}/tenant/set-password">

                <!-- New password -->
                <div class="mb-3">
                    <label class="form-label sp-label">New password</label>

                    <div class="sp-pw">
                        <input id="spPassword" type="password" name="password"
                               class="form-control sp-input" required />
                        <button type="button"
                                class="btn btn-outline-secondary btn-sm sp-pw-toggle"
                                data-target="spPassword">
                            Show
                        </button>
                    </div>
                </div>

                <!-- Confirm password -->
                <div class="mb-3">
                    <label class="form-label sp-label">Confirm password</label>

                    <div class="sp-pw">
                        <input id="spConfirm" type="password" name="confirm"
                               class="form-control sp-input" required />
                        <button type="button"
                                class="btn btn-outline-secondary btn-sm sp-pw-toggle"
                                data-target="spConfirm">
                            Show
                        </button>
                    </div>
                </div>

                <button class="btn btn-dark w-100 sp-btn" type="submit">Save Password</button>

                <div class="sp-hint">
                    Mẹo: dùng ít nhất 8 ký tự, có chữ hoa, chữ thường và số.
                </div>
            </form>
        </div>

    </div>

    <script>
        // Simple show/hide, no icon, no dependency
        (function () {
            var btns = document.querySelectorAll(".sp-pw-toggle");
            btns.forEach(function (btn) {
                btn.addEventListener("click", function () {
                    var id = btn.getAttribute("data-target");
                    var input = document.getElementById(id);
                    if (!input) return;

                    var isHidden = input.type === "password";
                    input.type = isHidden ? "text" : "password";
                    btn.textContent = isHidden ? "Hide" : "Show";
                });
            });
        })();
    </script>

</layout:layout>