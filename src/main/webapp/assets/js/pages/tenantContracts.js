(function () {
  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));

  // =========================
  // 1. Reveal animation
  // =========================
  const reveals = $$(".tc-card, .tc-title, .tc-sub");

  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((e) => {
          if (!e.isIntersecting) return;
          e.target.classList.add("tc-show");
          observer.unobserve(e.target);
        });
      },
      { threshold: 0.12 },
    );

    reveals.forEach((el, i) => {
      el.classList.add("tc-hidden");
      el.style.transitionDelay = `${Math.min(i * 60, 300)}ms`;
      observer.observe(el);
    });
  } else {
    reveals.forEach((el) => el.classList.add("tc-show"));
  }

  // =========================
  // 2. Ripple effect (button + card)
  // =========================
  function ripple(el) {
    el.addEventListener("click", (e) => {
      const rect = el.getBoundingClientRect();
      const wave = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      wave.className = "tc-ripple";
      wave.style.width = wave.style.height = size + "px";
      wave.style.left = e.clientX - rect.left - size / 2 + "px";
      wave.style.top = e.clientY - rect.top - size / 2 + "px";

      el.appendChild(wave);
      setTimeout(() => wave.remove(), 700);
    });
  }

  $$(".tc-view-btn, .tc-card").forEach(ripple);

  // =========================
  // 3. Card hover tilt (nhẹ thôi)
  // =========================
  $$(".tc-card").forEach((card) => {
    let raf;

    card.addEventListener("mousemove", (e) => {
      const r = card.getBoundingClientRect();
      const x = e.clientX - r.left;
      const y = e.clientY - r.top;

      const rx = (y / r.height - 0.5) * -4;
      const ry = (x / r.width - 0.5) * 4;

      cancelAnimationFrame(raf);
      raf = requestAnimationFrame(() => {
        card.style.transform = `perspective(900px) rotateX(${rx}deg) rotateY(${ry}deg) translateY(-2px)`;
      });
    });

    card.addEventListener("mouseleave", () => {
      card.style.transform = "";
    });
  });

  // =========================
  // 4. Smooth hover highlight row
  // =========================
  $$(".tc-row").forEach((row) => {
    row.addEventListener("mouseenter", () => {
      row.style.transform = "translateX(4px)";
    });

    row.addEventListener("mouseleave", () => {
      row.style.transform = "";
    });
  });
})();
