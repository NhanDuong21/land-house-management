(function () {
  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) =>
    Array.from(root.querySelectorAll(selector));

  // =========================
  // Reveal animation
  // =========================
  const revealEls = $$(".mlt-reveal");
  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        });
      },
      { threshold: 0.12 },
    );

    revealEls.forEach((el, index) => {
      el.style.transitionDelay = `${Math.min(index * 80, 320)}ms`;
      observer.observe(el);
    });
  } else {
    revealEls.forEach((el) => el.classList.add("is-visible"));
  }

  // =========================
  // Animate rows stagger
  // =========================
  const rows = $$(".mlt-row");
  rows.forEach((row, index) => {
    row.style.animationDelay = `${Math.min(index * 55, 350)}ms`;
  });

  // =========================
  // Ripple effect
  // =========================
  const attachRipple = (element) => {
    if (!element) return;

    element.addEventListener("click", (e) => {
      const rect = element.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      ripple.className = "mlt-ripple-wave";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;

      element.appendChild(ripple);
      window.setTimeout(() => ripple.remove(), 700);
    });
  };

  $$(".mlt-ripple, .mlt-action-btn, .mlt-pagination a").forEach(attachRipple);

  // =========================
  // Loading state for action buttons
  // =========================
  const actionButtons = $$(".mlt-action-btn");
  actionButtons.forEach((btn) => {
    btn.addEventListener("click", () => {
      if (btn.dataset.loading === "true") return;

      btn.dataset.loading = "true";
      btn.classList.add("is-loading");

      const text = $(".mlt-btn-text", btn);
      if (text) {
        btn.dataset.originalText = text.innerHTML;
        text.innerHTML = `<span class="mlt-spinner"></span> Loading...`;
      }
    });
  });

  // =========================
  // Pager disabled protection
  // =========================
  const pagerLinks = $$(".mlt-pagination a");
  pagerLinks.forEach((link) => {
    link.addEventListener("click", function (e) {
      const li = link.closest("li");
      if (li && li.classList.contains("disabled")) {
        e.preventDefault();
      }
    });
  });

  // =========================
  // Subtle row hover movement
  // =========================
  rows.forEach((row) => {
    row.addEventListener("mouseenter", () => {
      row.style.transform = "translateX(2px)";
    });

    row.addEventListener("mouseleave", () => {
      row.style.transform = "";
    });
  });
})();
