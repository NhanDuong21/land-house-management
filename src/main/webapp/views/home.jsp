<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Home - RentHouse</title>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body class="bg-light">

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="<%=request.getContextPath()%>/home">RentHouse</a>
        <div class="d-flex gap-2">
            <a class="btn btn-outline-light" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
        </div>
    </div>
</nav>

<section class="py-5">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-6">
                <h1 class="fw-bold">Chào mừng đến với RentHouse</h1>
                <p class="text-muted mb-4">
                    Guest có thể xem thông tin cơ bản. Để sử dụng hệ thống, vui lòng đăng nhập.
                </p>
                <a class="btn btn-primary btn-lg" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
            </div>

            <div class="col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">Chức năng chính</h5>
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">Quản lý phòng & hợp đồng</li>
                            <li class="list-group-item">Hóa đơn & thanh toán</li>
                            <li class="list-group-item">Yêu cầu sửa chữa (Maintenance)</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script src="<%=request.getContextPath()%>/assets/js/bootstrap.bundle.min.js"></script>
<script src="<%=request.getContextPath()%>/assets/js/main.js"></script>
</body>
</html>
