(function () {
  "use strict";

  const cfg = window.MANAGER_TENANT_CONFIG || {};
  const ctx = cfg.ctx || "";

  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

  function safeText(v) {
    return v == null ? "" : String(v);
  }

  function addRipple(e) {
    const btn = e.currentTarget;
    if (!btn) return;

    const oldRipple = btn.querySelector(".mt-ripple");
    if (oldRipple) oldRipple.remove();

    const circle = document.createElement("span");
    const rect = btn.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);

    circle.className = "mt-ripple";
    circle.style.width = size + "px";
    circle.style.height = size + "px";
    circle.style.left = e.clientX - rect.left - size / 2 + "px";
    circle.style.top = e.clientY - rect.top - size / 2 + "px";

    btn.appendChild(circle);
    circle.addEventListener("animationend", () => circle.remove(), {
      once: true,
    });
  }

  function attachRipple(selector) {
    $$(selector).forEach((el) => {
      el.addEventListener("click", addRipple);
    });
  }

  function openOverlay(overlay, displayMode) {
    if (!overlay) return;
    overlay.style.display = displayMode || "flex";
    overlay.setAttribute("aria-hidden", "false");

    requestAnimationFrame(() => {
      overlay.classList.add("mt-open");
      overlay.classList.add("is-open");
    });
  }

  function closeOverlay(overlay) {
    if (!overlay) return;
    overlay.classList.remove("mt-open");
    overlay.classList.remove("is-open");
    overlay.setAttribute("aria-hidden", "true");

    const finish = () => {
      overlay.style.display = "none";
    };

    setTimeout(finish, 320);
  }

  function showToast(message, title) {
    const toast = $("#errorToast");
    const msg = $("#toastMessage");
    const titleNode = toast ? toast.querySelector(".toast-title") : null;

    if (!toast || !msg) return;

    msg.textContent = message || "Something went wrong.";
    if (titleNode && title) titleNode.textContent = title;

    toast.classList.remove("show");
    void toast.offsetWidth;
    toast.classList.add("show");
    toast.setAttribute("aria-hidden", "false");

    clearTimeout(toast._timer);
    toast._timer = setTimeout(() => {
      toast.classList.remove("show");
      toast.setAttribute("aria-hidden", "true");
    }, 4600);
  }

  function shake(el) {
    if (!el) return;
    el.classList.remove("mt-shake");
    void el.offsetWidth;
    el.classList.add("mt-shake");
  }

  function popSuccess(el) {
    if (!el) return;
    el.classList.remove("mt-pop-success");
    void el.offsetWidth;
    el.classList.add("mt-pop-success");
  }

  function assignRowStagger() {
    $$(".mt-table tbody tr").forEach((row, idx) => {
      row.style.animationDelay = Math.min(idx * 0.05, 0.5) + "s";
    });
  }

  const editModal = $("#editModal");
  const confirmDialog = $("#confirmDialog");
  const toggleStatusDialog = $("#toggleStatusDialog");
  const resetPasswordModal = $("#resetPasswordModal");

  const editTenantForm = $("#editTenantForm");
  const openConfirmBtn = $("#openConfirmBtn");
  const confirmSaveBtn = $("#confirmSaveBtn");

  const resetPasswordForm = $("#resetPasswordForm");
  const rpError = $("#rpError");

  const btnOpenResetPassword = $("#btnOpenResetPassword");
  const btnCancelToggle = $("#btnCancelToggle");
  const btnConfirmToggle = $("#btnConfirmToggle");

  const toggleStatusForm = $("#toggleStatusForm");
  const toggleTenantId = $("#toggleTenantId");

  let pendingTenantId = null;

  function initEntranceFx() {
    assignRowStagger();
  }

  function initRipples() {
    attachRipple(
      ".mt-btn, .mt-btn-toggle, .modal-btn-cancel, .modal-btn-save, .modal-btn-reset," +
        ".confirm-btn-cancel, .confirm-btn-ok, .toggle-confirm-cancel, .toggle-confirm-ok," +
        ".rp-btn-cancel, .rp-btn-save, .mt-page-btn, .modal-clear-btn, .toast-close",
    );
  }

  function fillEditModal(btn) {
    const hasRoom = btn.dataset.hasRoom === "true";

    $("#modal_tenantId").value = safeText(btn.dataset.tenantId);
    $("#modal_fullName").value = safeText(btn.dataset.fullname);
    $("#modal_identityCode").value = safeText(btn.dataset.identity);
    $("#modal_phoneNumber").value = safeText(btn.dataset.phone);
    $("#modal_email").value = safeText(btn.dataset.email);
    $("#modal_dateOfBirth").value = safeText(btn.dataset.dob);
    $("#modal_address").value = safeText(btn.dataset.address);

    const g = btn.dataset.gender;
    $("#modal_gender").value =
      g !== undefined && g !== "null" && g !== "" ? g : "";

    const titleNode = $("#editModalTitle");
    const badge = $("#viewOnlyBadge");
    const subtitle = $("#editModalSubtitle");

    if (titleNode && titleNode.childNodes.length > 0) {
      titleNode.childNodes[0].nodeValue = hasRoom
        ? "Edit Tenant Information"
        : "View Tenant Information";
    }

    if (subtitle) {
      subtitle.textContent = hasRoom
        ? "Update tenant details or remove incorrect information"
        : "This tenant has no active contract. Information is read-only.";
    }

    if (badge) badge.style.display = hasRoom ? "none" : "";

    $$("#editTenantForm input:not([type=hidden])").forEach((f) => {
      f.readOnly = !hasRoom;
      f.style.background = hasRoom ? "" : "#f8fafc";
    });

    const gender = $("#modal_gender");
    if (gender) gender.disabled = !hasRoom;

    $$(".js-clear-btn").forEach((b) => {
      b.style.display = hasRoom ? "" : "none";
    });

    if (openConfirmBtn) openConfirmBtn.style.display = hasRoom ? "" : "none";

    if (btnOpenResetPassword) {
      btnOpenResetPassword.style.display = hasRoom ? "" : "none";
      btnOpenResetPassword.dataset.tenantId = safeText(btn.dataset.tenantId);
      btnOpenResetPassword.dataset.tenantName = safeText(btn.dataset.fullname);
    }
  }

  function initEditModal() {
    $$(".js-open-edit").forEach((btn) => {
      btn.addEventListener("click", () => {
        fillEditModal(btn);
        openOverlay(editModal, "flex");
      });
    });

    $$('[data-close="1"]').forEach((btn) => {
      btn.addEventListener("click", function (e) {
        e.preventDefault();
        closeOverlay(editModal);
      });
    });

    if (editModal) {
      editModal.addEventListener("click", (e) => {
        if (e.target === editModal) closeOverlay(editModal);
      });
    }
  }

  function initSaveConfirm() {
    if (openConfirmBtn) {
      openConfirmBtn.addEventListener("click", () => {
        openOverlay(confirmDialog, "flex");
      });
    }

    $$('[data-close-confirm="1"]').forEach((btn) => {
      btn.addEventListener("click", () => closeOverlay(confirmDialog));
    });

    if (confirmDialog) {
      confirmDialog.addEventListener("click", (e) => {
        if (e.target === confirmDialog) closeOverlay(confirmDialog);
      });
    }

    if (confirmSaveBtn && editTenantForm) {
      confirmSaveBtn.addEventListener("click", () => {
        popSuccess(confirmSaveBtn);
        editTenantForm.submit();
      });
    }
  }

  function initClearButtons() {
    $$(".js-clear-btn").forEach((btn) => {
      btn.addEventListener("click", () => {
        const targetId = btn.dataset.clear;
        const selectId = btn.dataset.clearSelect;

        if (targetId) {
          const target = document.getElementById(targetId);
          if (target) {
            target.value = "";
            target.focus();
            shake(target.closest(".modal-field-row"));
          }
        }

        if (selectId) {
          const target = document.getElementById(selectId);
          if (target) {
            target.value = "";
            target.focus();
            shake(target.closest(".modal-field-row"));
          }
        }
      });
    });
  }

  function initResetPassword() {
    if (btnOpenResetPassword) {
      btnOpenResetPassword.addEventListener("click", () => {
        $("#rp_tenantId").value = btnOpenResetPassword.dataset.tenantId || "";
        $("#rpModalSub").textContent =
          "Đặt lại mật khẩu cho: " +
          (btnOpenResetPassword.dataset.tenantName || "");

        $("#rp_newPassword").value = "";
        $("#rp_confirmPassword").value = "";
        rpError.classList.remove("is-show");
        rpError.textContent = "";

        closeOverlay(editModal);
        setTimeout(() => openOverlay(resetPasswordModal, "flex"), 120);
      });
    }

    ["btnCloseResetPassword", "btnCancelResetPassword"].forEach((id) => {
      const node = document.getElementById(id);
      if (!node) return;

      node.addEventListener("click", () => {
        closeOverlay(resetPasswordModal);
        setTimeout(() => openOverlay(editModal, "flex"), 120);
      });
    });

    if (resetPasswordModal) {
      resetPasswordModal.addEventListener("click", (e) => {
        if (e.target === resetPasswordModal) {
          closeOverlay(resetPasswordModal);
          setTimeout(() => openOverlay(editModal, "flex"), 120);
        }
      });
    }

    if (resetPasswordForm) {
      resetPasswordForm.addEventListener("submit", function (e) {
        e.preventDefault();

        const tenantId = $("#rp_tenantId").value;
        const newPwd = $("#rp_newPassword").value;
        const confirmPwd = $("#rp_confirmPassword").value;

        rpError.classList.remove("is-show");
        rpError.textContent = "";

        if (!newPwd || newPwd.length < 6) {
          rpError.textContent = "Mật khẩu phải từ 6 ký tự trở lên.";
          rpError.classList.add("is-show");
          shake($(".rp-modal-box"));
          showToast("Mật khẩu phải từ 6 ký tự trở lên.", "Validation Error");
          return;
        }

        if (newPwd !== confirmPwd) {
          rpError.textContent = "Xác nhận mật khẩu không khớp.";
          rpError.classList.add("is-show");
          shake($(".rp-modal-box"));
          showToast("Xác nhận mật khẩu không khớp.", "Validation Error");
          return;
        }

        const form = document.createElement("form");
        form.method = "POST";
        form.action = ctx + "/manager/tenant/edit";

        const hiddenFields = {
          action: "resetPassword",
          tenantId: tenantId,
          newPassword: newPwd,
          page: cfg.currentPage || "",
          keyword: cfg.keyword || "",
        };

        Object.entries(hiddenFields).forEach(([k, v]) => {
          const inp = document.createElement("input");
          inp.type = "hidden";
          inp.name = k;
          inp.value = v;
          form.appendChild(inp);
        });

        document.body.appendChild(form);
        form.submit();
      });
    }
  }

  function initToggleStatus() {
    $$(".js-toggle-status").forEach((btn) => {
      btn.addEventListener("click", () => {
        const tenantId = btn.dataset.tenantId;
        const tenantName = btn.dataset.tenantName || "Tenant #" + tenantId;
        const current = btn.dataset.currentStatus;
        const toLock = current === "ACTIVE";

        pendingTenantId = tenantId;

        const icon = $("#toggleConfirmIcon");
        const title = $("#toggleConfirmTitle");
        const sub = $("#toggleConfirmSub");
        const okBtn = $("#btnConfirmToggle");

        if (toLock) {
          icon.innerHTML = '<i class="bi bi-lock-fill"></i>';
          icon.className = "toggle-confirm-icon to-lock";
          title.textContent = "Lock Tenant?";
          sub.textContent =
            'Tenant "' + tenantName + '" will be locked and cannot log in.';
          okBtn.className = "toggle-confirm-ok btn-lock";
          okBtn.innerHTML = '<i class="bi bi-lock-fill"></i> Lock';
        } else {
          icon.innerHTML = '<i class="bi bi-unlock-fill"></i>';
          icon.className = "toggle-confirm-icon to-unlock";
          title.textContent = "Activate Tenant?";
          sub.textContent = 'Tenant "' + tenantName + '" will be activated.';
          okBtn.className = "toggle-confirm-ok btn-unlock";
          okBtn.innerHTML = '<i class="bi bi-unlock-fill"></i> Activate';
        }

        openOverlay(toggleStatusDialog, "flex");
      });
    });

    if (btnCancelToggle) {
      btnCancelToggle.addEventListener("click", () => {
        closeOverlay(toggleStatusDialog);
        pendingTenantId = null;
      });
    }

    if (toggleStatusDialog) {
      toggleStatusDialog.addEventListener("click", (e) => {
        if (e.target === toggleStatusDialog) {
          closeOverlay(toggleStatusDialog);
          pendingTenantId = null;
        }
      });
    }

    if (btnConfirmToggle && toggleStatusForm && toggleTenantId) {
      btnConfirmToggle.addEventListener("click", () => {
        if (!pendingTenantId) return;
        popSuccess(btnConfirmToggle);
        toggleTenantId.value = pendingTenantId;
        toggleStatusForm.submit();
      });
    }
  }

  function initToastClose() {
    const closeBtn = $("#toastCloseBtn");
    const toast = $("#errorToast");

    if (closeBtn && toast) {
      closeBtn.addEventListener("click", () => {
        toast.classList.remove("show");
        toast.setAttribute("aria-hidden", "true");
      });
    }
  }

  function initKeyboardShortcuts() {
    document.addEventListener("keydown", (e) => {
      if (e.key !== "Escape") return;

      if (
        resetPasswordModal &&
        resetPasswordModal.classList.contains("mt-open")
      ) {
        closeOverlay(resetPasswordModal);
        setTimeout(() => openOverlay(editModal, "flex"), 120);
        return;
      }

      if (
        toggleStatusDialog &&
        toggleStatusDialog.classList.contains("mt-open")
      ) {
        closeOverlay(toggleStatusDialog);
        pendingTenantId = null;
        return;
      }

      if (confirmDialog && confirmDialog.classList.contains("mt-open")) {
        closeOverlay(confirmDialog);
        return;
      }

      if (editModal && editModal.classList.contains("mt-open")) {
        closeOverlay(editModal);
      }
    });
  }

  document.addEventListener("DOMContentLoaded", () => {
    initEntranceFx();
    initRipples();
    initEditModal();
    initSaveConfirm();
    initClearButtons();
    initResetPassword();
    initToggleStatus();
    initToastClose();
    initKeyboardShortcuts();
  });
})();
