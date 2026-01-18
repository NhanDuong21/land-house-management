function togglePass(inputId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById('icon-' + inputId);
    const ctx = "${pageContext.request.contextPath}"; // Lấy context path cho JS

    if (input.type === "password") {
        input.type = "text";
        // Đổi sang hình con mắt mở
        icon.src = ctx + "/assets/images/eye-open.png";
    } else {
        input.type = "password";
        // Đổi về hình con mắt đóng
        icon.src = ctx + "/assets/images/eye-close.png";
    }
}