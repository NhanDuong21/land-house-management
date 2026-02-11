<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="layout" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<layout:layout title="Contract Detail" active="tenant_contract">

    <div class="container mt-4" style="max-width: 1100px;">

        <a href="${pageContext.request.contextPath}/tenant/contract"
           class="btn btn-outline-dark mb-3">
            ← Back
        </a>

        <c:set var="c" value="${contract}"/>

        <div class="card" style="border-radius:16px;">
            <div class="card-body" style="padding:18px;">

                <div class="d-flex justify-content-between align-items-center">
                    <div style="font-weight:900;font-size:20px;">
                        Contract #<fmt:formatNumber value="${c.contractId}" pattern="000000"/>
                    </div>

                    <c:choose>
                        <c:when test="${c.status eq 'ACTIVE'}">
                            <span class="badge bg-success" style="border-radius:999px;padding:8px 12px;">
                                ACTIVE
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-warning text-dark" style="border-radius:999px;padding:8px 12px;">
                                ${c.status}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <hr/>

                <div class="row">
                    <div class="col-md-6">
                        <div><b>Room ID:</b> ${c.roomId}</div>
                        <div class="mt-2"><b>Start Date:</b> ${c.startDate}</div>
                        <div class="mt-2"><b>End Date:</b>
                            <c:choose>
                                <c:when test="${empty c.endDate}">-</c:when>
                                <c:otherwise>${c.endDate}</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div><b>Monthly Rent:</b>
                            <fmt:formatNumber value="${c.monthlyRent}" type="number" groupingUsed="true"/> đ
                        </div>
                        <div class="mt-2"><b>Deposit:</b>
                            <fmt:formatNumber value="${c.deposit}" type="number" groupingUsed="true"/> đ
                        </div>
                    </div>
                </div>

                <c:if test="${param.sent == '1'}">
                    <div class="alert alert-success mt-3">
                        Đã gửi xác nhận chuyển khoản. Vui lòng chờ manager duyệt.
                    </div>
                </c:if>

                <c:if test="${param.already == '1'}">
                    <div class="alert alert-warning mt-3">
                        Bạn đã xác nhận chuyển khoản trước đó rồi.
                    </div>
                </c:if>

                <c:if test="${param.err == '1'}">
                    <div class="alert alert-danger mt-3">
                        Lỗi khi xác nhận chuyển khoản. Thử lại sau.
                    </div>
                </c:if>

                <c:if test="${c.status eq 'PENDING'}">
                    <hr/>
                    <div class="row mt-3">
                        <div class="col-md-6">
                            <div style="font-weight:900;">Payment QR</div>
                            <div style="color:#64748b;font-weight:650;margin-top:6px;">
                                Quét QR để chuyển khoản tiền cọc (deposit).
                            </div>

                            <c:choose>
                                <c:when test="${not empty c.paymentQrData}">
                                    <div class="mt-3">
                                        <img src="${pageContext.request.contextPath}${c.paymentQrData}"
                                             alt="Payment QR"
                                             style="width:260px;height:260px;object-fit:contain;border-radius:14px;border:1px solid rgba(0,0,0,0.1);padding:10px;background:#fff;">
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-secondary mt-3">
                                        Contract chưa có QR. Vui lòng liên hệ manager.
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${not empty latestPayment}">
                                <div class="mt-3" style="font-weight:800;">
                                    Latest transfer status:
                                    <span class="badge bg-light text-dark" style="border:1px solid rgba(0,0,0,0.15);">
                                        ${latestPayment.status}
                                    </span>
                                </div>
                            </c:if>
                        </div>

                        <div class="col-md-6">
                            <div style="font-weight:900;">Confirm transfer</div>
                            <div style="color:#64748b;font-weight:650;margin-top:6px;">
                                Sau khi chuyển khoản, bấm xác nhận để manager kiểm tra và duyệt hợp đồng.
                            </div>

                            <form class="mt-3"
                                  method="post"
                                  action="${pageContext.request.contextPath}/tenant/contract/confirm-transfer">

                                <input type="hidden" name="contractId" value="${c.contractId}"/>

                                <button class="btn btn-dark w-100"
                                        type="submit"
                                        onclick="return confirm('Bạn chắc chắn đã chuyển khoản tiền cọc chưa?');">
                                    Tôi đã chuyển khoản
                                </button>

                                <div class="mt-2" style="color:#64748b;font-weight:650;font-size:13px;">
                                    Lưu ý: bấm nhiều lần sẽ không tạo thêm payment mới.
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>

            </div>
        </div>

    </div>

</layout:layout>
