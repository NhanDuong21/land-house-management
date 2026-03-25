document.addEventListener("DOMContentLoaded", function () {
  const benefitCards = document.querySelectorAll(".recruit-benefit-card");
  const jobCards = document.querySelectorAll(".job-card");
  const requirementItems = document.querySelectorAll(".requirement-item");
  const ctaButtons = document.querySelectorAll(".recruit-btn");
  const hero = document.querySelector(".recruit-hero");
  const ctaBox = document.querySelector(".recruit-cta-box");
  const allItems = [...benefitCards, ...jobCards, ...requirementItems];

  /* =========================
   * Initial states
   * ========================= */
  allItems.forEach((item, index) => {
    item.style.opacity = "0";
    item.style.transform = "translateY(35px)";
    item.style.transition = `opacity 0.75s ease, transform 0.75s ease`;
    item.style.transitionDelay = `${Math.min(index * 0.04, 0.32)}s`;
  });

  /* =========================
   * Reveal observer
   * ========================= */
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.style.opacity = "1";
        entry.target.style.transform = "translateY(0)";
        observer.unobserve(entry.target);
      });
    },
    {
      threshold: 0.14,
    },
  );

  allItems.forEach((item) => observer.observe(item));

  /* =========================
   * Hero parallax glow
   * ========================= */
  if (hero) {
    hero.style.position = "relative";
    hero.style.overflow = "hidden";

    const heroGlow = document.createElement("div");
    heroGlow.style.position = "absolute";
    heroGlow.style.width = "260px";
    heroGlow.style.height = "260px";
    heroGlow.style.borderRadius = "50%";
    heroGlow.style.background =
      "radial-gradient(circle, rgba(255,255,255,0.20) 0%, rgba(255,255,255,0.07) 35%, rgba(255,255,255,0) 72%)";
    heroGlow.style.pointerEvents = "none";
    heroGlow.style.transform = "translate(-50%, -50%)";
    heroGlow.style.opacity = "0";
    heroGlow.style.transition = "opacity 0.25s ease";
    hero.appendChild(heroGlow);

    hero.addEventListener("mousemove", function (e) {
      const rect = hero.getBoundingClientRect();
      heroGlow.style.left = `${e.clientX - rect.left}px`;
      heroGlow.style.top = `${e.clientY - rect.top}px`;
      heroGlow.style.opacity = "1";

      const x = (e.clientX - rect.left) / rect.width;
      const y = (e.clientY - rect.top) / rect.height;
      hero.style.backgroundPosition = `${50 + (x - 0.5) * 8}% ${50 + (y - 0.5) * 8}%`;
    });

    hero.addEventListener("mouseleave", function () {
      heroGlow.style.opacity = "0";
      hero.style.backgroundPosition = "center";
    });
  }

  /* =========================
   * Tilt + glow cards
   * ========================= */
  function attachCardFX(cards, rotate = 8) {
    cards.forEach((card) => {
      card.style.position = "relative";
      card.style.overflow = "hidden";
      card.style.transformStyle = "preserve-3d";
      card.style.willChange = "transform";

      const glow = document.createElement("span");
      glow.style.position = "absolute";
      glow.style.width = "210px";
      glow.style.height = "210px";
      glow.style.borderRadius = "50%";
      glow.style.pointerEvents = "none";
      glow.style.opacity = "0";
      glow.style.transform = "translate(-50%, -50%)";
      glow.style.transition = "opacity 0.22s ease";
      glow.style.background =
        "radial-gradient(circle, rgba(37,99,235,0.18) 0%, rgba(37,99,235,0.08) 38%, rgba(37,99,235,0) 72%)";
      card.appendChild(glow);

      card.addEventListener("mousemove", function (e) {
        const rect = card.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        const rotateY = (x / rect.width - 0.5) * rotate * 2;
        const rotateX = (y / rect.height - 0.5) * -rotate * 2;

        card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-6px)`;
        glow.style.left = `${x}px`;
        glow.style.top = `${y}px`;
        glow.style.opacity = "1";
      });

      card.addEventListener("mouseleave", function () {
        card.style.transform =
          "perspective(1000px) rotateX(0deg) rotateY(0deg) translateY(0)";
        glow.style.opacity = "0";
      });
    });
  }

  attachCardFX(benefitCards, 8);
  attachCardFX(jobCards, 7);

  /* =========================
   * Requirement checklist wave
   * ========================= */
  function activateRequirements() {
    const trigger = window.innerHeight * 0.75;

    requirementItems.forEach((item, index) => {
      const rect = item.getBoundingClientRect();
      const icon = item.querySelector("i");

      if (rect.top < trigger) {
        item.style.transform = "translateX(0)";
        item.style.background = "#eff6ff";
        item.style.borderColor = "#bfdbfe";
        item.style.boxShadow = "0 10px 22px rgba(37,99,235,0.07)";
        item.style.transitionDelay = `${index * 0.05}s`;

        if (icon) {
          icon.style.transform = "scale(1.15)";
          icon.style.color = "#22c55e";
        }
      } else {
        item.style.background = "#f8fafc";
        item.style.borderColor = "#e8eef5";
        item.style.boxShadow = "";
        if (icon) {
          icon.style.transform = "scale(1)";
        }
      }

      item.style.transition = "all 0.35s ease";
      if (icon) {
        icon.style.transition = "all 0.25s ease";
      }
    });
  }

  window.addEventListener("scroll", activateRequirements, { passive: true });
  activateRequirements();

  /* =========================
   * CTA box pulse
   * ========================= */
  if (ctaBox) {
    ctaBox.animate(
      [
        {
          transform: "translateY(0px)",
          boxShadow: "0 18px 40px rgba(15,23,42,0.12)",
        },
        {
          transform: "translateY(-4px)",
          boxShadow: "0 24px 46px rgba(37,99,235,0.18)",
        },
        {
          transform: "translateY(0px)",
          boxShadow: "0 18px 40px rgba(15,23,42,0.12)",
        },
      ],
      {
        duration: 2600,
        iterations: Infinity,
        easing: "ease-in-out",
      },
    );
  }

  /* =========================
   * Magnetic CTA buttons
   * ========================= */
  ctaButtons.forEach((btn) => {
    btn.style.transition = "transform 0.18s ease, box-shadow 0.25s ease";

    btn.addEventListener("mousemove", function (e) {
      const rect = btn.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;

      btn.style.transform = `translate(${x * 0.12}px, ${y * 0.18}px)`;
      btn.style.boxShadow = "0 12px 26px rgba(0,0,0,0.12)";
    });

    btn.addEventListener("mouseleave", function () {
      btn.style.transform = "translate(0,0)";
      btn.style.boxShadow = "";
    });
  });

  /* =========================
   * Button ripple
   * ========================= */
  ctaButtons.forEach((btn) => {
    btn.style.position = "relative";
    btn.style.overflow = "hidden";

    btn.addEventListener("click", function (e) {
      const rect = btn.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height) * 1.4;

      ripple.style.position = "absolute";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;
      ripple.style.borderRadius = "50%";
      ripple.style.background = "rgba(255,255,255,0.35)";
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
   * Job cards random floating
   * ========================= */
  jobCards.forEach((card, index) => {
    card.animate(
      [
        { transform: "translateY(0px)" },
        { transform: `translateY(${index % 2 === 0 ? -5 : 5}px)` },
        { transform: "translateY(0px)" },
      ],
      {
        duration: 2200 + index * 180,
        iterations: Infinity,
        direction: "alternate",
        easing: "ease-in-out",
      },
    );
  });

  /* =========================
   * Scroll progress bar
   * ========================= */
  const progressBar = document.createElement("div");
  progressBar.style.position = "fixed";
  progressBar.style.left = "0";
  progressBar.style.top = "0";
  progressBar.style.height = "4px";
  progressBar.style.width = "0%";
  progressBar.style.zIndex = "9999";
  progressBar.style.background = "linear-gradient(90deg, #8b5cf6, #2563eb)";
  progressBar.style.boxShadow = "0 0 12px rgba(99,102,241,0.35)";
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
});
