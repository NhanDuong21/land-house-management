// ===== Manage Accounts JS (realtime search + toggle status + reset password modal) =====
(function () {
  const ctxPath = window.MA_CTX || "";

  /* ================= HELPERS ================= */
  function animatePulse(el, className, duration) {
    if (!el) return;
    el.classList.remove(className);
    void el.offsetWidth;
    el.classList.add(className);

    setTimeout(() => {
      el.classList.remove(className);
    }, duration || 800);
  }

  function setLoadingButton(btn, loadingText) {
    if (!btn) return () => {};
    const oldHtml = btn.innerHTML;
    btn.disabled = true;
    btn.dataset.loading = "1";
    btn.innerHTML =
      '<i class="bi bi-arrow-repeat" style="animation:maSpin .8s linear infinite;"></i> ' +
      (loadingText || "Loading...");

    return function restore() {
      btn.disabled = false;
      btn.dataset.loading = "";
      btn.innerHTML = oldHtml;
    };
  }

  function injectSpinKeyframes() {
    if (document.getElementById("maSpinStyle")) return;
    const style = document.createElement("style");
    style.id = "maSpinStyle";
    style.textContent = `
      @keyframes maSpin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
      }
      .ma-row-highlight {
        animation: maRowHighlight .9s ease;
      }
      @keyframes maRowHighlight {
        0% { box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.00); }
        35% { box-shadow: 0 0 0 8px rgba(37, 99, 235, 0.08); }
        100% { box-shadow: 0 0 0 0 rgba(37, 99, 235, 0.00); }
      }
    `;
    document.head.appendChild(style);
  }

  injectSpinKeyframes();

  /* ================= REALTIME SEARCH ================= */
  (function () {
    const form = document.getElementById("maSearchForm");
    const keyword = document.getElementById("maKeyword");
    const role = document.getElementById("maRole");
    let timer = null;

    function debounceSubmit() {
      if (timer) clearTimeout(timer);
      timer = setTimeout(() => {
        if (form) form.submit();
      }, 350);
    }

    if (keyword) keyword.addEventListener("input", debounceSubmit);
    if (role) role.addEventListener("change", () => form && form.submit());
  })();

  /* ================= INITIAL STAGGER / MICRO FX ================= */
  (function () {
    const rows = document.querySelectorAll(".ma-table tbody tr.ma-row-reveal");
    rows.forEach((row, index) => {
      row.style.setProperty("--row-delay", `${index * 55}ms`);
    });
  })();

  /* ================= TOGGLE STATUS (confirm modal + fetch) ================= */
  (function () {
    let _id = null;
    let _type = null;
    let _status = null;

    const modal = document.getElementById("maToggleModal");
    if (!modal) return;

    const msgEl = document.getElementById("maToggleMsg");
    const subEl = document.getElementById("maToggleSub");
    const confirmBtn = document.getElementById("maToggleConfirm");
    const cancelBtn = document.getElementById("maToggleCancel");
    const closeBtn = document.getElementById("maToggleClose");
    const backdrop = document.getElementById("maToggleBackdrop");

    function getNextStatus(type, currentStatus) {
      const accType = (type || "").toUpperCase();
      const status = (currentStatus || "").toUpperCase();

      if (accType === "TENANT") {
        return status === "ACTIVE" ? "LOCKED" : "ACTIVE";
      }

      return status === "ACTIVE" ? "INACTIVE" : "ACTIVE";
    }

    function getStatusLabel(type, status) {
      const accType = (type || "").toUpperCase();
      const s = (status || "").toUpperCase();

      if (s === "ACTIVE") {
        return '<i class="bi bi-unlock-fill"></i> Active';
      }

      if (accType === "TENANT") {
        return '<i class="bi bi-lock-fill"></i> Locked';
      }

      return '<i class="bi bi-slash-circle-fill"></i> Inactive';
    }

    function openModal(btn) {
      _id = btn.dataset.accountId;
      _type = btn.dataset.accountType;
      _status = btn.dataset.currentStatus;

      const name = btn.dataset.fullname || "this account";
      const nextStatus = getNextStatus(_type, _status);

      if (subEl) subEl.textContent = `${name} (${_type})`;

      if (msgEl) {
        msgEl.innerHTML = `Do you really want to change status from <strong>${_status}</strong> to <strong>${nextStatus}</strong>?`;
      }

      modal.style.display = "flex";
      modal.setAttribute("aria-hidden", "false");
      document.body.style.overflow = "hidden";
    }

    function closeModal() {
      modal.style.display = "none";
      modal.setAttribute("aria-hidden", "true");
      document.body.style.overflow = "";
    }

    function showToast(msg, type) {
      const t = document.getElementById("maToast");
      if (!t) return;

      t.className = "ma-toast toast-" + type;
      t.innerHTML =
        (type === "success"
          ? '<i class="bi bi-check-circle-fill"></i>'
          : '<i class="bi bi-x-circle-fill"></i>') +
        " " +
        msg;

      t.style.display = "flex";

      clearTimeout(t._tid);
      t._tid = setTimeout(() => {
        t.style.opacity = "0";
        t.style.transform = "translateY(-8px)";
        setTimeout(() => {
          t.style.display = "none";
          t.style.opacity = "";
          t.style.transform = "";
        }, 220);
      }, 4000);
    }

    function applyUI(type, id, newStatus) {
      const key = type + "-" + id;
      const badge = document.getElementById("statusBadge-" + key);
      const btn = document.getElementById("toggleBtn-" + key);
      const row = btn ? btn.closest("tr") : null;

      if (badge) {
        badge.className = "ma-badge status-" + newStatus.toLowerCase();
        badge.textContent = newStatus;
        animatePulse(badge, "ma-badge-flash", 850);
      }

      if (btn) {
        const isActive = newStatus.toUpperCase() === "ACTIVE";
        btn.classList.toggle("on", isActive);
        btn.classList.toggle("off", !isActive);
        btn.dataset.currentStatus = newStatus;

        const lbl = btn.querySelector(".ma-switch-label");
        if (lbl) {
          lbl.innerHTML = getStatusLabel(type, newStatus);
        }

        animatePulse(btn, "is-bouncing", 600);
      }

      if (row) {
        animatePulse(row, "ma-row-highlight", 900);
      }
    }

    if (confirmBtn) {
      confirmBtn.addEventListener("click", function () {
        const restoreBtn = setLoadingButton(confirmBtn, "Updating...");
        const oldStatus = _status;

        const params = new URLSearchParams();
        params.append("action", "toggle-status");
        params.append("accountId", _id);
        params.append("accountType", _type);
        params.append("currentStatus", _status);

        fetch(ctxPath + "/admin/accounts", {
          method: "POST",
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: params.toString(),
        })
          .then(function (res) {
            return res.json();
          })
          .then(function (data) {
            restoreBtn();
            closeModal();

            if (data && data.ok) {
              const newStatus = getNextStatus(_type, oldStatus);
              applyUI(_type, _id, newStatus);
              _status = newStatus;

              showToast(
                data.message || "Status updated successfully.",
                "success",
              );
            } else {
              showToast(
                (data && data.message) || "Failed to update status.",
                "error",
              );
            }
          })
          .catch(function () {
            restoreBtn();
            closeModal();
            showToast("Network error. Please try again.", "error");
          });
      });
    }

    document.querySelectorAll(".ma-open-toggle").forEach(function (btn) {
      btn.addEventListener("click", function () {
        openModal(btn);
      });
    });

    if (closeBtn) closeBtn.addEventListener("click", closeModal);
    if (cancelBtn) cancelBtn.addEventListener("click", closeModal);
    if (backdrop) backdrop.addEventListener("click", closeModal);

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") closeModal();
    });
  })();

  /* ================= RESET PASSWORD MODAL (AJAX) ================= */
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

    function setInputsType(type) {
      if (newPass) newPass.type = type;
      if (confirmPass) confirmPass.type = type;
    }

    function openModal(btn) {
      lastFocused = document.activeElement;

      const accountId = (btn.dataset.accountId || "").trim();
      const accountType = (btn.dataset.accountType || "").trim();
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

    function mapErr(code) {
      const m = {
        NO_PERMISSION: "Bạn không có quyền thao tác.",
        PASSWORD_REQUIRED: "Vui lòng nhập mật khẩu.",
        CONFIRM_MISMATCH: "Xác nhận mật khẩu không khớp.",
        PASSWORD_MINLEN: "Mật khẩu tối thiểu 6 ký tự.",
        TENANT_NOT_FOUND: "Không tìm thấy tenant.",
        MANAGER_NOT_FOUND: "Không tìm thấy manager.",
        INVALID_TYPE: "Loại tài khoản không hợp lệ.",
        RESET_FAILED: "Reset thất bại, vui lòng thử lại.",
      };
      return m[code] || code || "Có lỗi xảy ra.";
    }

    document.addEventListener("click", (e) => {
      const btn = e.target.closest(".ma-open-pass");
      if (btn) {
        e.preventDefault();
        openModal(btn);
        return;
      }

      const closeTarget = e.target.closest("[data-close='1']");
      if (closeTarget && modal.classList.contains("is-open")) {
        e.preventDefault();
        closeModal();
      }
    });

    if (closeBtn) {
      closeBtn.addEventListener("click", (e) => {
        e.preventDefault();
        closeModal();
      });
    }

    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape" && modal.classList.contains("is-open")) {
        closeModal();
      }
    });

    if (showPass) {
      showPass.addEventListener("change", () => {
        setInputsType(showPass.checked ? "text" : "password");
      });
    }

    if (form) {
      form.addEventListener("submit", async (e) => {
        e.preventDefault();

        const p1 = (newPass?.value || "").trim();
        const p2 = (confirmPass?.value || "").trim();

        if (p1.length < 6) {
          if (errorBox)
            errorBox.textContent = "Password must be at least 6 characters.";
          newPass && newPass.focus();
          return;
        }

        if (p1 !== p2) {
          if (errorBox)
            errorBox.textContent = "Confirm password does not match.";
          confirmPass && confirmPass.focus();
          return;
        }

        if (errorBox) errorBox.textContent = "";

        const params = new URLSearchParams(new FormData(form));
        const submitBtn = form.querySelector("button[type='submit']");
        const restoreBtn = setLoadingButton(submitBtn, "Updating...");

        try {
          const res = await fetch(form.action, {
            method: "POST",
            body: params,
            headers: {
              "X-Requested-With": "XMLHttpRequest",
              Accept: "application/json",
              "Content-Type":
                "application/x-www-form-urlencoded; charset=UTF-8",
            },
          });

          const data = await res.json().catch(() => null);

          if (!res.ok || !data || !data.ok) {
            restoreBtn();
            const msg = data && data.message ? data.message : "RESET_FAILED";
            if (errorBox) errorBox.textContent = mapErr(msg);
            return;
          }

          if (errorBox) errorBox.textContent = "";
          if (sub) sub.textContent = "Reset password thành công";
          showGlobalToast("Password updated successfully.", "success");

          setTimeout(() => {
            restoreBtn();
            closeModal();
            window.location.reload();
          }, 700);
        } catch (err) {
          restoreBtn();
          if (errorBox)
            errorBox.textContent = "Network error. Please try again.";
        }
      });
    }

    function showGlobalToast(msg, type) {
      const t = document.getElementById("maToast");
      if (!t) return;

      t.className = "ma-toast toast-" + type;
      t.innerHTML =
        (type === "success"
          ? '<i class="bi bi-check-circle-fill"></i>'
          : '<i class="bi bi-x-circle-fill"></i>') +
        " " +
        msg;

      t.style.display = "flex";

      clearTimeout(t._tid);
      t._tid = setTimeout(() => {
        t.style.opacity = "0";
        t.style.transform = "translateY(-8px)";
        setTimeout(() => {
          t.style.display = "none";
          t.style.opacity = "";
          t.style.transform = "";
        }, 220);
      }, 3500);
    }
  })();

  /* ===== AUTO HIDE SUCCESS ALERT ===== */
  (function () {
    const alert = document.getElementById("successAlert");
    if (!alert) return;

    setTimeout(() => {
      alert.style.transition = "opacity 0.5s ease, transform 0.5s ease";
      alert.style.opacity = "0";
      alert.style.transform = "translateY(-8px)";

      setTimeout(() => {
        alert.remove();
      }, 500);
    }, 3000);
  })();
})();
