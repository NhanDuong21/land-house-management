(function () {
  // ===== Helpers =====
  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

  const brand = $(".login-brand");
  const panel = $(".login-panel");
  const card = $(".login-card");
  const errorBox = $(".login-error");

  // ===== Inject CSS once (Ripple PRO + FX) =====
  if (!$("#_rhLoginFxStyle")) {
    const st = document.createElement("style");
    st.id = "_rhLoginFxStyle";
    st.textContent = `
      /* ===== Ripple PRO ===== */
      .rh-ripple-host{
        position: relative;
        overflow: hidden;
        transform: translateZ(0);
        isolation: isolate; /* keeps blend local */
      }
      .rh-ripple{
        position:absolute;
        border-radius:999px;
        pointer-events:none;
        will-change: transform, opacity;
        transform: translate3d(0,0,0) scale(0.12);
        opacity: 0.0;
        mix-blend-mode: soft-light;
        filter: saturate(1.1);
      }

      /* ===== Shake (error) ===== */
      @keyframes rhShake {
        0%{transform:translateX(0)}
        18%{transform:translateX(-6px)}
        36%{transform:translateX(6px)}
        54%{transform:translateX(-4px)}
        72%{transform:translateX(4px)}
        100%{transform:translateX(0)}
      }

      /* ===== Floating blobs ===== */
      .rh-blob{
        position:absolute;
        width:180px; height:180px;
        border-radius:999px;
        filter: blur(16px);
        opacity:.28;
        transform: translate3d(0,0,0);
        animation: rhFloat 12s ease-in-out infinite;
      }
      .rh-blob.b1{ background: rgba(59,130,246,.55); }
      .rh-blob.b2{ background: rgba(34,197,94,.45); }
      .rh-blob.b3{ background: rgba(99,102,241,.45); }
      @keyframes rhFloat{
        0%{ transform: translate(0,0) scale(1); }
        50%{ transform: translate(24px,-26px) scale(1.08); }
        100%{ transform: translate(0,0) scale(1); }
      }
      @media (max-width: 980px){
        .rh-blob{ opacity:.16; }
      }
    `;
    document.head.appendChild(st);
  }

  // ===== 0) Tabs switching (FIX OTP not showing) =====
  const tabPassword = $("#tabPassword");
  const tabOtp = $("#tabOtp");
  const formPassword = $("#formPassword");
  const formOtp = $("#formOtp");

  function setActiveTab(which) {
    const isPassword = which === "password";

    if (tabPassword) {
      tabPassword.classList.toggle("is-active", isPassword);
      tabPassword.setAttribute("aria-selected", isPassword ? "true" : "false");
    }
    if (tabOtp) {
      tabOtp.classList.toggle("is-active", !isPassword);
      tabOtp.setAttribute("aria-selected", !isPassword ? "true" : "false");
    }

    if (formPassword)
      formPassword.style.display = isPassword ? "block" : "none";
    if (formOtp) formOtp.style.display = isPassword ? "none" : "block";
  }

  if (tabPassword)
    tabPassword.addEventListener("click", () => setActiveTab("password"));
  if (tabOtp) tabOtp.addEventListener("click", () => setActiveTab("otp"));
  setActiveTab("password");

  // ===== 1) Show/Hide password =====
  const togglePasswordBtn = $("#togglePassword");
  const passwordInput = $("#passwordInput");

  if (togglePasswordBtn && passwordInput) {
    togglePasswordBtn.addEventListener("click", () => {
      const isHidden = passwordInput.type === "password";
      passwordInput.type = isHidden ? "text" : "password";

      const icon = togglePasswordBtn.querySelector("i");
      if (icon) icon.className = isHidden ? "bi bi-eye-slash" : "bi bi-eye";
    });
  }

  // ===== 2) Ripple PRO (press + release, auto color) =====
  function parseRgb(str) {
    // returns {r,g,b,a}
    const m =
      str &&
      str
        .toString()
        .match(
          /rgba?\(\s*([\d.]+)\s*,\s*([\d.]+)\s*,\s*([\d.]+)(?:\s*,\s*([\d.]+))?\s*\)/i,
        );
    if (!m) return null;
    return { r: +m[1], g: +m[2], b: +m[3], a: m[4] === undefined ? 1 : +m[4] };
  }

  function luminance({ r, g, b }) {
    // relative luminance
    const srgb = [r, g, b].map((v) => {
      v /= 255;
      return v <= 0.03928 ? v / 12.92 : Math.pow((v + 0.055) / 1.055, 2.4);
    });
    return 0.2126 * srgb[0] + 0.7152 * srgb[1] + 0.0722 * srgb[2];
  }

  function getRippleColor(el) {
    const cs = getComputedStyle(el);
    const bg = parseRgb(cs.backgroundColor);
    const fg = parseRgb(cs.color);

    // If bg is transparent, prefer fg
    if (!bg || bg.a === 0) {
      if (fg) return `rgba(${fg.r},${fg.g},${fg.b},0.35)`;
      return "rgba(0,0,0,0.25)";
    }

    // Decide ripple based on bg luminance
    const L = luminance(bg);
    if (L < 0.35) {
      // dark bg => light ripple
      return "rgba(255,255,255,0.55)";
    }
    // light bg => colored ripple based on fg (or fallback)
    if (fg) return `rgba(${fg.r},${fg.g},${fg.b},0.28)`;
    return "rgba(17,24,39,0.18)";
  }

  function addRipplePro(el) {
    if (!el) return;
    el.classList.add("rh-ripple-host");

    let activeRipple = null; // the one on pointerdown (press)

    const makeRipple = (x, y) => {
      const rect = el.getBoundingClientRect();

      // Radius large enough to cover farthest corner from click point
      const dx = Math.max(x, rect.width - x);
      const dy = Math.max(y, rect.height - y);
      const radius = Math.sqrt(dx * dx + dy * dy);
      const size = radius * 2;

      const ripple = document.createElement("span");
      ripple.className = "rh-ripple";
      ripple.style.width = ripple.style.height = `${size}px`;
      ripple.style.left = `${x - size / 2}px`;
      ripple.style.top = `${y - size / 2}px`;

      // Soft gradient ripple (center stronger)
      const color = getRippleColor(el);
      ripple.style.background = `radial-gradient(circle, ${color} 0%, rgba(0,0,0,0) 62%)`;

      el.appendChild(ripple);

      // Use Web Animations API if available (super smooth)
      const appear = ripple.animate(
        [
          { transform: "translate3d(0,0,0) scale(0.12)", opacity: 0.0 },
          { transform: "translate3d(0,0,0) scale(1)", opacity: 1.0 },
        ],
        {
          duration: 420,
          easing: "cubic-bezier(0.22, 1, 0.36, 1)",
          fill: "forwards",
        },
      );

      return { ripple, appear };
    };

    const fadeOutAndRemove = (node) => {
      if (!node) return;
      // fade out smoothly
      const anim = node.animate([{ opacity: 1 }, { opacity: 0 }], {
        duration: 420,
        easing: "ease-out",
        fill: "forwards",
      });
      anim.onfinish = () => node.remove();
    };

    el.addEventListener("pointerdown", (e) => {
      if (el.disabled) return;
      // ignore right click
      if (e.button !== undefined && e.button !== 0) return;

      const rect = el.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      // Create press ripple
      const { ripple } = makeRipple(x, y);
      activeRipple = ripple;

      // For better feel
      el.style.transformOrigin = "center";
      el.style.transform = "translateY(1px) scale(0.99)";

      // Capture pointer so release always works even if cursor leaves
      try {
        el.setPointerCapture(e.pointerId);
      } catch (_) {}
    });

    el.addEventListener("pointerup", (e) => {
      el.style.transform = "";
      if (activeRipple) {
        // On release, fade out
        fadeOutAndRemove(activeRipple);
        activeRipple = null;
      }
    });

    el.addEventListener("pointercancel", () => {
      el.style.transform = "";
      if (activeRipple) {
        fadeOutAndRemove(activeRipple);
        activeRipple = null;
      }
    });

    // Also clean up if user leaves without pointerup (edge cases)
    el.addEventListener("mouseleave", () => {
      el.style.transform = "";
    });

    // Click ripple (quick tap) - if pointer events not supported somewhere
    el.addEventListener("click", (e) => {
      // If we already made one on pointerdown, skip
      // (Some browsers fire click after pointerup)
      // If activeRipple is null, create a quick one.
      if (activeRipple) return;

      const rect = el.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const { ripple } = makeRipple(x, y);
      // auto fade
      setTimeout(() => fadeOutAndRemove(ripple), 240);
    });
  }

  // Apply ripple PRO
  $$(".login-btn").forEach(addRipplePro);
  $$(".tab-btn").forEach(addRipplePro);

  // ===== 3) Entrance animation =====
  if (card) {
    card.style.opacity = "0";
    card.style.transform = "translateY(14px) scale(0.99)";
    card.style.transition =
      "opacity 420ms ease, transform 520ms cubic-bezier(0.22, 1, 0.36, 1)";

    requestAnimationFrame(() => {
      card.style.opacity = "1";
      card.style.transform = "translateY(0) scale(1)";
    });
  }

  // ===== 4) Error shake =====
  if (errorBox) {
    errorBox.style.animation = "rhShake 420ms ease";
  }

  // ===== 5) Glow follow cursor inside login card =====
  if (card && !$("#rhGlow")) {
    const glow = document.createElement("div");
    glow.id = "rhGlow";
    glow.style.position = "absolute";
    glow.style.inset = "0";
    glow.style.pointerEvents = "none";
    glow.style.borderRadius = "22px";
    glow.style.opacity = "0";
    glow.style.transition = "opacity 180ms ease";
    card.style.position = "relative";
    card.appendChild(glow);

    const onMove = (e) => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      glow.style.opacity = "1";
      glow.style.background = `radial-gradient(240px 240px at ${x}px ${y}px,
        rgba(59,130,246,0.18),
        transparent 62%)`;
    };

    const onLeave = () => {
      glow.style.opacity = "0";
    };

    card.addEventListener("mousemove", onMove);
    card.addEventListener("mouseleave", onLeave);
  }

  // ===== 6) Parallax on left brand (desktop only) =====
  if (brand && window.matchMedia("(min-width: 981px)").matches) {
    const brandCard = $(".brand-card", brand);
    const brandTop = $(".brand-top", brand);

    const clamp = (n, min, max) => Math.max(min, Math.min(max, n));

    const onMove = (e) => {
      const rect = brand.getBoundingClientRect();
      const px = (e.clientX - rect.left) / rect.width;
      const py = (e.clientY - rect.top) / rect.height;

      const tx = clamp((px - 0.5) * 14, -10, 10);
      const ty = clamp((py - 0.5) * 14, -10, 10);

      if (brandTop) {
        brandTop.style.transform = `translate(${tx * 0.35}px, ${ty * 0.35}px)`;
        brandTop.style.transition = "transform 40ms linear";
      }
      if (brandCard) {
        brandCard.style.transform = `translate(${tx}px, ${ty}px)`;
        brandCard.style.transition = "transform 40ms linear";
      }
    };

    const onLeave = () => {
      if (brandTop) brandTop.style.transform = "";
      if (brandCard) brandCard.style.transform = "";
    };

    brand.addEventListener("mousemove", onMove);
    brand.addEventListener("mouseleave", onLeave);
  }

  // ===== 7) Floating blobs (panel background) =====
  if (panel && !$("#rhBlobs")) {
    const blobsWrap = document.createElement("div");
    blobsWrap.id = "rhBlobs";
    blobsWrap.style.position = "absolute";
    blobsWrap.style.inset = "0";
    blobsWrap.style.pointerEvents = "none";
    blobsWrap.style.overflow = "hidden";

    panel.style.position = "relative";
    panel.appendChild(blobsWrap);

    const blobs = [
      { cls: "rh-blob b1", top: "10%", left: "8%", dur: "12s" },
      { cls: "rh-blob b2", top: "62%", left: "16%", dur: "14s" },
      { cls: "rh-blob b3", top: "28%", left: "72%", dur: "13s" },
    ];

    blobs.forEach((b) => {
      const el = document.createElement("div");
      el.className = b.cls;
      el.style.top = b.top;
      el.style.left = b.left;
      el.style.animationDuration = b.dur;
      blobsWrap.appendChild(el);
    });
  }
})();
