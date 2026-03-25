(function () {
  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) =>
    Array.from(root.querySelectorAll(selector));

  const form = $("#createMaintenanceForm");
  if (!form) return;

  const description = $("#cmDescription");
  const descHint = $("#cmDescHint");
  const descCount = $("#cmDescCount");
  const fileInput = $("#cmImages");
  const fileInfo = $("#cmFileInfo");
  const preview = $("#cmPreview");
  const submitBtn = $("#cmSubmitBtn");

  // =========================
  // Reveal animation
  // =========================
  const revealEls = $$(".cm-reveal");
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
  // Ripple effect
  // =========================
  const attachRipple = (element) => {
    if (!element) return;

    element.addEventListener("click", (e) => {
      const rect = element.getBoundingClientRect();
      const ripple = document.createElement("span");
      const size = Math.max(rect.width, rect.height);

      ripple.className = "cm-ripple-wave";
      ripple.style.width = `${size}px`;
      ripple.style.height = `${size}px`;
      ripple.style.left = `${e.clientX - rect.left - size / 2}px`;
      ripple.style.top = `${e.clientY - rect.top - size / 2}px`;

      element.appendChild(ripple);
      window.setTimeout(() => ripple.remove(), 700);
    });
  };

  $$(".cm-ripple, .category-label").forEach(attachRipple);

  // =========================
  // Description counter
  // =========================
  const updateDescriptionState = () => {
    if (!description) return;

    const len = description.value.trim().length;
    descCount.textContent = `${len}`;

    descCount.classList.remove("is-warn", "is-error");
    descHint.classList.remove("is-error");

    if (len > 160) {
      descCount.classList.add("is-warn");
    }

    if (len === 0) {
      descHint.textContent = "Description is required.";
      descHint.classList.add("is-error");
    } else if (len < 8) {
      descHint.textContent = "Try to describe the issue a bit more clearly.";
    } else {
      descHint.textContent = "Looks good.";
    }
  };

  description?.addEventListener("input", updateDescriptionState);
  updateDescriptionState();

  // =========================
  // File preview + max 3 soft limit
  // =========================
  const renderPreview = (files) => {
    preview.innerHTML = "";

    if (!files.length) {
      fileInfo.textContent = "No files selected";
      return;
    }

    fileInfo.textContent = `${files.length} file(s) selected`;

    files.forEach((file) => {
      if (!file.type.startsWith("image/")) return;

      const item = document.createElement("div");
      item.className = "cm-preview-item";

      const img = document.createElement("img");
      img.alt = file.name;

      const reader = new FileReader();
      reader.onload = (e) => {
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);

      item.appendChild(img);
      preview.appendChild(item);
    });
  };

  fileInput?.addEventListener("change", () => {
    const files = Array.from(fileInput.files || []);

    if (files.length > 3) {
      fileInput.value = "";
      preview.innerHTML = "";
      fileInfo.textContent = "You can upload a maximum of 3 images.";
      fileInfo.style.color = "#dc2626";
      form.classList.remove("cm-shake");
      void form.offsetWidth;
      form.classList.add("cm-shake");
      return;
    }

    fileInfo.style.color = "";
    renderPreview(files);
  });

  // =========================
  // Submit loading
  // =========================
  form.addEventListener("submit", (e) => {
    const descValue = description ? description.value.trim() : "";

    if (!descValue) {
      e.preventDefault();
      description?.focus();
      descHint.textContent = "Description is required.";
      descHint.classList.add("is-error");

      form.classList.remove("cm-shake");
      void form.offsetWidth;
      form.classList.add("cm-shake");
      return;
    }

    if (submitBtn.dataset.loading === "true") {
      e.preventDefault();
      return;
    }

    submitBtn.dataset.loading = "true";
    submitBtn.classList.add("is-loading");

    const content = $(".cm-btn-content", submitBtn);
    if (content) {
      submitBtn.dataset.originalText = content.innerHTML;
      content.innerHTML = `<span class="cm-spinner"></span> Submitting...`;
    }
  });
})();
