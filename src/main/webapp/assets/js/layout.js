// layout.js
(function () {
  const sidebar = document.getElementById("rhSidebar");
  const btnToggle = document.getElementById("rhToggleSidebar");

  if (btnToggle && sidebar) {
    btnToggle.addEventListener("click", () => {
      sidebar.classList.toggle("open");
    });
  }

  // nút filter trên header chỉ là UI, trigger nút của home nếu có
  const headerFilter = document.getElementById("rhOpenFilter");
  if (headerFilter) {
    headerFilter.addEventListener("click", () => {
      const btn = document.getElementById("btnOpenFilter");
      if (btn) btn.click();
    });
  }
})();
