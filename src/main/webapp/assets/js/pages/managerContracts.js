(function () {
  const ctx = window.__CTX || "";
  const form = document.getElementById("mcSearchForm");
  const qEl = document.getElementById("mcQ");
  const statusEl = document.getElementById("mcStatus");
  const pageSizeEl = document.getElementById("mcPageSize");
  const wrapper = document.getElementById("contractTableWrapper");

  let timer = null;
  let lastQueryKey = "";

  function buildUrl(page) {
    const params = new URLSearchParams();
    params.set("ajax", "1");
    params.set("q", qEl.value || "");
    params.set("status", statusEl.value || "");
    params.set("pageSize", pageSizeEl.value || "10");
    params.set("page", String(page || 1));
    return `${ctx}/manager/contracts?${params.toString()}`;
  }

  function attachPagerAjax() {
    wrapper.querySelectorAll('a[href*="ajax=1"]').forEach((a) => {
      a.addEventListener("click", (e) => {
        const href = a.getAttribute("href") || "";
        if (!href.includes("manager/contracts")) return;

        e.preventDefault();

        // Parse page từ href (dù href có bị double ctx vẫn parse được)
        const u = new URL(href, window.location.origin);
        const page = parseInt(u.searchParams.get("page") || "1", 10);

        // Fetch bằng buildUrl => không bị /LandHouseManagement/LandHouseManagement nữa
        fetchAndReplace(buildUrl(page));
      });
    });
  }

  function fetchAndReplace(url) {
    fetch(url, { headers: { "X-Requested-With": "XMLHttpRequest" } })
      .then((r) => r.text())
      .then((html) => {
        wrapper.innerHTML = html;
        attachPagerAjax();
      })
      .catch(() => {});
  }

  function load(page) {
    const key = `${qEl.value}|||${statusEl.value}|||${pageSizeEl.value}|||${page || 1}`;
    if (key === lastQueryKey) return;
    lastQueryKey = key;
    fetchAndReplace(buildUrl(page || 1));
  }

  // chặn submit form (khỏi reload page)
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      load(1);
    });
  }

  // gõ chữ => debounce
  qEl.addEventListener("input", () => {
    clearTimeout(timer);
    timer = setTimeout(() => load(1), 350);
  });

  // đổi filter => reload
  statusEl.addEventListener("change", () => load(1));
  pageSizeEl.addEventListener("change", () => load(1));

  // lần đầu attach
  attachPagerAjax();
})();
