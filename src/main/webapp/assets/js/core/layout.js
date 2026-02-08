// layout.js
(function () {
  const sidebar = document.getElementById("rhSidebar");
  const btnToggle = document.getElementById("rhToggleSidebar");
  const layout = document.querySelector(".rh-layout");

  if (btnToggle && sidebar && layout) {
    const isMobile = () => window.matchMedia("(max-width: 992px)").matches;

    btnToggle.addEventListener("click", () => {
      if (isMobile()) {
        // 📱 Mobile: off-canvas sidebar
        sidebar.classList.toggle("open");
      } else {
        // 🖥 Desktop: ẩn/hiện sidebar
        layout.classList.toggle("sidebar-hidden");
      }
    });

    // Khi resize từ mobile → desktop thì reset trạng thái mobile
    window.addEventListener("resize", () => {
      if (!isMobile()) {
        sidebar.classList.remove("open");
      }
    });
  }

  // ===== Header filter button (chỉ trigger UI của Home nếu có) =====
  const headerFilter = document.getElementById("rhOpenFilter");
  if (headerFilter) {
    headerFilter.addEventListener("click", () => {
      const btn = document.getElementById("btnOpenFilter");
      if (btn) btn.click();
    });
  }
})();

// ===== Confirm Logout =====
document.addEventListener("DOMContentLoaded", function () {
  const logoutBtn = document.querySelector(".js-logout");
  if (!logoutBtn) return;

  logoutBtn.addEventListener("click", function (e) {
    e.preventDefault();

    const ok = confirm("Are you sure you want to log out?");
    if (ok) {
      window.location.href = this.href;
    }
  });
});
