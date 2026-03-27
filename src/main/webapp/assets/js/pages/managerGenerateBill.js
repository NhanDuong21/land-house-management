document.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("billForm");

  const roomSelect = document.getElementById("roomSelect");
  const tenantInput = document.getElementById("tenantName");

  const oldElectric = document.getElementById("oldElectric");
  const newElectric = document.getElementById("newElectric");
  const electricUsage = document.getElementById("electricUsage");

  const oldWater = document.getElementById("oldWater");
  const newWater = document.getElementById("newWater");
  const waterUsage = document.getElementById("waterUsage");

  const submitBtn = form ? form.querySelector(".tbg-btn-generate") : null;
  const submitBtnIcon = submitBtn ? submitBtn.querySelector("i") : null;
  const submitBtnText = submitBtn
    ? submitBtn.querySelector(".tbg-btn-text")
    : null;

  function safeNumber(value) {
    const num = parseFloat(value);
    return isNaN(num) ? 0 : num;
  }

  function animateUsage(inputEl) {
    if (!inputEl) return;
    inputEl.classList.remove("tbg-usage-pop");
    void inputEl.offsetWidth;
    inputEl.classList.add("tbg-usage-pop");
  }

  function calcElectric() {
    if (!oldElectric || !newElectric || !electricUsage) return;

    const oldVal = safeNumber(oldElectric.value);
    const hasNewValue = newElectric.value !== "";
    const newVal = safeNumber(newElectric.value);

    if (!hasNewValue) {
      electricUsage.value = "";
      return;
    }

    const usage = Math.max(0, newVal - oldVal);
    electricUsage.value = usage;
    animateUsage(electricUsage);
  }

  function calcWater() {
    if (!oldWater || !newWater || !waterUsage) return;

    const oldVal = safeNumber(oldWater.value);
    const hasNewValue = newWater.value !== "";
    const newVal = safeNumber(newWater.value);

    if (!hasNewValue) {
      waterUsage.value = "";
      return;
    }

    const usage = Math.max(0, newVal - oldVal);
    waterUsage.value = usage;
    animateUsage(waterUsage);
  }

  if (oldElectric) oldElectric.addEventListener("input", calcElectric);
  if (newElectric) newElectric.addEventListener("input", calcElectric);
  if (oldWater) oldWater.addEventListener("input", calcWater);
  if (newWater) newWater.addEventListener("input", calcWater);

  function onRoomChange() {
    if (!roomSelect) return;

    const selected = roomSelect.options[roomSelect.selectedIndex];
    if (!selected) return;

    if (tenantInput) {
      tenantInput.value = selected.dataset.tenant || "";
    }

    if (oldElectric) {
      oldElectric.value = selected.dataset.oldElectric || 0;
    }

    if (oldWater) {
      oldWater.value = selected.dataset.oldWater || 0;
    }

    if (newElectric) newElectric.value = "";
    if (newWater) newWater.value = "";
    if (electricUsage) electricUsage.value = "";
    if (waterUsage) waterUsage.value = "";
  }

  if (roomSelect) {
    roomSelect.addEventListener("change", onRoomChange);
  }

  // Auto calculate when open edit page
  calcElectric();
  calcWater();

  // Submit animation only, does not affect backend
  if (form && submitBtn) {
    form.addEventListener("submit", function () {
      submitBtn.classList.add("loading");

      if (submitBtnIcon) {
        submitBtnIcon.className = "bi bi-arrow-repeat";
      }

      if (submitBtnText) {
        submitBtnText.textContent = "Processing...";
      }
    });
  }
});
