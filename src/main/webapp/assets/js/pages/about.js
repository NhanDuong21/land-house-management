document.addEventListener("DOMContentLoaded", function () {
  const body = document.body;

  /* =========================
   * Helpers
   * ========================= */
  function clamp(value, min, max) {
    return Math.min(Math.max(value, min), max);
  }

  function debounce(fn, delay) {
    let timer;
    return function (...args) {
      clearTimeout(timer);
      timer = setTimeout(() => fn.apply(this, args), delay);
    };
  }

  /* =========================
   * Initial page state
   * ========================= */
  const hero = document.querySelector(".about-hero");
  const sections = document.querySelectorAll(".about-section, .about-closing");
  const featureCards = document.querySelectorAll(".about-feature-card");
  const teamCards = document.querySelectorAll(".team-card");
  const infoBoxes = document.querySelectorAll(".about-info-box");
  const timelineItems = document.querySelectorAll(".about-timeline__item");
  const statCards = document.querySelectorAll(".about-stat-card");
  const techBadges = document.querySelectorAll(".tech-badge");
  const heroButtons = document.querySelectorAll(".about-btn");

  [
    ...sections,
    ...featureCards,
    ...teamCards,
    ...infoBoxes,
    ...timelineItems,
    ...techBadges,
  ].forEach((el, index) => {
    el.style.opacity = "0";
    el.style.transform = "translateY(32px)";
    el.style.transition = `opacity 0.7s ease, transform 0.7s ease`;
    el.style.transitionDelay = `${Math.min(index * 0.04, 0.35)}s`;
  });

  /* =========================
   * Reveal on scroll
   * ========================= */
  const revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.style.opacity = "1";
          entry.target.style.transform = "translateY(0)";
          revealObserver.unobserve(entry.target);
        }
      });
    },
    {
      threshold: 0.14,
    },
  );

  [
    ...sections,
    ...featureCards,
    ...teamCards,
    ...infoBoxes,
    ...timelineItems,
    ...techBadges,
  ].forEach((el) => {
    revealObserver.observe(el);
  });

  /* =========================
   * Animated counters
   * ========================= */
  function animateCounter(el, targetText) {
    const numeric = parseInt(targetText.replace(/\D/g, ""), 10);
    if (isNaN(numeric)) {
      return;
    }

    let current = 0;
    const duration = 1800;
    const stepTime = 16;
    const steps = Math.floor(duration / stepTime);
    const increment = numeric / steps;
    const suffix = targetText.replace(/[0-9]/g, "");

    const counter = setInterval(() => {
      current += increment;
      if (current >= numeric) {
        current = numeric;
        clearInterval(counter);
      }
      el.textContent = Math.floor(current) + suffix;
    }, stepTime);
  }

  const counterObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        const valueEl = entry.target.querySelector(".about-stat-card__value");
        if (valueEl && !valueEl.dataset.animated) {
          valueEl.dataset.animated = "true";
          animateCounter(valueEl, valueEl.textContent.trim());
        }
        counterObserver.unobserve(entry.target);
      });
    },
    {
      threshold: 0.45,
    },
  );

  statCards.forEach((card) => counterObserver.observe(card));

  /* =========================
   * Parallax hero effect
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

      const moveX = (x - 0.5) * 16;
      const moveY = (y - 0.5) * 16;

      hero.style.backgroundPosition = `${50 + moveX * 0.4}% ${50 + moveY * 0.4}%`;

      statCards.forEach((card, index) => {
        const factor = (index + 1) * 0.4;
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
   * Tilt cards
   * ========================= */
  function attachTilt(elements, maxRotate = 8) {
    elements.forEach((card) => {
      card.style.transformStyle = "preserve-3d";
      card.style.willChange = "transform";

      card.addEventListener("mousemove", function (e) {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const rotateY = (x / rect.width - 0.5) * (maxRotate * 2);
        const rotateX = (y / rect.height - 0.5) * -(maxRotate * 2);

        card.style.transform = `perspective(900px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-6px)`;
      });

      card.addEventListener("mouseleave", function () {
        card.style.transform =
          "perspective(900px) rotateX(0deg) rotateY(0deg) translateY(0)";
      });
    });
  }

  attachTilt(featureCards, 7);
  attachTilt(teamCards, 9);
  attachTilt(infoBoxes, 6);

  /* =========================
   * Mouse spotlight
   * ========================= */
  function attachSpotlight(elements) {
    elements.forEach((card) => {
      card.style.position = "relative";
      card.style.overflow = "hidden";

      const glow = document.createElement("span");
      glow.className = "js-spotlight";
      glow.style.position = "absolute";
      glow.style.width = "180px";
      glow.style.height = "180px";
      glow.style.borderRadius = "50%";
      glow.style.pointerEvents = "none";
      glow.style.background =
        "radial-gradient(circle, rgba(59,130,246,0.18) 0%, rgba(59,130,246,0.08) 35%, rgba(59,130,246,0) 70%)";
      glow.style.transform = "translate(-50%, -50%)";
      glow.style.opacity = "0";
      glow.style.transition = "opacity 0.25s ease";
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

  attachSpotlight(featureCards);
  attachSpotlight(teamCards);

  /* =========================
   * Timeline progress active state
   * ========================= */
  function updateTimelineActive() {
    const triggerY = window.innerHeight * 0.62;
    timelineItems.forEach((item) => {
      const rect = item.getBoundingClientRect();
      const dot = item.querySelector(".about-timeline__dot");
      const content = item.querySelector(".about-timeline__content");

      if (rect.top < triggerY && rect.bottom > 120) {
        item.classList.add("is-active");
        if (dot) {
          dot.style.transform = "scale(1.08)";
          dot.style.boxShadow = "0 12px 26px rgba(37,99,235,0.35)";
        }
        if (content) {
          content.style.borderColor = "#bfdbfe";
          content.style.background = "#eff6ff";
        }
      } else {
        item.classList.remove("is-active");
        if (dot) {
          dot.style.transform = "scale(1)";
          dot.style.boxShadow = "";
        }
        if (content) {
          content.style.borderColor = "#eaf0f6";
          content.style.background = "#f8fafc";
        }
      }
    });
  }

  window.addEventListener("scroll", updateTimelineActive, { passive: true });
  updateTimelineActive();

  /* =========================
   * Ripple buttons
   * ========================= */
  heroButtons.forEach((btn) => {
    btn.style.position = "relative";
    btn.style.overflow = "hidden";

    btn.addEventListener("click", function (e) {
      const rect = btn.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height) * 1.3;

      ripple.style.position = "absolute";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;
      ripple.style.borderRadius = "50%";
      ripple.style.pointerEvents = "none";
      ripple.style.background = "rgba(255,255,255,0.35)";
      ripple.style.transform = "scale(0)";
      ripple.style.opacity = "1";
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
   * Magnetic buttons
   * ========================= */
  heroButtons.forEach((btn) => {
    btn.addEventListener("mousemove", function (e) {
      const rect = btn.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;

      btn.style.transform = `translate(${x * 0.12}px, ${y * 0.18}px)`;
    });

    btn.addEventListener("mouseleave", function () {
      btn.style.transform = "translate(0,0)";
    });
  });

  /* =========================
   * Floating tech badges
   * ========================= */
  techBadges.forEach((badge, index) => {
    badge.animate(
      [
        { transform: "translateY(0px)" },
        { transform: `translateY(${index % 2 === 0 ? -6 : 6}px)` },
        { transform: "translateY(0px)" },
      ],
      {
        duration: 2400 + index * 140,
        iterations: Infinity,
        direction: "alternate",
        easing: "ease-in-out",
      },
    );
  });

  /* =========================
   * Page scroll progress bar
   * ========================= */
  const progressBar = document.createElement("div");
  progressBar.style.position = "fixed";
  progressBar.style.left = "0";
  progressBar.style.top = "0";
  progressBar.style.height = "4px";
  progressBar.style.width = "0%";
  progressBar.style.zIndex = "9999";
  progressBar.style.background = "linear-gradient(90deg, #2563eb, #60a5fa)";
  progressBar.style.boxShadow = "0 0 12px rgba(37,99,235,0.45)";
  progressBar.style.transition = "width 0.08s linear";
  body.appendChild(progressBar);

  function updateProgressBar() {
    const scrollTop = window.scrollY;
    const docHeight =
      document.documentElement.scrollHeight - window.innerHeight;
    const percent = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
    progressBar.style.width = `${percent}%`;
  }

  window.addEventListener("scroll", updateProgressBar, { passive: true });
  updateProgressBar();

  /* =========================
   * Soft page entrance
   * ========================= */
  document.documentElement.style.scrollBehavior = "smooth";
  body.animate(
    [
      { opacity: 0, transform: "translateY(10px)" },
      { opacity: 1, transform: "translateY(0)" },
    ],
    {
      duration: 500,
      easing: "ease-out",
      fill: "forwards",
    },
  );

  /* =========================
   * Resize fix
   * ========================= */
  window.addEventListener("resize", debounce(updateTimelineActive, 120));
});
