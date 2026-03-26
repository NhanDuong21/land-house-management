document.addEventListener("DOMContentLoaded", function () {
  function revealOnScroll() {
    const targets = document.querySelectorAll(
      ".tcd-alert, .tcd-card, .tcd-section, .tcd-article, .tcd-pay-card",
    );

    targets.forEach(function (el) {
      if (!el.classList.contains("tcd-reveal")) {
        el.classList.add("tcd-reveal");
      }
    });

    const observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      {
        threshold: 0.12,
        rootMargin: "0px 0px -40px 0px",
      },
    );

    targets.forEach(function (el) {
      observer.observe(el);
    });
  }

  function applyTilt(selector, maxRotate) {
    const elements = document.querySelectorAll(selector);

    elements.forEach(function (el) {
      el.addEventListener("mousemove", function (e) {
        const rect = el.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const rx = (y / rect.height - 0.5) * -maxRotate;
        const ry = (x / rect.width - 0.5) * maxRotate;

        el.style.transform =
          "perspective(900px) rotateX(" +
          rx +
          "deg) rotateY(" +
          ry +
          "deg) translateY(-2px)";
      });

      el.addEventListener("mouseleave", function () {
        el.style.transform = "";
      });
    });
  }

  function enhanceQr() {
    const qrBoxes = document.querySelectorAll(".tcd-qr-box");

    qrBoxes.forEach(function (box) {
      const img = box.querySelector(".tcd-qr-img");
      if (!img) return;

      box.addEventListener("mousemove", function (e) {
        const rect = box.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;

        const moveX = (x / rect.width - 0.5) * 10;
        const moveY = (y / rect.height - 0.5) * 10;

        img.style.transform =
          "scale(1.08) translate(" + moveX + "px, " + moveY + "px)";
      });

      box.addEventListener("mouseleave", function () {
        img.style.transform = "";
      });
    });
  }

  function enhanceButtons() {
    const buttons = document.querySelectorAll(".tcd-btn, .tcd-link-btn");

    buttons.forEach(function (button) {
      button.addEventListener("click", function (e) {
        if (button.classList.contains("tcd-link-btn")) return;

        const ripple = document.createElement("span");
        const rect = button.getBoundingClientRect();
        const size = Math.max(rect.width, rect.height);

        ripple.style.position = "absolute";
        ripple.style.width = size + "px";
        ripple.style.height = size + "px";
        ripple.style.left = e.clientX - rect.left - size / 2 + "px";
        ripple.style.top = e.clientY - rect.top - size / 2 + "px";
        ripple.style.borderRadius = "50%";
        ripple.style.pointerEvents = "none";
        ripple.style.background = "rgba(255,255,255,0.28)";
        ripple.style.transform = "scale(0)";
        ripple.style.opacity = "1";
        ripple.style.transition = "transform 500ms ease, opacity 500ms ease";

        button.appendChild(ripple);

        requestAnimationFrame(function () {
          ripple.style.transform = "scale(2.4)";
          ripple.style.opacity = "0";
        });

        setTimeout(function () {
          ripple.remove();
        }, 520);
      });
    });
  }

  function animateLinesSequentially() {
    const lines = document.querySelectorAll(".tcd-line");
    lines.forEach(function (line, index) {
      line.style.opacity = "0";
      line.style.transform = "translateY(10px)";
      line.style.transition =
        "opacity 500ms ease, transform 500ms cubic-bezier(0.22, 1, 0.36, 1)";
      line.style.transitionDelay = Math.min(index * 18, 260) + "ms";
    });

    requestAnimationFrame(function () {
      lines.forEach(function (line) {
        line.style.opacity = "1";
        line.style.transform = "translateY(0)";
      });
    });
  }

  function addStatusPulse() {
    const badge = document.querySelector(
      ".tcd-badge.pending, .tcd-badge.active",
    );
    if (!badge) return;

    if (badge.classList.contains("pending")) {
      badge.animate(
        [
          { boxShadow: "0 0 0 0 rgba(245, 158, 11, 0.28)" },
          { boxShadow: "0 0 0 10px rgba(245, 158, 11, 0)" },
        ],
        {
          duration: 1800,
          iterations: Infinity,
        },
      );
    }

    if (badge.classList.contains("active")) {
      badge.animate(
        [
          { transform: "translateY(0)" },
          { transform: "translateY(-1px)" },
          { transform: "translateY(0)" },
        ],
        {
          duration: 1600,
          iterations: Infinity,
        },
      );
    }
  }

  revealOnScroll();
  applyTilt(".tcd-section, .tcd-pay-card", 3);
  enhanceQr();
  enhanceButtons();
  animateLinesSequentially();
  addStatusPulse();
});
