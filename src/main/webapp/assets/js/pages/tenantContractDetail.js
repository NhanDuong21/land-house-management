document.addEventListener("DOMContentLoaded", function () {
  initImagePreviewModal();
  initRevealAnimations();
  initStaggerDelays();
  initRippleButtons();
  initFieldFocusEffects();
  initParallaxOrbs();
});

function initImagePreviewModal() {
  const imagePreviewModal = document.getElementById("imagePreviewModal");
  const previewImg = document.getElementById("imagePreviewTag");
  const previewTitle = document.getElementById("imagePreviewTitle");

  if (!imagePreviewModal || !previewImg || !previewTitle) return;

  imagePreviewModal.addEventListener("show.bs.modal", function (event) {
    const triggerButton = event.relatedTarget;
    if (!triggerButton) return;

    const imgSrc = triggerButton.getAttribute("data-img-src");
    const imgTitle = triggerButton.getAttribute("data-img-title");

    previewImg.classList.remove("is-loaded");
    previewImg.src = imgSrc || "";
    previewImg.alt = imgTitle || "Image Preview";
    previewTitle.textContent = imgTitle || "Image Preview";
  });

  previewImg.addEventListener("load", function () {
    previewImg.classList.add("is-loaded");
  });

  imagePreviewModal.addEventListener("hidden.bs.modal", function () {
    previewImg.classList.remove("is-loaded");
    previewImg.src = "";
    previewImg.alt = "Preview";
    previewTitle.textContent = "Image Preview";
  });
}

function initRevealAnimations() {
  const revealEls = document.querySelectorAll(".tcd-reveal");
  if (!revealEls.length) return;

  if (!("IntersectionObserver" in window)) {
    revealEls.forEach((el) => el.classList.add("is-visible"));
    return;
  }

  const observer = new IntersectionObserver(
    function (entries, obs) {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          obs.unobserve(entry.target);
        }
      });
    },
    {
      threshold: 0.12,
      rootMargin: "0px 0px -40px 0px",
    },
  );

  revealEls.forEach((el) => observer.observe(el));
}

function initStaggerDelays() {
  const staggerGroups = document.querySelectorAll(".tcd-stagger");

  staggerGroups.forEach((group) => {
    const children = Array.from(group.children).filter((child) => {
      return child.classList && child.classList.contains("tcd-reveal");
    });

    children.forEach((child, index) => {
      child.style.transitionDelay = `${Math.min(index * 70, 420)}ms`;
    });
  });
}

function initRippleButtons() {
  const buttons = document.querySelectorAll(".tcd-btn-ripple");

  buttons.forEach((button) => {
    button.addEventListener("click", function (e) {
      const rect = button.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      ripple.className = "tcd-ripple";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;

      button.appendChild(ripple);

      ripple.addEventListener("animationend", () => {
        ripple.remove();
      });
    });
  });
}

function initFieldFocusEffects() {
  const fields = document.querySelectorAll(".tcd-field");

  fields.forEach((field) => {
    const input = field.querySelector("input, select, textarea");
    if (!input) return;

    input.addEventListener("focus", () => {
      field.classList.add("is-focused");
    });

    input.addEventListener("blur", () => {
      field.classList.remove("is-focused");
    });
  });
}

function initParallaxOrbs() {
  const orb1 = document.querySelector(".tcd-bg-orb-1");
  const orb2 = document.querySelector(".tcd-bg-orb-2");

  if (!orb1 && !orb2) return;

  let ticking = false;

  function updateParallax() {
    const scrollY = window.scrollY || window.pageYOffset;

    if (orb1) {
      orb1.style.transform = `translate3d(0, ${scrollY * 0.08}px, 0)`;
    }

    if (orb2) {
      orb2.style.transform = `translate3d(0, ${scrollY * -0.05}px, 0)`;
    }

    ticking = false;
  }

  window.addEventListener("scroll", function () {
    if (!ticking) {
      window.requestAnimationFrame(updateParallax);
      ticking = true;
    }
  });
}
