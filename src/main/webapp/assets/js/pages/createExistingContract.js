(function () {
  const STORAGE_KEY = "createExistingContractFormData";

  const form = document.getElementById("createExistingContractForm");
  const roomSelect = document.getElementById("roomId");
  const tenantIdInput = document.getElementById("tenantId");
  const rentInput = document.getElementById("rent");
  const depositInput = document.getElementById("deposit");
  const startDateInput = document.getElementById("startDate");
  const endDateInput = document.getElementById("endDate");
  const cccdFrontInput = document.getElementById("cccdFront");
  const cccdBackInput = document.getElementById("cccdBack");

  if (
    !form ||
    !roomSelect ||
    !tenantIdInput ||
    !rentInput ||
    !depositInput ||
    !startDateInput ||
    !endDateInput
  ) {
    return;
  }

  let depositManuallyEdited = false;
  let isSubmitting = false;

  function formatDate(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0");
    const day = String(date.getDate()).padStart(2, "0");
    return year + "-" + month + "-" + day;
  }

  function addOneYear(dateString) {
    const date = new Date(dateString + "T00:00:00");
    date.setFullYear(date.getFullYear() + 1);
    return formatDate(date);
  }

  function normalizeNumberString(value) {
    if (!value) return "";
    return String(value).replace(/[^0-9.-]/g, "");
  }

  function getSelectedRoomPrice() {
    const selectedOption = roomSelect.options[roomSelect.selectedIndex];
    if (!selectedOption) return "";
    return normalizeNumberString(selectedOption.getAttribute("data-price"));
  }

  function formatMoney(value) {
    const num = Number(value || 0);
    if (Number.isNaN(num)) return "0 đ";
    return new Intl.NumberFormat("vi-VN").format(num) + " đ";
  }

  function fillDepositFromRent() {
    const rentValue = Number(rentInput.value || 0);
    if (!Number.isNaN(rentValue) && rentValue >= 0) {
      depositInput.value = rentValue * 2;
    }
  }

  function fillRentFromSelectedRoom() {
    const roomPrice = getSelectedRoomPrice();
    if (roomPrice) {
      rentInput.value = roomPrice;
      if (!depositManuallyEdited || !depositInput.value) {
        fillDepositFromRent();
      }
      updateSummary();
    }
  }

  function saveFormData() {
    const data = {
      roomId: roomSelect.value,
      tenantId: tenantIdInput.value,
      rent: rentInput.value,
      deposit: depositInput.value,
      startDate: startDateInput.value,
      endDate: endDateInput.value,
      depositManuallyEdited: depositManuallyEdited,
    };

    sessionStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  }

  function restoreFormData() {
    const raw = sessionStorage.getItem(STORAGE_KEY);
    if (!raw) return false;

    try {
      const data = JSON.parse(raw);

      if (data.roomId) roomSelect.value = data.roomId;
      if (data.tenantId) tenantIdInput.value = data.tenantId;
      if (data.rent) rentInput.value = data.rent;
      if (data.deposit) depositInput.value = data.deposit;
      if (data.startDate) startDateInput.value = data.startDate;
      if (data.endDate) endDateInput.value = data.endDate;

      depositManuallyEdited = Boolean(data.depositManuallyEdited);
      return true;
    } catch (e) {
      sessionStorage.removeItem(STORAGE_KEY);
      return false;
    }
  }

  function clearFormDataOnSuccessPageLoad() {
    const hasError = new URLSearchParams(window.location.search).has("error");
    if (!hasError) {
      sessionStorage.removeItem(STORAGE_KEY);
    }
  }

  function createFileMeta(input) {
    if (
      !input ||
      input.nextElementSibling?.classList?.contains("mcc-file-meta")
    ) {
      return;
    }
    const meta = document.createElement("div");
    meta.className = "mcc-file-meta";
    input.insertAdjacentElement("afterend", meta);
  }

  function updateFileMeta(input) {
    if (!input) return;
    const meta = input.nextElementSibling;
    if (!meta || !meta.classList.contains("mcc-file-meta")) return;

    const file = input.files && input.files[0];
    if (!file) {
      meta.className = "mcc-file-meta";
      meta.textContent = "";
      return;
    }

    const maxSize = 10 * 1024 * 1024;
    const isValid = file.size <= maxSize;

    meta.className = "mcc-file-meta show " + (isValid ? "ok" : "bad");
    meta.textContent =
      file.name +
      " • " +
      Math.round(file.size / 1024) +
      " KB" +
      (isValid ? "" : " • File too large");
  }

  function buildSummary() {
    if (document.getElementById("mccSummary")) return;

    const summary = document.createElement("div");
    summary.className = "mcc-summary";
    summary.id = "mccSummary";
    summary.innerHTML = `
      <div class="mcc-summary-head">
        <div class="mcc-summary-title">
          <i class="bi bi-stars"></i>
          Contract Snapshot
        </div>
      </div>
      <div class="mcc-summary-grid">
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">Room</div>
          <div class="mcc-summary-value" id="mccSummaryRoom">-</div>
        </div>
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">Tenant</div>
          <div class="mcc-summary-value" id="mccSummaryTenant">-</div>
        </div>
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">Monthly Rent</div>
          <div class="mcc-summary-value" id="mccSummaryRent">-</div>
        </div>
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">Deposit</div>
          <div class="mcc-summary-value" id="mccSummaryDeposit">-</div>
        </div>
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">Start Date</div>
          <div class="mcc-summary-value" id="mccSummaryStart">-</div>
        </div>
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">End Date</div>
          <div class="mcc-summary-value" id="mccSummaryEnd">-</div>
        </div>
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">Tenant Account</div>
          <div class="mcc-summary-value" id="mccSummaryAccount">-</div>
        </div>
        <div class="mcc-summary-item">
          <div class="mcc-summary-label">Status</div>
          <div class="mcc-summary-value" id="mccSummaryStatus">PENDING</div>
        </div>
      </div>
    `;

    form.appendChild(summary);
  }

  function updateSummary() {
    const roomText =
      roomSelect.options[roomSelect.selectedIndex]?.text?.split(" - ")[0] ||
      "-";

    const tenantText =
      tenantIdInput.options[tenantIdInput.selectedIndex]?.text || "-";

    const setText = function (id, value) {
      const el = document.getElementById(id);
      if (el) el.textContent = value || "-";
    };

    setText("mccSummaryRoom", roomText);
    setText("mccSummaryTenant", tenantText);
    setText("mccSummaryRent", formatMoney(rentInput.value));
    setText("mccSummaryDeposit", formatMoney(depositInput.value));
    setText("mccSummaryStart", startDateInput.value || "-");
    setText("mccSummaryEnd", endDateInput.value || "-");
    setText("mccSummaryAccount", tenantText);
    setText("mccSummaryStatus", "PENDING");
  }

  function markInvalid(input, invalid) {
    if (!input) return;
    input.classList.toggle("is-invalid", !!invalid);
  }

  function validateForm() {
    let valid = true;

    const requiredFields = [
      roomSelect,
      tenantIdInput,
      rentInput,
      depositInput,
      startDateInput,
      endDateInput,
      cccdFrontInput,
      cccdBackInput,
    ];

    requiredFields.forEach(function (field) {
      const isEmpty =
        field.type === "file"
          ? !(field.files && field.files.length > 0)
          : !String(field.value || "").trim();

      markInvalid(field, isEmpty);
      if (isEmpty) valid = false;
    });

    const rentVal = Number(rentInput.value || 0);
    const depositVal = Number(depositInput.value || 0);

    if (rentVal < 0 || Number.isNaN(rentVal)) {
      markInvalid(rentInput, true);
      valid = false;
    }

    if (depositVal < 0 || Number.isNaN(depositVal)) {
      markInvalid(depositInput, true);
      valid = false;
    }

    if (startDateInput.value && endDateInput.value) {
      if (endDateInput.value <= startDateInput.value) {
        markInvalid(startDateInput, true);
        markInvalid(endDateInput, true);
        valid = false;
      }
    }

    return valid;
  }

  function setupInputInteractions() {
    const inputs = form.querySelectorAll(".mcc-control-input");
    inputs.forEach(function (input) {
      input.addEventListener("input", function () {
        input.classList.remove("is-invalid");
      });
      input.addEventListener("change", function () {
        input.classList.remove("is-invalid");
      });
    });
  }

  function setupSubmitState() {
    const submitBtn = form.querySelector('button[type="submit"]');
    if (!submitBtn) return;

    form.addEventListener("submit", function (e) {
      saveFormData();

      if (!validateForm()) {
        e.preventDefault();
        const firstInvalid = form.querySelector(".is-invalid");
        if (firstInvalid) {
          firstInvalid.scrollIntoView({ behavior: "smooth", block: "center" });
          firstInvalid.focus();
        }
        return;
      }

      if (isSubmitting) {
        e.preventDefault();
        return;
      }

      isSubmitting = true;
      submitBtn.classList.add("is-submitting");
      submitBtn.innerHTML = `
        <span class="mcc-btn-spinner" aria-hidden="true"></span>
        Creating Contract...
      `;
    });
  }

  clearFormDataOnSuccessPageLoad();

  const today = new Date();
  const todayStr = formatDate(today);

  startDateInput.min = todayStr;

  const restored = restoreFormData();

  if (!startDateInput.value) {
    startDateInput.value = todayStr;
  }

  if (!endDateInput.value) {
    endDateInput.value = addOneYear(startDateInput.value);
  }

  if (!restored) {
    fillRentFromSelectedRoom();
  } else if (!depositManuallyEdited && rentInput.value && !depositInput.value) {
    fillDepositFromRent();
  }

  createFileMeta(cccdFrontInput);
  createFileMeta(cccdBackInput);
  buildSummary();
  updateSummary();
  updateFileMeta(cccdFrontInput);
  updateFileMeta(cccdBackInput);
  setupInputInteractions();
  setupSubmitState();

  startDateInput.addEventListener("change", function () {
    if (!this.value) {
      endDateInput.value = "";
      saveFormData();
      updateSummary();
      return;
    }

    endDateInput.value = addOneYear(this.value);
    saveFormData();
    updateSummary();
  });

  roomSelect.addEventListener("change", function () {
    fillRentFromSelectedRoom();
    saveFormData();
    updateSummary();
  });

  tenantIdInput.addEventListener("change", function () {
    saveFormData();
    updateSummary();
  });

  rentInput.addEventListener("input", function () {
    if (!depositManuallyEdited || !depositInput.value) {
      fillDepositFromRent();
    }
    saveFormData();
    updateSummary();
  });

  depositInput.addEventListener("input", function () {
    depositManuallyEdited = true;
    saveFormData();
    updateSummary();
  });

  [cccdFrontInput, cccdBackInput].forEach(function (input) {
    if (!input) return;
    input.addEventListener("change", function () {
      updateFileMeta(input);
    });
  });
})();
