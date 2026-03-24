document.addEventListener("DOMContentLoaded", function () {
  const hero = document.querySelector(".ct-hero");
  const sections = document.querySelectorAll(".ct-section");
  const items = document.querySelectorAll(".ct-item");
  const guideCards = document.querySelectorAll(".ct-guide-card");
  const miniCards = document.querySelectorAll(".ct-mini-card");
  const supportCard = document.querySelector(".ct-support-card");
  const noteCard = document.querySelector(".ct-note");
  const statCards = document.querySelectorAll(".ct-stat-card");
  const heroButtons = document.querySelectorAll(".ct-btn");
  const actionButtons = document.querySelectorAll(".ct-action-btn");
  const companyBox = document.querySelector(".ct-company");
  const allRevealTargets = [
    ...sections,
    ...items,
    ...guideCards,
    ...miniCards,
    ...statCards,
  ];

  function debounce(fn, delay) {
    let timer;
    return function (...args) {
      clearTimeout(timer);
      timer = setTimeout(() => fn.apply(this, args), delay);
    };
  }

  /* =========================
   * Initial reveal state
   * ========================= */
  allRevealTargets.forEach((el, index) => {
    el.style.opacity = "0";
    el.style.transform = "translateY(34px)";
    el.style.transition = "opacity 0.75s ease, transform 0.75s ease";
    el.style.transitionDelay = `${Math.min(index * 0.035, 0.32)}s`;
  });

  if (supportCard) {
    supportCard.style.opacity = "0";
    supportCard.style.transform = "translateY(34px)";
    supportCard.style.transition = "opacity 0.75s ease, transform 0.75s ease";
  }

  if (noteCard) {
    noteCard.style.opacity = "0";
    noteCard.style.transform = "translateY(34px)";
    noteCard.style.transition = "opacity 0.75s ease, transform 0.75s ease";
  }

  if (companyBox) {
    companyBox.style.opacity = "0";
    companyBox.style.transform = "translateY(20px)";
    companyBox.style.transition = "opacity 0.7s ease, transform 0.7s ease";
  }

  /* =========================
   * Reveal on scroll
   * ========================= */
  const revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.style.opacity = "1";
        entry.target.style.transform = "translateY(0)";
        revealObserver.unobserve(entry.target);
      });
    },
    {
      threshold: 0.14,
    },
  );

  allRevealTargets.forEach((el) => revealObserver.observe(el));
  if (supportCard) revealObserver.observe(supportCard);
  if (noteCard) revealObserver.observe(noteCard);
  if (companyBox) revealObserver.observe(companyBox);

  /* =========================
   * Hero parallax
   * ========================= */
  if (hero) {
    document.addEventListener("mousemove", function (e) {
      const rect = hero.getBoundingClientRect();
      const inside =
        e.clientX >= rect.left &&
        e.clientX <= rect.right &&
        e.clientY >= rect.top &&
        e.clientY <= rect.bottom;

      if (!inside) return;

      const x = (e.clientX - rect.left) / rect.width;
      const y = (e.clientY - rect.top) / rect.height;
      const moveX = (x - 0.5) * 14;
      const moveY = (y - 0.5) * 14;

      hero.style.backgroundPosition = `${50 + moveX * 0.4}% ${50 + moveY * 0.4}%`;

      statCards.forEach((card, index) => {
        const factor = (index + 1) * 0.35;
        card.style.transform = `translate3d(${moveX * factor}px, ${moveY * factor}px, 0)`;
      });
    });

    hero.addEventListener("mouseleave", function () {
      hero.style.backgroundPosition = "center";
      statCards.forEach((card) => {
        card.style.transform = "translate3d(0,0,0)";
      });
    });
  }

  /* =========================
   * Counter-ish animation for stat cards
   * ========================= */
  function animateTextSwap(el, finalText) {
    const steps = ["...", "..", ".", finalText];
    let i = 0;
    const timer = setInterval(() => {
      el.textContent = steps[i];
      i++;
      if (i >= steps.length) {
        clearInterval(timer);
      }
    }, 120);
  }

  const statObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        const value = entry.target.querySelector(".ct-stat-card__value");
        if (value && !value.dataset.animated) {
          value.dataset.animated = "true";
          animateTextSwap(value, value.textContent.trim());
        }
        statObserver.unobserve(entry.target);
      });
    },
    { threshold: 0.45 },
  );

  statCards.forEach((card) => statObserver.observe(card));

  /* =========================
   * Tilt effects
   * ========================= */
  function attachTilt(elements, rotate = 8) {
    elements.forEach((card) => {
      card.style.transformStyle = "preserve-3d";
      card.style.willChange = "transform";

      card.addEventListener("mousemove", function (e) {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const rotateY = (x / rect.width - 0.5) * rotate * 2;
        const rotateX = (y / rect.height - 0.5) * -rotate * 2;

        card.style.transform = `perspective(950px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-5px)`;
      });

      card.addEventListener("mouseleave", function () {
        card.style.transform =
          "perspective(950px) rotateX(0deg) rotateY(0deg) translateY(0)";
      });
    });
  }

  attachTilt(guideCards, 7);
  attachTilt(miniCards, 7);
  if (supportCard) attachTilt([supportCard], 6);

  /* =========================
   * Spotlight effect
   * ========================= */
  function attachSpotlight(elements, color) {
    elements.forEach((card) => {
      card.style.position = "relative";
      card.style.overflow = "hidden";

      const glow = document.createElement("span");
      glow.style.position = "absolute";
      glow.style.width = "190px";
      glow.style.height = "190px";
      glow.style.borderRadius = "50%";
      glow.style.pointerEvents = "none";
      glow.style.background = color;
      glow.style.transform = "translate(-50%, -50%)";
      glow.style.opacity = "0";
      glow.style.transition = "opacity 0.22s ease";
      card.appendChild(glow);

      card.addEventListener("mousemove", function (e) {
        const rect = card.getBoundingClientRect();
        glow.style.left = `${e.clientX - rect.left}px`;
        glow.style.top = `${e.clientY - rect.top}px`;
        glow.style.opacity = "1";
      });

      card.addEventListener("mouseleave", function () {
        glow.style.opacity = "0";
      });
    });
  }

  attachSpotlight(
    items,
    "radial-gradient(circle, rgba(37,99,235,0.14) 0%, rgba(37,99,235,0.07) 35%, rgba(37,99,235,0) 72%)",
  );
  attachSpotlight(
    guideCards,
    "radial-gradient(circle, rgba(59,130,246,0.18) 0%, rgba(59,130,246,0.08) 35%, rgba(59,130,246,0) 72%)",
  );

  /* =========================
   * Floating animation
   * ========================= */
  miniCards.forEach((card, index) => {
    card.animate(
      [
        { transform: "translateY(0px)" },
        { transform: `translateY(${index % 2 === 0 ? -5 : 5}px)` },
        { transform: "translateY(0px)" },
      ],
      {
        duration: 2300 + index * 140,
        iterations: Infinity,
        direction: "alternate",
        easing: "ease-in-out",
      },
    );
  });

  /* =========================
   * Magnetic buttons
   * ========================= */
  [...heroButtons, ...actionButtons].forEach((btn) => {
    btn.style.transition = "transform 0.18s ease, box-shadow 0.25s ease";

    btn.addEventListener("mousemove", function (e) {
      const rect = btn.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;

      btn.style.transform = `translate(${x * 0.12}px, ${y * 0.18}px)`;
      btn.style.boxShadow = "0 12px 26px rgba(15,23,42,0.12)";
    });

    btn.addEventListener("mouseleave", function () {
      btn.style.transform = "translate(0,0)";
      btn.style.boxShadow = "";
    });
  });

  /* =========================
   * Ripple buttons
   * ========================= */
  [...heroButtons, ...actionButtons].forEach((btn) => {
    btn.style.position = "relative";
    btn.style.overflow = "hidden";

    btn.addEventListener("click", function (e) {
      const rect = btn.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height) * 1.35;

      ripple.style.position = "absolute";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;
      ripple.style.borderRadius = "50%";
      ripple.style.background = "rgba(255,255,255,0.32)";
      ripple.style.transform = "scale(0)";
      ripple.style.opacity = "1";
      ripple.style.pointerEvents = "none";
      ripple.style.transition = "transform 0.6s ease, opacity 0.6s ease";

      btn.appendChild(ripple);

      requestAnimationFrame(() => {
        ripple.style.transform = "scale(1)";
        ripple.style.opacity = "0";
      });

      setTimeout(() => ripple.remove(), 650);
    });
  });

  /* =========================
   * Active guide card on scroll
   * ========================= */
  function activateGuideCards() {
    const trigger = window.innerHeight * 0.72;

    guideCards.forEach((card) => {
      const rect = card.getBoundingClientRect();
      if (rect.top < trigger && rect.bottom > 80) {
        card.style.borderColor = "#bfdbfe";
        card.style.boxShadow = "0 16px 28px rgba(37,99,235,0.10)";
      } else {
        card.style.borderColor = "#e8eef5";
        card.style.boxShadow = "";
      }
    });
  }

  window.addEventListener("scroll", activateGuideCards, { passive: true });
  activateGuideCards();

  /* =========================
   * Scroll progress bar
   * ========================= */
  const progressBar = document.createElement("div");
  progressBar.style.position = "fixed";
  progressBar.style.top = "0";
  progressBar.style.left = "0";
  progressBar.style.height = "4px";
  progressBar.style.width = "0%";
  progressBar.style.zIndex = "9999";
  progressBar.style.background = "linear-gradient(90deg, #2563eb, #60a5fa)";
  progressBar.style.boxShadow = "0 0 12px rgba(37,99,235,0.40)";
  progressBar.style.transition = "width 0.08s linear";
  document.body.appendChild(progressBar);

  function updateProgress() {
    const scrollTop = window.scrollY;
    const maxHeight =
      document.documentElement.scrollHeight - window.innerHeight;
    const percent = maxHeight > 0 ? (scrollTop / maxHeight) * 100 : 0;
    progressBar.style.width = `${percent}%`;
  }

  window.addEventListener("scroll", updateProgress, { passive: true });
  updateProgress();

  /* =========================
   * Page entrance
   * ========================= */
  document.documentElement.style.scrollBehavior = "smooth";
  document.body.animate(
    [
      { opacity: 0, transform: "translateY(8px)" },
      { opacity: 1, transform: "translateY(0)" },
    ],
    {
      duration: 500,
      easing: "ease-out",
      fill: "forwards",
    },
  );

  window.addEventListener("resize", debounce(activateGuideCards, 120));
});
