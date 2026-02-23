(() => {
  const form = document.querySelector("form.rhp-form");
  if (!form) return;

  const newPwd = form.querySelector('input[name="newPassword"]');
  const confirmPwd = form.querySelector('input[name="confirmPassword"]');
  const submitBtn = form.querySelector('button[type="submit"]');

  // ===== 1) Prevent double submit =====
  form.addEventListener("submit", () => {
    submitBtn.disabled = true;
    submitBtn.classList.add("disabled");
  });

  // ===== 2) Confirm match validation =====
  const validateMatch = () => {
    if (!newPwd || !confirmPwd) return;
    if (confirmPwd.value && newPwd.value !== confirmPwd.value) {
      confirmPwd.setCustomValidity("Passwords do not match");
    } else {
      confirmPwd.setCustomValidity("");
    }
  };

  newPwd?.addEventListener("input", validateMatch);
  confirmPwd?.addEventListener("input", validateMatch);

  // ===== 3) Show / Hide password =====
  const toggles = document.querySelectorAll(".toggle-password");

  toggles.forEach((btn) => {
    btn.addEventListener("click", () => {
      const input = btn.closest(".input-group").querySelector(".pwd-field");
      const icon = btn.querySelector("i");

      if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
      } else {
        input.type = "password";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
      }
    });
  });
})();
