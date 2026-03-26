document.addEventListener("DOMContentLoaded", function () {
  initRevealAnimations();
  initStaggerDelays();
  initRippleButtons();
  initModalControls();
  initParallaxOrbs();
  initCardTilt();
});

function initRevealAnimations() {
  const revealEls = document.querySelectorAll(".tu-reveal");
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
  const groups = document.querySelectorAll(".tu-stagger");

  groups.forEach((group) => {
    const children = Array.from(group.children).filter((child) => {
      return child.classList && child.classList.contains("tu-reveal");
    });

    children.forEach((child, index) => {
      child.style.transitionDelay = `${Math.min(index * 80, 420)}ms`;
    });
  });
}

function initRippleButtons() {
  const buttons = document.querySelectorAll(".tu-btn-ripple");

  buttons.forEach((button) => {
    button.addEventListener("click", function (e) {
      const rect = button.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      ripple.className = "tu-ripple";
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

function initModalControls() {
  const openButtons = document.querySelectorAll("[data-open-modal]");
  const closeButtons = document.querySelectorAll("[data-close-modal]");

  openButtons.forEach((button) => {
    button.addEventListener("click", function () {
      const modalId = button.getAttribute("data-open-modal");
      const modal = document.getElementById(modalId);
      if (!modal) return;

      modal.classList.add("active");
      modal.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
    });
  });

  closeButtons.forEach((button) => {
    button.addEventListener("click", function () {
      const modalId = button.getAttribute("data-close-modal");
      const modal = document.getElementById(modalId);
      if (!modal) return;

      closeModal(modal);
    });
  });

  document.querySelectorAll(".tu-modal-overlay").forEach((modal) => {
    const content = modal.querySelector(".tu-modal-content");

    modal.addEventListener("click", function (e) {
      if (content && !content.contains(e.target)) {
        closeModal(modal);
      }
    });
  });

  document.addEventListener("keydown", function (e) {
    if (e.key !== "Escape") return;

    document.querySelectorAll(".tu-modal-overlay.active").forEach((modal) => {
      closeModal(modal);
    });
  });

  function closeModal(modal) {
    modal.classList.remove("active");
    modal.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
  }
}

function initParallaxOrbs() {
  const orb1 = document.querySelector(".tu-bg-orb-1");
  const orb2 = document.querySelector(".tu-bg-orb-2");

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

function initCardTilt() {
  const cards = document.querySelectorAll(".tu-card");

  cards.forEach((card) => {
    card.addEventListener("mousemove", function (e) {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const centerX = rect.width / 2;
      const centerY = rect.height / 2;

      const rotateX = ((y - centerY) / centerY) * -3;
      const rotateY = ((x - centerX) / centerX) * 3;

      card.style.transform = `translateY(-8px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
    });

    card.addEventListener("mouseleave", function () {
      card.style.transform = "";
    });
  });
}
