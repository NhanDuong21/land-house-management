(function () {
  // ===== REVEAL ANIMATION =====
  function initReveal() {
    const revealItems = document.querySelectorAll(".em-reveal");

    revealItems.forEach((item, index) => {
      setTimeout(() => {
        item.classList.add("is-visible");
      }, 90 * index);
    });
  }

  // ===== IMAGE PREVIEW MODAL =====
  function initImageModal() {
    const modal = document.getElementById("imageModal");
    const modalImg = document.getElementById("modalImage");
    const closeBtn = document.getElementById("closeImageModal");
    const previewImages = document.querySelectorAll(".preview-image");

    if (!modal || !modalImg || !closeBtn || previewImages.length === 0) return;

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

  document.addEventListener("DOMContentLoaded", function () {
    initReveal();
    initImageModal();
  });
})();