(() => {
  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) => [
    ...root.querySelectorAll(selector),
  ];

  // =========================
  // 1) Reveal on load
  // =========================
  const revealEls = $$(".rhp-reveal");
  const revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          revealObserver.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.12 },
  );

  revealEls.forEach((el, index) => {
    el.style.transitionDelay = `${Math.min(index * 60, 420)}ms`;
    revealObserver.observe(el);
  });

  // =========================
  // 2) Strong alert animation
  // =========================
  $$(".rhp-alert").forEach((alert, index) => {
    alert.style.animationDelay = `${index * 120}ms`;
    alert.classList.add("rhp-alert-show");
  });

  // =========================
  // 3) Tilt card effect
  // =========================
  $$(".rhp-tilt-card").forEach((card) => {
    let rafId = null;

    const reset = () => {
      card.style.transform = "";
    };

    card.addEventListener("mousemove", (e) => {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const rotateY = (x / rect.width - 0.5) * 8;
      const rotateX = (y / rect.height - 0.5) * -8;

      cancelAnimationFrame(rafId);
      rafId = requestAnimationFrame(() => {
        card.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateY(-4px)`;
      });
    });

    card.addEventListener("mouseleave", reset);
    card.addEventListener("blur", reset, true);
  });

  // =========================
  // 4) Ripple button
  // =========================
  $$(".rhp-ripple-btn").forEach((btn) => {
    btn.addEventListener("click", (e) => {
      const ripple = document.createElement("span");
      ripple.className = "rhp-ripple";

      const rect = btn.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);

      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;

      btn.appendChild(ripple);

      setTimeout(() => ripple.remove(), 700);
    });
  });

  // =========================
  // 5) Input focus active wrapper
  // =========================
  $$(".rhp-input").forEach((input) => {
    input.addEventListener("focus", () => {
      input
        .closest(".rhp-input-group, .col-12, .col-md-6")
        ?.classList.add("is-focused");
    });

    input.addEventListener("blur", () => {
      input
        .closest(".rhp-input-group, .col-12, .col-md-6")
        ?.classList.remove("is-focused");
    });
  });

  // =========================
  // 6) Enhanced submit (prevent double submit)
  // =========================
  $$(".rhp-enhanced-submit").forEach((form) => {
    form.addEventListener("submit", (e) => {
      const submitBtn =
        form.querySelector('button[type="submit"]') ||
        document.querySelector(`button[form="${form.id}"]`);

      if (!submitBtn) return;

      if (!form.checkValidity()) {
        e.preventDefault();
        form.classList.remove("rhp-shake");
        void form.offsetWidth;
        form.classList.add("rhp-shake");
        return;
      }

      if (submitBtn.dataset.submitting === "true") {
        e.preventDefault();
        return;
      }

      submitBtn.dataset.submitting = "true";
      submitBtn.disabled = true;
      submitBtn.classList.add("is-loading");

      const text = submitBtn.querySelector(".rhp-btn-text");
      if (text) {
        submitBtn.dataset.originalText = text.innerHTML;
        text.innerHTML = `<span class="rhp-spinner"></span> Processing...`;
      }
    });
  });

  // =========================
  // 7) Password features
  // =========================
  const pwdForm = $("form.rhp-form");
  if (pwdForm) {
    const oldPwd = $('input[name="old_password"]', pwdForm);
    const newPwd = $('input[name="new_password"]', pwdForm);
    const confirmPwd = $('input[name="confirm_password"]', pwdForm);
    const strengthFill = $("#passwordStrengthFill");
    const strengthText = $("#passwordStrengthText");
    const matchText = $("#passwordMatchText");

    const calcStrength = (value) => {
      let score = 0;
      if (!value) return { score: 0, label: "-" };
      if (value.length >= 6) score += 1;
      if (value.length >= 10) score += 1;
      if (/[A-Z]/.test(value)) score += 1;
      if (/[a-z]/.test(value)) score += 1;
      if (/[0-9]/.test(value)) score += 1;
      if (/[^A-Za-z0-9]/.test(value)) score += 1;

      if (score <= 2) return { score: 25, label: "Weak" };
      if (score <= 4) return { score: 55, label: "Medium" };
      if (score === 5) return { score: 78, label: "Strong" };
      return { score: 100, label: "Very strong" };
    };

    const validateMatch = () => {
      if (!newPwd || !confirmPwd) return true;

      if (confirmPwd.value && newPwd.value !== confirmPwd.value) {
        confirmPwd.setCustomValidity("Passwords do not match");
        confirmPwd.classList.add("is-invalid");
        matchText.textContent = "Passwords do not match";
        matchText.className = "rhp-helper-text is-error";
        return false;
      }

      confirmPwd.setCustomValidity("");
      confirmPwd.classList.remove("is-invalid");

      if (confirmPwd.value && newPwd.value === confirmPwd.value) {
        matchText.textContent = "Passwords match";
        matchText.className = "rhp-helper-text is-success";
      } else {
        matchText.textContent = "";
        matchText.className = "rhp-helper-text";
      }

      return true;
    };

    const updateStrength = () => {
      const { score, label } = calcStrength(newPwd?.value || "");
      if (strengthFill) strengthFill.style.width = `${score}%`;
      if (strengthText) strengthText.textContent = `Strength: ${label}`;

      const wrapper = strengthFill?.parentElement;
      if (wrapper) {
        wrapper.dataset.level =
          score <= 25
            ? "weak"
            : score <= 55
              ? "medium"
              : score < 100
                ? "strong"
                : "very-strong";
      }
    };

    newPwd?.addEventListener("input", () => {
      updateStrength();
      validateMatch();
    });

    confirmPwd?.addEventListener("input", validateMatch);
    oldPwd?.addEventListener("input", () =>
      oldPwd.classList.remove("is-invalid"),
    );

    pwdForm.addEventListener("submit", (e) => {
      const isMatch = validateMatch();

      if (!pwdForm.checkValidity() || !isMatch) {
        e.preventDefault();
        pwdForm.classList.remove("rhp-shake");
        void pwdForm.offsetWidth;
        pwdForm.classList.add("rhp-shake");

        const firstInvalid = pwdForm.querySelector(":invalid");
        firstInvalid?.focus();
      }
    });

    updateStrength();
    validateMatch();
  }

  // =========================
  // 8) Show / Hide password
  // =========================
  $$(".toggle-password").forEach((btn) => {
    btn.addEventListener("click", () => {
      const input = btn.closest(".input-group")?.querySelector(".pwd-field");
      const icon = btn.querySelector("i");
      if (!input || !icon) return;

      const isPassword = input.type === "password";
      input.type = isPassword ? "text" : "password";

      icon.classList.toggle("bi-eye", !isPassword);
      icon.classList.toggle("bi-eye-slash", isPassword);

      btn.classList.remove("rhp-pop");
      void btn.offsetWidth;
      btn.classList.add("rhp-pop");
    });
  });

  // =========================
  // 9) Parallax header glow
  // =========================
  const wrap = $(".rhp-wrap");
  const header = $(".rhp-header");
  if (wrap && header) {
    wrap.addEventListener("mousemove", (e) => {
      const rect = wrap.getBoundingClientRect();
      const x = ((e.clientX - rect.left) / rect.width) * 100;
      const y = ((e.clientY - rect.top) / rect.height) * 100;
      header.style.setProperty("--mx", `${x}%`);
      header.style.setProperty("--my", `${y}%`);
    });
  }
})();
