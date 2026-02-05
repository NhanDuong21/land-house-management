// home.js
(function () {
  const modal = document.getElementById("filterModal");
  const openBtn = document.getElementById("btnOpenFilter");
  const closeBtn = document.getElementById("btnCloseFilter");
  const backdrop = document.getElementById("filterBackdrop");

  function openModal() { if (modal) modal.classList.add("show"); }
  function closeModal() { if (modal) modal.classList.remove("show"); }

  if (openBtn) openBtn.addEventListener("click", openModal);
  if (closeBtn) closeBtn.addEventListener("click", closeModal);
  if (backdrop) backdrop.addEventListener("click", closeModal);

  // -------- dual range helper ----------
  function clampPair(minEl, maxEl) {
    const minV = Number(minEl.value);
    const maxV = Number(maxEl.value);
    if (minV > maxV) minEl.value = maxV;
  }

  function formatVND(n) {
    try { return Number(n).toLocaleString("vi-VN") + " đ"; }
    catch { return n + " đ"; }
  }

  // price
  const priceMin = document.getElementById("priceMin");
  const priceMax = document.getElementById("priceMax");
  const priceMinText = document.getElementById("priceMinText");
  const priceMaxText = document.getElementById("priceMaxText");
  const minPriceHidden = document.getElementById("minPriceHidden");
  const maxPriceHidden = document.getElementById("maxPriceHidden");

  function syncPrice() {
    if (!priceMin || !priceMax) return;
    clampPair(priceMin, priceMax);
    if (priceMinText) priceMinText.textContent = formatVND(priceMin.value);
    if (priceMaxText) priceMaxText.textContent = formatVND(priceMax.value);
    if (minPriceHidden) minPriceHidden.value = priceMin.value;
    if (maxPriceHidden) maxPriceHidden.value = priceMax.value;
  }

  if (priceMin) priceMin.addEventListener("input", syncPrice);
  if (priceMax) priceMax.addEventListener("input", syncPrice);
  syncPrice();

  // area
  const areaMin = document.getElementById("areaMin");
  const areaMax = document.getElementById("areaMax");
  const areaMinText = document.getElementById("areaMinText");
  const areaMaxText = document.getElementById("areaMaxText");
  const minAreaHidden = document.getElementById("minAreaHidden");
  const maxAreaHidden = document.getElementById("maxAreaHidden");

  function syncArea() {
    if (!areaMin || !areaMax) return;
    clampPair(areaMin, areaMax);
    if (areaMinText) areaMinText.textContent = areaMin.value + " m²";
    if (areaMaxText) areaMaxText.textContent = areaMax.value + " m²";
    if (minAreaHidden) minAreaHidden.value = areaMin.value;
    if (maxAreaHidden) maxAreaHidden.value = areaMax.value;
  }

  if (areaMin) areaMin.addEventListener("input", syncArea);
  if (areaMax) areaMax.addEventListener("input", syncArea);
  syncArea();

  // choice groups (Any/Yes/No)
  function initChoiceGroup(groupSelector, hiddenId, initValue) {
    const group = document.querySelector(groupSelector);
    const hidden = document.getElementById(hiddenId);
    if (!group || !hidden) return;

    function setActive(val) {
      hidden.value = val;
      group.querySelectorAll(".choice").forEach(btn => {
        btn.classList.toggle("active", btn.dataset.value === val);
      });
    }

    group.querySelectorAll(".choice").forEach(btn => {
      btn.addEventListener("click", () => setActive(btn.dataset.value));
    });

    setActive(initValue || hidden.value || "any");
  }

  const init = window.RH_INIT || {};
  initChoiceGroup('.choice-group[data-target="hasAC"]', "hasACHidden", init.hasAC);
  initChoiceGroup('.choice-group[data-target="hasMezzanine"]', "hasMezzHidden", init.hasMezzanine);

  // IMPORTANT: KHÔNG auto-open modal sau khi apply
})();
