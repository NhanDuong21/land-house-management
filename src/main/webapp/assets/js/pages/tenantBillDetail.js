document.addEventListener("DOMContentLoaded", function () {
  initModal();
  initPaymentMethod();
  initRevealAnimations();
  initStaggerDelays();
  initRippleButtons();
  initTableRowReveal();
  initParallaxOrbs();
  initEscCloseModal();
});

function initModal() {
  const modal = document.getElementById("billModal");
  if (!modal) return;

  const modalContent = modal.querySelector(".custom-modal-content");

  window.openModal = function () {
    modal.style.display = "flex";
    requestAnimationFrame(() => {
      modal.classList.add("show");
    });
    document.body.style.overflow = "hidden";
  };

  window.closeModal = function () {
    modal.classList.remove("show");
    setTimeout(() => {
      modal.style.display = "none";
      document.body.style.overflow = "auto";
    }, 250);
  };

  modal.addEventListener("click", function (event) {
    if (modalContent && !modalContent.contains(event.target)) {
      window.closeModal();
    }
  });
}

function initEscCloseModal() {
  const modal = document.getElementById("billModal");
  if (!modal) return;

  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && modal.classList.contains("show")) {
      window.closeModal();
    }
  });
}

function initPaymentMethod() {
  const paymentSelect = document.getElementById("paymentMethod");
  const qrContainer = document.getElementById("qrContainer");

  if (paymentSelect && qrContainer) {
    qrContainer.style.display = "none";

    paymentSelect.addEventListener("change", function () {
      if (this.value === "BANK") {
        qrContainer.style.display = "block";
      } else {
        qrContainer.style.display = "none";
      }
    });
  }
}

function initRevealAnimations() {
  const revealEls = document.querySelectorAll(".tb-reveal");
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
  const groups = document.querySelectorAll(".tb-stagger");

  groups.forEach((group) => {
    const children = Array.from(group.children).filter((child) => {
      return child.classList && child.classList.contains("tb-reveal");
    });

    children.forEach((child, index) => {
      child.style.transitionDelay = `${Math.min(index * 80, 420)}ms`;
    });
  });
}

function initRippleButtons() {
  const buttons = document.querySelectorAll(".tb-btn-ripple");

  buttons.forEach((button) => {
    button.addEventListener("click", function (e) {
      const rect = button.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      ripple.className = "tb-ripple";
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

function initTableRowReveal() {
  const rows = document.querySelectorAll(".tb-row-reveal");
  if (!rows.length) return;

  if (!("IntersectionObserver" in window)) {
    rows.forEach((row) => row.classList.add("is-visible"));
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
      threshold: 0.08,
      rootMargin: "0px 0px -20px 0px",
    },
  );

  rows.forEach((row, index) => {
    row.style.transitionDelay = `${Math.min(index * 60, 480)}ms`;
    observer.observe(row);
  });
}

function initParallaxOrbs() {
  const orb1 = document.querySelector(".tb-bg-orb-1");
  const orb2 = document.querySelector(".tb-bg-orb-2");

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
