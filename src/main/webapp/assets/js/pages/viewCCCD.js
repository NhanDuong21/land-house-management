document.addEventListener("DOMContentLoaded", function () {
  const modalElement = document.getElementById("tcdImageModal");
  if (!modalElement || typeof bootstrap === "undefined") {
    return;
  }

  const imageModal = new bootstrap.Modal(modalElement);
  const previewImage = document.getElementById("tcdPreviewImage");
  const previewFallback = document.getElementById("tcdPreviewFallback");
  const imageLoading = document.getElementById("tcdImageLoading");
  const modalTitle = document.getElementById("tcdImageModalLabel");
  const openInNewTabLink = document.getElementById("tcdOpenImageNewTab");
  const triggerButtons = document.querySelectorAll(".js-image-popup");

  let currentImageUrl = "";
  let isOpening = false;

  function resetModalState() {
    previewImage.classList.add("d-none");
    previewFallback.classList.add("d-none");
    imageLoading.classList.remove("d-none");

    previewImage.removeAttribute("src");
    previewImage.setAttribute("alt", "Preview image");
    previewImage.style.opacity = "0";
    previewImage.style.transform = "scale(0.98)";

    openInNewTabLink.setAttribute("href", "#");
    modalTitle.textContent = "Image Preview";
  }

  function showLoadedImage(imageUrl) {
    previewImage.src = imageUrl;
    imageLoading.classList.add("d-none");
    previewFallback.classList.add("d-none");
    previewImage.classList.remove("d-none");

    requestAnimationFrame(function () {
      previewImage.style.opacity = "1";
      previewImage.style.transform = "scale(1)";
    });
  }

  function showFallback() {
    imageLoading.classList.add("d-none");
    previewImage.classList.add("d-none");
    previewFallback.classList.remove("d-none");
  }

  function showImage(imageUrl, imageTitle) {
    if (!imageUrl || isOpening) return;

    isOpening = true;
    currentImageUrl = imageUrl;

    resetModalState();

    if (imageTitle && imageTitle.trim() !== "") {
      modalTitle.textContent = imageTitle;
      previewImage.alt = imageTitle;
    }

    openInNewTabLink.href = imageUrl;
    imageModal.show();

    const tempImage = new Image();

    tempImage.onload = function () {
      if (currentImageUrl !== imageUrl) return;
      showLoadedImage(imageUrl);
      isOpening = false;
    };

    tempImage.onerror = function () {
      if (currentImageUrl !== imageUrl) return;
      showFallback();
      isOpening = false;
    };

    tempImage.src = imageUrl;
  }

  triggerButtons.forEach(function (button) {
    button.addEventListener("click", function () {
      const imageUrl = button.getAttribute("data-image-url");
      const imageTitle = button.getAttribute("data-image-title");

      if (!imageUrl) return;
      showImage(imageUrl, imageTitle);
    });
  });

  modalElement.addEventListener("hidden.bs.modal", function () {
    currentImageUrl = "";
    isOpening = false;
    previewImage.removeAttribute("src");
    previewImage.classList.add("d-none");
    previewFallback.classList.add("d-none");
    imageLoading.classList.add("d-none");
    previewImage.style.opacity = "";
    previewImage.style.transform = "";
  });
});
