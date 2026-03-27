document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("updateManageForm");
  const card = document.querySelector(".update-card");
  const submitBtn = document.getElementById("submitBtn");
  const staggerItems = document.querySelectorAll(".stagger-item");
  const magneticButtons = document.querySelectorAll(".magnetic-btn");
  const fieldInputs = document.querySelectorAll(
    ".input-shell input, .input-shell select",
  );

  if (!form) return;

  // Stagger animation delay
  staggerItems.forEach((item, index) => {
    item.style.animationDelay = `${0.08 * (index + 1)}s`;
  });

  // Focus micro interaction
  fieldInputs.forEach((el) => {
    el.addEventListener("focus", () => {
      const group = el.closest(".form-group");
      if (group) {
        group.style.transform = "translateY(-2px)";
      }
    });

    el.addEventListener("blur", () => {
      const group = el.closest(".form-group");
      if (group) {
        group.style.transform = "";
      }
    });
  });

  // Ripple effect
  function createRipple(event, element) {
    const ripple = document.createElement("span");
    ripple.classList.add("ripple");

    const rect = element.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);

    ripple.style.width = ripple.style.height = `${size}px`;
    ripple.style.left = `${event.clientX - rect.left - size / 2}px`;
    ripple.style.top = `${event.clientY - rect.top - size / 2}px`;

    element.appendChild(ripple);

    setTimeout(() => {
      ripple.remove();
    }, 650);
  }

  magneticButtons.forEach((btn) => {
    btn.addEventListener("click", function (e) {
      createRipple(e, this);
    });
  });

  // Magnetic hover
  magneticButtons.forEach((btn) => {
    btn.addEventListener("mousemove", function (e) {
      const rect = this.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;

      this.style.transform = `translate(${x * 0.08}px, ${y * 0.08}px)`;
    });

    btn.addEventListener("mouseleave", function () {
      this.style.transform = "";
    });
  });

  // 3D card tilt
  if (card) {
    card.addEventListener("mousemove", function (e) {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const rotateY = (x / rect.width - 0.5) * 4;
      const rotateX = (y / rect.height - 0.5) * -4;

      card.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
    });

    card.addEventListener("mouseleave", function () {
      card.style.transform = "";
    });
  }

  // Submit loading animation only, no backend logic changed
  form.addEventListener("submit", function () {
    if (!submitBtn) return;
    submitBtn.classList.add("loading");
    submitBtn.disabled = true;

    setTimeout(() => {
      submitBtn.disabled = false;
      submitBtn.classList.remove("loading");
    }, 3000);
  });
});
