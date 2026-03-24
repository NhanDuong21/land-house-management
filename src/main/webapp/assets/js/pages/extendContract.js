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

  clearFormDataOnSuccessPageLoad();

  const restored = restoreFormData();

  syncEndDateMin();

  if (!restored && startDateInput.value) {
    autoFillEndDateFromStartDate();
  } else if (!endDateInput.value && startDateInput.value) {
    autoFillEndDateFromStartDate();
  }

  startDateInput.addEventListener("change", function () {
    syncEndDateMin();
    autoFillEndDateFromStartDate();
    saveFormData();
  });

  endDateInput.addEventListener("input", function () {
    endDateManuallyEdited = true;
    saveFormData();
  });

  endDateInput.addEventListener("change", function () {
    endDateManuallyEdited = true;
    saveFormData();
  });

  [monthlyRentInput, depositInput, paymentQrDataInput].forEach(function (el) {
    el.addEventListener("input", saveFormData);
    el.addEventListener("change", saveFormData);
  });

  form.addEventListener("submit", function () {
    saveFormData();
  });
})();
