(function () {
  const STORAGE_KEY = "createExistingContractFormData";

  const form = document.getElementById("createExistingContractForm");
  const roomSelect = document.getElementById("roomId");
  const tenantIdInput = document.getElementById("tenantId");
  const rentInput = document.getElementById("rent");
  const depositInput = document.getElementById("deposit");
  const startDateInput = document.getElementById("startDate");
  const endDateInput = document.getElementById("endDate");

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

  startDateInput.addEventListener("change", function () {
    if (!this.value) {
      endDateInput.value = "";
      saveFormData();
      return;
    }

    endDateInput.value = addOneYear(this.value);
    saveFormData();
  });

  roomSelect.addEventListener("change", function () {
    fillRentFromSelectedRoom();
    saveFormData();
  });

  tenantIdInput.addEventListener("change", saveFormData);

  rentInput.addEventListener("input", function () {
    if (!depositManuallyEdited || !depositInput.value) {
      fillDepositFromRent();
    }
    saveFormData();
  });

  depositInput.addEventListener("input", function () {
    depositManuallyEdited = true;
    saveFormData();
  });

  form.addEventListener("submit", function () {
    saveFormData();
  });
})();
