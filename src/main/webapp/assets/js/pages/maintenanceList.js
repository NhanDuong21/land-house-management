(function () {
  const input = document.getElementById("mlSearch");
  const status = document.getElementById("mlStatus");

  let timer = null;

  function initSearchAutoSubmit() {
    if (!input) return;

    input.addEventListener("input", function () {
      if (timer) clearTimeout(timer);

      timer = setTimeout(() => {
        const form = input.closest("form");
        if (form) form.submit();
      }, 400);
    });
  }

  function initStatusFilter() {
    if (!status) return;

    status.addEventListener("change", function () {
      const form = status.closest("form");
      if (form) form.submit();
    });
  }

  function initReveal() {
    const revealItems = document.querySelectorAll(".ml-reveal");

    revealItems.forEach((item, index) => {
      setTimeout(() => {
        item.classList.add("is-visible");
      }, 90 * index);
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    initSearchAutoSubmit();
    initStatusFilter();
    initReveal();
  });
})();