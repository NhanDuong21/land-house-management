(function () {
  const modal = document.getElementById("maPassModal");
  if (!modal) return;

  const sub = document.getElementById("maPassSub");

  const hiddenId = document.getElementById("maPassAccountId");
  const hiddenType = document.getElementById("maPassAccountType");

  const newPass = document.getElementById("maNewPass");
  const confirmPass = document.getElementById("maConfirmPass");
  const showPass = document.getElementById("maShowPass");
  const errorBox = document.getElementById("maPassError");
  const closeBtn = document.getElementById("maPassClose");

  const form = document.getElementById("maPassForm");

  let lastFocused = null;

  function openModal(btn) {
    lastFocused = document.activeElement;

    const accountId = btn.dataset.accountId || "";
    const accountType = btn.dataset.accountType || "";
    const fullName = btn.dataset.fullname || "User";
    const email = btn.dataset.email || "";

    if (sub) sub.textContent = email ? `${fullName} • ${email}` : fullName;
    if (hiddenId) hiddenId.value = accountId;
    if (hiddenType) hiddenType.value = accountType;

    if (newPass) newPass.value = "";
    if (confirmPass) confirmPass.value = "";
    if (errorBox) errorBox.textContent = "";
    if (showPass) showPass.checked = false;
    setInputsType("password");

    modal.classList.add("is-open");
    modal.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";

    setTimeout(() => newPass && newPass.focus(), 0);
  }

  function closeModal() {
    modal.classList.remove("is-open");
    modal.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";

    if (lastFocused && typeof lastFocused.focus === "function") {
      lastFocused.focus();
    }
  }

  function setInputsType(type) {
    if (newPass) newPass.type = type;
    if (confirmPass) confirmPass.type = type;
  }

  // Open buttons
  document.addEventListener("click", (e) => {
    const btn = e.target.closest(".ma-open-pass");
    if (btn) {
      e.preventDefault();
      openModal(btn);
      return;
    }

    // close via backdrop / cancel button
    const closeTarget = e.target.closest("[data-close='1']");
    if (closeTarget && modal.classList.contains("is-open")) {
      e.preventDefault();
      closeModal();
    }
  });

  // Close via X
  if (closeBtn) {
    closeBtn.addEventListener("click", (e) => {
      e.preventDefault();
      closeModal();
    });
  }

  // ESC close
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && modal.classList.contains("is-open")) {
      closeModal();
    }
  });

  // Show/Hide passwords
  if (showPass) {
    showPass.addEventListener("change", () => {
      setInputsType(showPass.checked ? "text" : "password");
    });
  }

  // Simple client validation (frontend only)
  if (form) {
    form.addEventListener("submit", (e) => {
      if (!newPass || !confirmPass) return;

      const p1 = (newPass.value || "").trim();
      const p2 = (confirmPass.value || "").trim();

      if (p1.length < 8) {
        e.preventDefault();
        if (errorBox)
          errorBox.textContent = "Password must be at least 8 characters.";
        newPass.focus();
        return;
      }

      if (p1 !== p2) {
        e.preventDefault();
        if (errorBox) errorBox.textContent = "Confirm password does not match.";
        confirmPass.focus();
        return;
      }
    });
  }
})();
