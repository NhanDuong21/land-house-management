(function () {
  const STORAGE_KEY = "extendContractFormData";

  const form = document.querySelector(".me-form");
  const startDateInput = form
    ? form.querySelector('input[name="startDate"]')
    : null;
  const endDateInput = form
    ? form.querySelector('input[name="endDate"]')
    : null;
  const monthlyRentInput = form
    ? form.querySelector('input[name="monthlyRent"]')
    : null;
  const depositInput = form
    ? form.querySelector('input[name="deposit"]')
    : null;
  const paymentQrDataInput = form
    ? form.querySelector('input[name="paymentQrData"]')
    : null;
  const submitBtn = form
    ? form.querySelector('.me-btn-primary[type="submit"]')
    : null;

  if (
    !form ||
    !startDateInput ||
    !endDateInput ||
    !monthlyRentInput ||
    !depositInput ||
    !paymentQrDataInput
  ) {
    return;
  }

  let endDateManuallyEdited = false;
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

  function formatMoney(value) {
    const num = Number(value || 0);
    if (Number.isNaN(num)) return "0 đ";
    return new Intl.NumberFormat("vi-VN").format(num) + " đ";
  }

  function clearFormDataOnSuccessPageLoad() {
    const params = new URLSearchParams(window.location.search);
    const hasError = params.has("err");

    if (!hasError) {
      sessionStorage.removeItem(STORAGE_KEY);
    }
  }

  function saveFormData() {
    const data = {
      startDate: startDateInput.value,
      endDate: endDateInput.value,
      monthlyRent: monthlyRentInput.value,
      deposit: depositInput.value,
      paymentQrData: paymentQrDataInput.value,
      endDateManuallyEdited: endDateManuallyEdited,
    };

    sessionStorage.setItem(STORAGE_KEY, JSON.stringify(data));
  }

  function restoreFormData() {
    const raw = sessionStorage.getItem(STORAGE_KEY);
    if (!raw) return false;

    try {
      const data = JSON.parse(raw);

      if (data.startDate) startDateInput.value = data.startDate;
      if (data.endDate) endDateInput.value = data.endDate;
      if (data.monthlyRent) monthlyRentInput.value = data.monthlyRent;
      if (data.deposit) depositInput.value = data.deposit;
      if (data.paymentQrData) paymentQrDataInput.value = data.paymentQrData;

      endDateManuallyEdited = Boolean(data.endDateManuallyEdited);
      return true;
    } catch (e) {
      sessionStorage.removeItem(STORAGE_KEY);
      return false;
    }
  }

  function syncEndDateMin() {
    if (startDateInput.value) {
      endDateInput.min = startDateInput.value;
    }
  }

  function autoFillEndDateFromStartDate() {
    if (!startDateInput.value) {
      endDateInput.value = "";
      return;
    }

    if (!endDateManuallyEdited || !endDateInput.value) {
      endDateInput.value = addOneYear(startDateInput.value);
    }
  }

  function markInvalid(el, invalid) {
    if (!el) return;
    el.classList.toggle("is-invalid", !!invalid);
  }

  function validateForm() {
    let valid = true;

    const fields = [
      startDateInput,
      endDateInput,
      monthlyRentInput,
      depositInput,
      paymentQrDataInput,
    ];

    fields.forEach(function (el) {
      const empty = !String(el.value || "").trim();
      markInvalid(el, empty);
      if (empty) valid = false;
    });

    const start = startDateInput.value;
    const end = endDateInput.value;
    const rent = Number(monthlyRentInput.value || 0);
    const deposit = Number(depositInput.value || 0);

    if (start && end && end <= start) {
      markInvalid(startDateInput, true);
      markInvalid(endDateInput, true);
      valid = false;
    }

    if (Number.isNaN(rent) || rent < 0) {
      markInvalid(monthlyRentInput, true);
      valid = false;
    }

    if (Number.isNaN(deposit) || deposit < 0) {
      markInvalid(depositInput, true);
      valid = false;
    }

    return valid;
  }

  function buildSummary() {
    if (document.getElementById("meSummary")) return;

    const note = form.querySelector(".me-note");
    const summary = document.createElement("div");
    summary.className = "me-summary me-reveal";
    summary.id = "meSummary";
    summary.innerHTML = `
      <div class="me-summary-head">
        <div class="me-summary-title">Renewal Snapshot</div>
      </div>
      <div class="me-summary-grid">
        <div class="me-summary-item">
          <div class="me-summary-label">Start Date</div>
          <div class="me-summary-value" id="meSummaryStart">-</div>
        </div>
        <div class="me-summary-item">
          <div class="me-summary-label">End Date</div>
          <div class="me-summary-value" id="meSummaryEnd">-</div>
        </div>
        <div class="me-summary-item">
          <div class="me-summary-label">Monthly Rent</div>
          <div class="me-summary-value" id="meSummaryRent">-</div>
        </div>
        <div class="me-summary-item">
          <div class="me-summary-label">Deposit</div>
          <div class="me-summary-value" id="meSummaryDeposit">-</div>
        </div>
      </div>
    `;

    const preview = document.createElement("div");
    preview.className = "me-preview";
    preview.id = "meQrPreview";
    preview.innerHTML = `
      <div class="me-preview-title">Payment QR Data Preview</div>
      <div class="me-preview-code" id="meQrPreviewCode">-</div>
    `;

    if (note) {
      note.insertAdjacentElement("beforebegin", preview);
      note.insertAdjacentElement("beforebegin", summary);
    } else {
      form.appendChild(summary);
      form.appendChild(preview);
    }
  }

  function updateSummary() {
    const startEl = document.getElementById("meSummaryStart");
    const endEl = document.getElementById("meSummaryEnd");
    const rentEl = document.getElementById("meSummaryRent");
    const depositEl = document.getElementById("meSummaryDeposit");

    if (startEl) startEl.textContent = startDateInput.value || "-";
    if (endEl) endEl.textContent = endDateInput.value || "-";
    if (rentEl) rentEl.textContent = formatMoney(monthlyRentInput.value);
    if (depositEl) depositEl.textContent = formatMoney(depositInput.value);
  }

  function updateQrPreview() {
    const preview = document.getElementById("meQrPreview");
    const code = document.getElementById("meQrPreviewCode");
    if (!preview || !code) return;

    const value = String(paymentQrDataInput.value || "").trim();
    if (!value) {
      preview.classList.remove("show");
      code.textContent = "-";
      return;
    }

    code.textContent = value;
    preview.classList.add("show");
  }

  function setupReveal() {
    const targets = document.querySelectorAll(
      ".me-card, .me-alert, .me-summary, .me-preview",
    );
    targets.forEach(function (el) {
      el.classList.add("me-reveal");
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
        rootMargin: "0px 0px -30px 0px",
      },
    );

    targets.forEach(function (el) {
      observer.observe(el);
    });
  }

  function setupInputCleanup() {
    [
      startDateInput,
      endDateInput,
      monthlyRentInput,
      depositInput,
      paymentQrDataInput,
    ].forEach(function (el) {
      el.addEventListener("input", function () {
        el.classList.remove("is-invalid");
      });
      el.addEventListener("change", function () {
        el.classList.remove("is-invalid");
      });
    });
  }

  function setupSubmitState() {
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
        <span class="me-btn-spinner" aria-hidden="true"></span>
        Creating Renewal...
      `;
    });
  }

  clearFormDataOnSuccessPageLoad();

  const restored = restoreFormData();

  syncEndDateMin();

  if (!restored && startDateInput.value) {
    autoFillEndDateFromStartDate();
  } else if (!endDateInput.value && startDateInput.value) {
    autoFillEndDateFromStartDate();
  }

  buildSummary();
  updateSummary();
  updateQrPreview();
  setupInputCleanup();
  setupSubmitState();

  startDateInput.addEventListener("change", function () {
    syncEndDateMin();
    autoFillEndDateFromStartDate();
    saveFormData();
    updateSummary();
  });

  endDateInput.addEventListener("input", function () {
    endDateManuallyEdited = true;
    saveFormData();
    updateSummary();
  });

  endDateInput.addEventListener("change", function () {
    endDateManuallyEdited = true;
    saveFormData();
    updateSummary();
  });

  [monthlyRentInput, depositInput].forEach(function (el) {
    el.addEventListener("input", function () {
      saveFormData();
      updateSummary();
    });
    el.addEventListener("change", function () {
      saveFormData();
      updateSummary();
    });
  });

  paymentQrDataInput.addEventListener("input", function () {
    saveFormData();
    updateQrPreview();
  });

  paymentQrDataInput.addEventListener("change", function () {
    saveFormData();
    updateQrPreview();
  });

  form.addEventListener("submit", function () {
    saveFormData();
  });

  requestAnimationFrame(function () {
    setupReveal();
  });
})();
