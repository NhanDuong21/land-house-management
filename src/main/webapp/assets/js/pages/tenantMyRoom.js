(function () {
  const lightbox = document.getElementById("mrLightbox");
  if (!lightbox) return;

  const imgEl = document.getElementById("mrLbImg");
  const countEl = document.getElementById("mrLbCount");
  const skelEl = document.getElementById("mrLbSkel");

  const thumbs = Array.from(document.querySelectorAll(".mr-thumb"));
  const coverBtn = document.querySelector(".mr-cover-btn[data-cover='1']");
  const coverSrc = coverBtn ? coverBtn.getAttribute("data-src") : null;

  const sources = thumbs.map((b) => b.getAttribute("data-src")).filter(Boolean);

  let index = 0;

  function showLoading() {
    lightbox.classList.add("is-loading");
    if (imgEl) imgEl.classList.remove("is-ready");
    if (skelEl) skelEl.style.display = "block";
  }

  function hideLoading() {
    lightbox.classList.remove("is-loading");
    if (skelEl) skelEl.style.display = "";
    if (imgEl) requestAnimationFrame(() => imgEl.classList.add("is-ready"));
  }

  function preload(src) {
    return new Promise((resolve) => {
      const im = new Image();
      im.onload = () => resolve(true);
      im.onerror = () => resolve(false);
      im.src = src;
    });
  }

  async function setImage(i) {
    if (!imgEl) return;

    showLoading();

    // No gallery images => fallback to cover only
    if (sources.length === 0) {
      if (!coverSrc) {
        hideLoading();
        return;
      }
      index = 0;
      countEl.textContent = "1/1";

      await preload(coverSrc);
      imgEl.src = coverSrc;
      hideLoading();
      return;
    }

    index = (i + sources.length) % sources.length;
    const src = sources[index];

    countEl.textContent = `${index + 1}/${sources.length}`;

    await preload(src);
    imgEl.src = src;
    hideLoading();

    // preload neighbors for smoother nav
    const nextIdx = (index + 1) % sources.length;
    const prevIdx = (index - 1 + sources.length) % sources.length;
    preload(sources[nextIdx]);
    preload(sources[prevIdx]);
  }

  function open(i) {
    lightbox.classList.add("is-open");
    lightbox.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";
    setImage(i);
  }

  function close() {
    lightbox.classList.remove("is-open");
    lightbox.classList.remove("is-loading");
    lightbox.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
    if (imgEl) {
      imgEl.classList.remove("is-ready");
      imgEl.src = "";
    }
  }

  function next() {
    setImage(index + 1);
  }

  function prev() {
    setImage(index - 1);
  }

  // thumbs click
  thumbs.forEach((btn, i) => {
    btn.addEventListener("click", () => open(i));
  });

  // cover click opens first image (cover thumb should be index 0)
  if (coverBtn) {
    coverBtn.addEventListener("click", () => {
      if (sources.length > 0) open(0);
      else if (coverSrc) open(0);
    });
  }

  // close on backdrop/close button
  lightbox.addEventListener("click", (e) => {
    if (e.target && e.target.getAttribute("data-close") === "1") close();
  });

  // nav buttons
  const prevBtn = lightbox.querySelector(".mr-lb-nav.prev");
  const nextBtn = lightbox.querySelector(".mr-lb-nav.next");
  const closeBtn = lightbox.querySelector(".mr-lb-close");

  if (prevBtn)
    prevBtn.addEventListener("click", (e) => (e.stopPropagation(), prev()));
  if (nextBtn)
    nextBtn.addEventListener("click", (e) => (e.stopPropagation(), next()));
  if (closeBtn)
    closeBtn.addEventListener("click", (e) => (e.stopPropagation(), close()));

  // keyboard
  document.addEventListener("keydown", (e) => {
    if (!lightbox.classList.contains("is-open")) return;
    if (e.key === "Escape") close();
    if (e.key === "ArrowRight") next();
    if (e.key === "ArrowLeft") prev();
  });

  // swipe mobile
  let startX = 0;
  let startY = 0;
  let dragging = false;

  lightbox.addEventListener("touchstart", (e) => {
    if (!lightbox.classList.contains("is-open")) return;
    const t = e.touches[0];
    startX = t.clientX;
    startY = t.clientY;
    dragging = true;
  });

  lightbox.addEventListener("touchend", (e) => {
    if (!dragging) return;
    dragging = false;

    const t = e.changedTouches[0];
    const dx = t.clientX - startX;
    const dy = t.clientY - startY;

    if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) {
      if (dx < 0) next();
      else prev();
    }
  });
})();
