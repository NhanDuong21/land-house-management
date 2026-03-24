(function () {
  function initRoomDetail(root) {
    if (!root) return;

    const mainImg = root.querySelector("#mainImg");
    const thumbs = Array.from(root.querySelectorAll(".rd-thumb"));
    const prevBtn = root.querySelector("#rdPrevBtn");
    const nextBtn = root.querySelector("#rdNextBtn");
    const zoomBtn = root.querySelector("#rdZoomBtn");
    const copyBtn = root.querySelector("#rdCopyRoomBtn");
    const lightbox = root.querySelector("#rdLightbox");
    const lightboxImg = root.querySelector("#rdLightboxImg");
    const lightboxClose = root.querySelector("#rdLightboxClose");
    const lightboxBackdrop = root.querySelector(".rd-lightbox__backdrop");
    const counter = root.querySelector("#rdImageCounter");

    let currentIndex = 0;

    function updateCounter() {
      if (counter && thumbs.length > 0) {
        counter.textContent = currentIndex + 1 + " / " + thumbs.length;
      }
    }

    function setActiveThumb(index) {
      thumbs.forEach(function (thumb, i) {
        thumb.classList.toggle("is-active", i === index);
      });
    }

    function showImage(index) {
      if (!mainImg || thumbs.length === 0) return;

      const safeIndex = (index + thumbs.length) % thumbs.length;
      const selectedThumb = thumbs[safeIndex];

      mainImg.classList.add("is-switching");

      const tempImg = new Image();
      tempImg.onload = function () {
        mainImg.src = selectedThumb.src;
        currentIndex = safeIndex;
        setActiveThumb(currentIndex);
        updateCounter();

        setTimeout(function () {
          mainImg.classList.remove("is-switching");
        }, 80);
      };
      tempImg.src = selectedThumb.src;
    }

    if (mainImg && thumbs.length > 0) {
      setActiveThumb(0);
      updateCounter();

      thumbs.forEach(function (thumb, index) {
        thumb.addEventListener("click", function () {
          showImage(index);
        });
      });
    }

    if (prevBtn) {
      prevBtn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        showImage(currentIndex - 1);
      });
    }

    if (nextBtn) {
      nextBtn.addEventListener("click", function (e) {
        e.preventDefault();
        e.stopPropagation();
        showImage(currentIndex + 1);
      });
    }

    function openLightbox() {
      if (!lightbox || !lightboxImg || !mainImg) return;
      lightbox.classList.add("show");
      lightbox.setAttribute("aria-hidden", "false");
      lightboxImg.src = mainImg.src;
      document.body.style.overflow = "hidden";
    }

    function closeLightbox() {
      if (!lightbox) return;
      lightbox.classList.remove("show");
      lightbox.setAttribute("aria-hidden", "true");
      document.body.style.overflow = "";
    }

    if (zoomBtn) {
      zoomBtn.addEventListener("click", openLightbox);
    }

    if (mainImg) {
      mainImg.addEventListener("dblclick", openLightbox);
    }

    if (lightboxClose) {
      lightboxClose.addEventListener("click", closeLightbox);
    }

    if (lightboxBackdrop) {
      lightboxBackdrop.addEventListener("click", closeLightbox);
    }

    if (copyBtn) {
      copyBtn.addEventListener("click", async function () {
        const roomNumber = copyBtn.dataset.roomNumber || "";
        const original = copyBtn.innerHTML;

        try {
          await navigator.clipboard.writeText(roomNumber);
          copyBtn.innerHTML = '<i class="bi bi-check2"></i> Copied';
          setTimeout(function () {
            copyBtn.innerHTML = original;
          }, 1400);
        } catch (err) {
          console.error("Copy failed:", err);
        }
      });
    }

    const revealItems = root.querySelectorAll(".rd-reveal");
    revealItems.forEach(function (item, index) {
      item.style.opacity = "0";
      item.style.transform = "translateY(16px)";
      item.style.transition = "opacity 0.45s ease, transform 0.45s ease";
      item.style.transitionDelay = Math.min(index * 0.05, 0.2) + "s";
    });

    const observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          entry.target.style.opacity = "1";
          entry.target.style.transform = "translateY(0)";
          observer.unobserve(entry.target);
        });
      },
      {
        threshold: 0.08,
      },
    );

    revealItems.forEach(function (item) {
      observer.observe(item);
    });

    function keyHandler(e) {
      const detailModal = document.querySelector("#roomDetailModal");
      if (!detailModal || !detailModal.classList.contains("show")) return;

      if (e.key === "Escape") {
        if (lightbox && lightbox.classList.contains("show")) {
          closeLightbox();
        }
        return;
      }

      if (!thumbs.length) return;

      if (e.key === "ArrowLeft") {
        showImage(currentIndex - 1);
      } else if (e.key === "ArrowRight") {
        showImage(currentIndex + 1);
      }
    }

    document.addEventListener("keydown", keyHandler);

    root.__roomDetailCleanup = function () {
      document.removeEventListener("keydown", keyHandler);
    };
  }

  window.initRoomDetail = initRoomDetail;
})();
