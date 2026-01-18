document.addEventListener("DOMContentLoaded", function() {
    const toggleBtn = document.getElementById('toggleBtn');
    const sidebar = document.getElementById('mySidebar');

    // Kiểm tra xem 2 phần tử này có tồn tại không để tránh lỗi
    if (toggleBtn && sidebar) {
        toggleBtn.addEventListener('click', function() {
            // Thêm hoặc xóa class 'hidden'
            sidebar.classList.toggle('hidden');
        });
    }
});