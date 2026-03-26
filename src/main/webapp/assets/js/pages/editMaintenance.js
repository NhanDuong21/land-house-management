(function () {
  const form = document.getElementById("emForm");
  const statusSelect = document.getElementById("emStatus");
  const completedAtInput = document.getElementById("emCompletedAt");
  const submitBtn = document.getElementById("emSubmitBtn");

  function isLockedStatus(value) {
    return value === "DONE" || value === "CANCELLED";
  }

  function applyStatusVisual() {
    if (!statusSelect) return;

    const value = statusSelect.value;

    statusSelect.classList.remove(
      "status-pending",
      "status-progress",
      "status-done",
      "status-cancelled"
    );

    if (value === "PENDING") {
      statusSelect.classList.add("status-pending");
    } else if (value === "IN_PROGRESS") {
      statusSelect.classList.add("status-progress");
    } else if (value === "DONE") {
      statusSelect.classList.add("status-done");
    } else if (value === "CANCELLED") {
      statusSelect.classList.add("status-cancelled");
    }

    if (completedAtInput) {
      if (value === "DONE") {
        completedAtInput.style.background = "#ecfdf3";
        completedAtInput.style.borderColor = "#86efac";
        completedAtInput.style.color = "#166534";
      } else if (value === "CANCELLED") {
        completedAtInput.style.background = "#fef2f2";
        completedAtInput.style.borderColor = "#fca5a5";
        completedAtInput.style.color = "#991b1b";
      } else {
        completedAtInput.style.background = "#f9fafb";
        completedAtInput.style.borderColor = "#e5e7eb";
        completedAtInput.style.color = "#374151";
      }
    }
  }

  function initReveal() {
    const revealItems = document.querySelectorAll(".em-reveal");

    revealItems.forEach((item, index) => {
      setTimeout(() => {
        item.classList.add("is-visible");
      }, 90 * index);
    });
  }

  if (statusSelect) {
    statusSelect.addEventListener("change", applyStatusVisual);
    applyStatusVisual();
  }

  if (form) {
    form.addEventListener("submit", function (e) {
      const status = statusSelect ? statusSelect.value : "";

      if (statusSelect && statusSelect.disabled && isLockedStatus(status)) {
        e.preventDefault();
        window.alert(
          "Yêu cầu này đã ở trạng thái " +
            status +
            " nên không thể cập nhật nữa."
        );
        return;
      }

      const ok = window.confirm(
        "Are you sure you want to update this request status to " + status + "?"
      );

      if (!ok) {
        e.preventDefault();
        return;
      }

      if (submitBtn) {
        submitBtn.disabled = true;
        submitBtn.innerHTML =
          '<i class="bi bi-hourglass-split"></i> Updating...';
      }
    });
  }

  const modal = document.getElementById("imageModal");
  const modalImg = document.getElementById("modalImage");
  const closeBtn = document.getElementById("closeImageModal");
  const previewImages = document.querySelectorAll(".preview-image");

  if (modal && modalImg && closeBtn && previewImages.length > 0) {
    previewImages.forEach(function (img) {
      img.addEventListener("click", function () {
        modalImg.src = this.src;
        modal.classList.add("show");
      });
    });

    closeBtn.addEventListener("click", function () {
      modal.classList.remove("show");
      modalImg.src = "";
    });

    modal.addEventListener("click", function (e) {
      if (e.target === modal) {
        modal.classList.remove("show");
        modalImg.src = "";
      }
    });

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") {
        modal.classList.remove("show");
        modalImg.src = "";
      }
    });
  }

  initReveal();
})();