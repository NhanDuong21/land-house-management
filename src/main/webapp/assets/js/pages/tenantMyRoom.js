(function () {
  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) =>
    Array.from(root.querySelectorAll(selector));

  // =========================
  // Reveal on viewport
  // =========================
  const revealElements = $$(".mr-reveal");
  if ("IntersectionObserver" in window) {
    const revealObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return;
          entry.target.classList.add("is-visible");
          revealObserver.unobserve(entry.target);
        });
      },
      { threshold: 0.12 },
    );

    revealElements.forEach((el, index) => {
      el.style.transitionDelay = `${Math.min(index * 70, 350)}ms`;
      revealObserver.observe(el);
    });
  } else {
    revealElements.forEach((el) => el.classList.add("is-visible"));
  }

  // =========================
  // Ripple buttons/links
  // =========================
  const attachRipple = (element) => {
    if (!element) return;

    element.addEventListener("click", (e) => {
      const rect = element.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      ripple.className = "mr-ripple-wave";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;

      element.appendChild(ripple);
      window.setTimeout(() => ripple.remove(), 700);
    });
  };

  $$(".mr-ripple, .mr-thumb, .mr-cover-btn, .mr-lb-close, .mr-lb-nav").forEach(
    attachRipple,
  );

  // =========================
  // Tilt cards
  // =========================
  $$(".mr-tilt-card").forEach((card) => {
    let rafId = null;

    const resetTilt = () => {
      card.style.transform = "";
    };

    card.addEventListener("mousemove", (e) => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const rotateY = (x / rect.width - 0.5) * 6;
      const rotateX = (y / rect.height - 0.5) * -6;

      cancelAnimationFrame(rafId);
      rafId = requestAnimationFrame(() => {
        card.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-2px)`;
      });
    });

    card.addEventListener("mouseleave", resetTilt);
    card.addEventListener("blur", resetTilt, true);
  });

  // =========================
  // Lightbox
  // =========================
  const lightbox = document.getElementById("mrLightbox");
  if (!lightbox) return;

  const imgEl = document.getElementById("mrLbImg");
  const countEl = document.getElementById("mrLbCount");
  const skelEl = document.getElementById("mrLbSkel");
  const prevBtn = $(".mr-lb-nav.prev", lightbox);
  const nextBtn = $(".mr-lb-nav.next", lightbox);
  const closeBtn = $(".mr-lb-close", lightbox);
  const dialog = $(".mr-lightbox-box", lightbox);

  const thumbs = $$(".mr-thumb");
  const coverBtn = $(".mr-cover-btn[data-cover='1']");
  const coverSrc = coverBtn ? coverBtn.getAttribute("data-src") : null;

  const sources = thumbs
    .map((btn) => btn.getAttribute("data-src"))
    .filter(Boolean);

  let index = 0;
  let lastFocusedElement = null;
  let isAnimating = false;

  const focusableSelector =
    'button:not([disabled]), [href], input, select, textarea, [tabindex]:not([tabindex="-1"])';

  function showLoading() {
    lightbox.classList.add("is-loading");
    if (imgEl) imgEl.classList.remove("is-ready");
    if (skelEl) skelEl.style.display = "block";
  }

  function hideLoading() {
    lightbox.classList.remove("is-loading");
    if (skelEl) skelEl.style.display = "";
    if (imgEl) requestAnimationFrame(() => imgEl.classList.add("is-ready"));
  }

  function preload(src) {
    return new Promise((resolve) => {
      const im = new Image();
      im.onload = () => resolve(true);
      im.onerror = () => resolve(false);
      im.src = src;
    });
  }

  async function setImage(i) {
    if (!imgEl || isAnimating) return;
    isAnimating = true;

    showLoading();

    if (sources.length === 0) {
      if (!coverSrc) {
        hideLoading();
        isAnimating = false;
        return;
      }

      index = 0;
      if (countEl) countEl.textContent = "1/1";

      await preload(coverSrc);
      imgEl.src = coverSrc;
      hideLoading();
      isAnimating = false;
      return;
    }

    index = (i + sources.length) % sources.length;
    const src = sources[index];

    if (countEl) countEl.textContent = `${index + 1}/${sources.length}`;

    await preload(src);
    imgEl.src = src;
    hideLoading();

    const nextIdx = (index + 1) % sources.length;
    const prevIdx = (index - 1 + sources.length) % sources.length;
    preload(sources[nextIdx]);
    preload(sources[prevIdx]);

    isAnimating = false;
  }

  function open(i) {
    lastFocusedElement = document.activeElement;
    lightbox.classList.add("is-open");
    lightbox.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";
    setImage(i);

    requestAnimationFrame(() => {
      closeBtn?.focus();
    });
  }

  function close() {
    lightbox.classList.remove("is-open");
    lightbox.classList.remove("is-loading");
    lightbox.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";

    if (imgEl) {
      imgEl.classList.remove("is-ready");
      imgEl.src = "";
    }

    if (lastFocusedElement && typeof lastFocusedElement.focus === "function") {
      lastFocusedElement.focus();
    }
  }

  function next() {
    setImage(index + 1);
  }

  function prev() {
    setImage(index - 1);
  }

  function trapFocus(e) {
    if (!lightbox.classList.contains("is-open") || e.key !== "Tab") return;

    const focusables = $$(focusableSelector, dialog).filter(
      (el) => el.offsetParent !== null,
    );
    if (!focusables.length) return;

    const first = focusables[0];
    const last = focusables[focusables.length - 1];

    if (e.shiftKey && document.activeElement === first) {
      e.preventDefault();
      last.focus();
    } else if (!e.shiftKey && document.activeElement === last) {
      e.preventDefault();
      first.focus();
    }
  }

  thumbs.forEach((btn, i) => {
    btn.addEventListener("click", () => open(i));
  });

  if (coverBtn) {
    coverBtn.addEventListener("click", () => {
      if (sources.length > 0) open(0);
      else if (coverSrc) open(0);
    });
  }

  lightbox.addEventListener("click", (e) => {
    const target = e.target;
    if (target && target.getAttribute("data-close") === "1") {
      close();
    }
  });

  prevBtn?.addEventListener("click", (e) => {
    e.stopPropagation();
    prev();
  });

  nextBtn?.addEventListener("click", (e) => {
    e.stopPropagation();
    next();
  });

  closeBtn?.addEventListener("click", (e) => {
    e.stopPropagation();
    close();
  });

  document.addEventListener("keydown", (e) => {
    if (!lightbox.classList.contains("is-open")) return;

    if (e.key === "Escape") close();
    if (e.key === "ArrowRight") next();
    if (e.key === "ArrowLeft") prev();

    trapFocus(e);
  });

  // swipe
  let startX = 0;
  let startY = 0;
  let dragging = false;

  lightbox.addEventListener(
    "touchstart",
    (e) => {
      if (!lightbox.classList.contains("is-open")) return;
      const t = e.touches[0];
      startX = t.clientX;
      startY = t.clientY;
      dragging = true;
    },
    { passive: true },
  );

  lightbox.addEventListener("touchend", (e) => {
    if (!dragging) return;
    dragging = false;

    const t = e.changedTouches[0];
    const dx = t.clientX - startX;
    const dy = t.clientY - startY;

    if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) {
      if (dx < 0) next();
      else prev();
    }
  });

  // subtle empty card float
  const emptyCard = $(".mr-empty");
  if (emptyCard && emptyCard.animate) {
    emptyCard.animate(
      [
        { transform: "translateY(0px)" },
        { transform: "translateY(-3px)" },
        { transform: "translateY(0px)" },
      ],
      {
        duration: 2600,
        iterations: Infinity,
        easing: "ease-in-out",
      },
    );
  }
})();
