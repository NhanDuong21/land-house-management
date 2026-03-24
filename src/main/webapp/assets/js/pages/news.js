document.addEventListener("DOMContentLoaded", function () {
  const newsCards = document.querySelectorAll(".news-card");
  const releaseItems = document.querySelectorAll(".release-item");
  const upcomingCards = document.querySelectorAll(".upcoming-card");
  const hero = document.querySelector(".news-hero");
  const allRevealTargets = [...newsCards, ...releaseItems, ...upcomingCards];
  const body = document.body;

  /* =========================
   * Initial animation states
   * ========================= */
  allRevealTargets.forEach((el, index) => {
    el.style.opacity = "0";
    el.style.transform = "translateY(36px) scale(0.98)";
    el.style.transition = `opacity 0.7s ease, transform 0.7s ease`;
    el.style.transitionDelay = `${Math.min(index * 0.05, 0.4)}s`;
  });

  /* =========================
   * Reveal on scroll
   * ========================= */
  const revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        entry.target.style.opacity = "1";
        entry.target.style.transform = "translateY(0) scale(1)";
        revealObserver.unobserve(entry.target);
      });
    },
    {
      threshold: 0.15,
    },
  );

  allRevealTargets.forEach((el) => revealObserver.observe(el));

  /* =========================
   * Hero animated badge pulse
   * ========================= */
  const badge = document.querySelector(".news-badge");
  if (badge) {
    badge.animate(
      [
        { transform: "scale(1)", boxShadow: "0 0 0 rgba(255,255,255,0.0)" },
        {
          transform: "scale(1.04)",
          boxShadow: "0 0 22px rgba(255,255,255,0.18)",
        },
        { transform: "scale(1)", boxShadow: "0 0 0 rgba(255,255,255,0.0)" },
      ],
      {
        duration: 2200,
        iterations: Infinity,
        easing: "ease-in-out",
      },
    );
  }

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

      hero.style.backgroundPosition = `${50 + (x - 0.5) * 8}% ${50 + (y - 0.5) * 8}%`;
    });

    hero.addEventListener("mouseleave", function () {
      hero.style.backgroundPosition = "center";
    });
  }

  /* =========================
   * Tilt + spotlight for cards
   * ========================= */
  function attachInteractiveCard(card, maxRotate) {
    card.style.transformStyle = "preserve-3d";
    card.style.willChange = "transform";
    card.style.position = "relative";
    card.style.overflow = "hidden";

    const glow = document.createElement("span");
    glow.style.position = "absolute";
    glow.style.width = "220px";
    glow.style.height = "220px";
    glow.style.borderRadius = "50%";
    glow.style.pointerEvents = "none";
    glow.style.opacity = "0";
    glow.style.transform = "translate(-50%, -50%)";
    glow.style.transition = "opacity 0.2s ease";
    glow.style.background =
      "radial-gradient(circle, rgba(37,99,235,0.16) 0%, rgba(37,99,235,0.07) 40%, rgba(37,99,235,0) 72%)";
    card.appendChild(glow);

    card.addEventListener("mousemove", function (e) {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      const rotateY = (x / rect.width - 0.5) * maxRotate * 2;
      const rotateX = (y / rect.height - 0.5) * -maxRotate * 2;

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
  }

  newsCards.forEach((card) => attachInteractiveCard(card, 7));
  upcomingCards.forEach((card) => attachInteractiveCard(card, 6));

  /* =========================
   * Featured card shimmer
   * ========================= */
  const featured = document.querySelector(".news-card--featured");
  if (featured) {
    featured.style.position = "relative";
    featured.style.overflow = "hidden";

    const shimmer = document.createElement("span");
    shimmer.style.position = "absolute";
    shimmer.style.top = "0";
    shimmer.style.left = "-120%";
    shimmer.style.width = "50%";
    shimmer.style.height = "100%";
    shimmer.style.pointerEvents = "none";
    shimmer.style.transform = "skewX(-22deg)";
    shimmer.style.background =
      "linear-gradient(90deg, rgba(255,255,255,0), rgba(255,255,255,0.42), rgba(255,255,255,0))";
    featured.appendChild(shimmer);

    setInterval(() => {
      shimmer.animate([{ left: "-120%" }, { left: "140%" }], {
        duration: 1300,
        easing: "ease-in-out",
      });
    }, 3200);
  }

  /* =========================
   * Release items active wave
   * ========================= */
  function activateReleaseItems() {
    const trigger = window.innerHeight * 0.72;
    releaseItems.forEach((item, index) => {
      const rect = item.getBoundingClientRect();
      const icon = item.querySelector(".release-item__icon");

      if (rect.top < trigger && rect.bottom > 60) {
        item.style.transform = "translateX(0)";
        item.style.background = "#ffffff";
        item.style.borderColor = "#bfdbfe";
        item.style.boxShadow = "0 12px 26px rgba(37,99,235,0.08)";
        if (icon) {
          icon.style.transform = "scale(1.08)";
          icon.style.boxShadow = "0 10px 22px rgba(34,197,94,0.18)";
        }
      } else {
        item.style.boxShadow = "";
        item.style.borderColor = "#e8eef5";
        if (icon) {
          icon.style.transform = "scale(1)";
          icon.style.boxShadow = "";
        }
      }

      item.style.transition = `all 0.35s ease ${index * 0.03}s`;
      if (icon) {
        icon.style.transition = "all 0.25s ease";
      }
    });
  }

  window.addEventListener("scroll", activateReleaseItems, { passive: true });
  activateReleaseItems();

  /* =========================
   * News links arrow motion
   * ========================= */
  document.querySelectorAll(".news-link").forEach((link) => {
    link.addEventListener("mouseenter", function () {
      const icon = link.querySelector("i");
      if (icon) {
        icon.style.transition = "transform 0.25s ease";
        icon.style.transform = "translateX(5px)";
      }
    });

    link.addEventListener("mouseleave", function () {
      const icon = link.querySelector("i");
      if (icon) {
        icon.style.transform = "translateX(0)";
      }
    });
  });

  /* =========================
   * Floating particles in hero
   * ========================= */
  if (hero) {
    for (let i = 0; i < 10; i++) {
      const particle = document.createElement("span");
      particle.style.position = "absolute";
      particle.style.width = `${6 + Math.random() * 8}px`;
      particle.style.height = particle.style.width;
      particle.style.borderRadius = "50%";
      particle.style.background = "rgba(255,255,255,0.18)";
      particle.style.left = `${Math.random() * 100}%`;
      particle.style.top = `${Math.random() * 100}%`;
      particle.style.pointerEvents = "none";
      particle.style.filter = "blur(0.5px)";
      particle.style.zIndex = "0";
      hero.appendChild(particle);

      particle.animate(
        [
          { transform: "translateY(0px)", opacity: 0.2 },
          {
            transform: `translateY(-${20 + Math.random() * 30}px)`,
            opacity: 0.55,
          },
          { transform: "translateY(0px)", opacity: 0.2 },
        ],
        {
          duration: 3000 + Math.random() * 2200,
          iterations: Infinity,
          easing: "ease-in-out",
        },
      );
    }
  }

  /* =========================
   * Typing effect for hero title
   * ========================= */
  const heroTitle = document.querySelector(".news-hero h1");
  if (heroTitle) {
    const originalText = heroTitle.textContent;
    heroTitle.textContent = "";
    let idx = 0;

    const typing = setInterval(() => {
      heroTitle.textContent += originalText.charAt(idx);
      idx++;
      if (idx >= originalText.length) {
        clearInterval(typing);
      }
    }, 32);
  }

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
  progressBar.style.background = "linear-gradient(90deg, #22c55e, #3b82f6)";
  progressBar.style.boxShadow = "0 0 12px rgba(59,130,246,0.4)";
  progressBar.style.transition = "width 0.08s linear";
  body.appendChild(progressBar);

  function updateProgress() {
    const scrolled = window.scrollY;
    const max = document.documentElement.scrollHeight - window.innerHeight;
    progressBar.style.width = `${max > 0 ? (scrolled / max) * 100 : 0}%`;
  }

  window.addEventListener("scroll", updateProgress, { passive: true });
  updateProgress();
});
