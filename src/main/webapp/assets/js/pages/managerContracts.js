(function () {
  const ctx = window.__CTX || "";
  const form = document.getElementById("mcSearchForm");
  const qEl = document.getElementById("mcQ");
  const statusEl = document.getElementById("mcStatus");
  const pageSizeEl = document.getElementById("mcPageSize");
  const wrapper = document.getElementById("contractTableWrapper");

  if (!form || !qEl || !statusEl || !pageSizeEl || !wrapper) return;

  let timer = null;
  let lastQueryKey = "";
  let requestId = 0;

  function buildUrl(page) {
    const params = new URLSearchParams();
    params.set("ajax", "1");
    params.set("q", qEl.value || "");
    params.set("status", statusEl.value || "");
    params.set("pageSize", pageSizeEl.value || "10");
    params.set("page", String(page || 1));
    return `${ctx}/manager/contracts?${params.toString()}`;
  }

  function setLoading(isLoading) {
    wrapper.classList.toggle("mc-loading", !!isLoading);
  }

  function animateSwapOut() {
    wrapper.classList.remove("mc-fade-swap-in");
    wrapper.classList.add("mc-fade-swap-out");
  }

  function animateSwapIn() {
    wrapper.classList.remove("mc-fade-swap-out");
    wrapper.classList.add("mc-fade-swap-in");
  }

  function bindRowHoverDepth() {
    const rows = wrapper.querySelectorAll(".mc-table tbody tr");
    rows.forEach((row) => {
      row.addEventListener("mousemove", function (e) {
        const rect = row.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const percent = (x / rect.width - 0.5) * 2;
        row.style.transform = `translateY(-2px) rotateX(0deg) rotateY(${percent * 1.2}deg)`;
      });

      row.addEventListener("mouseleave", function () {
        row.style.transform = "";
      });
    });
  }

  function attachPagerAjax() {
    wrapper.querySelectorAll('a[href*="ajax=1"]').forEach((a) => {
      a.addEventListener("click", function (e) {
        const href = a.getAttribute("href") || "";
        if (!href.includes("manager/contracts")) return;

        e.preventDefault();

        const u = new URL(href, window.location.origin);
        const page = parseInt(u.searchParams.get("page") || "1", 10);

        fetchAndReplace(buildUrl(page));
      });
    });
  }

  async function fetchAndReplace(url) {
    const currentId = ++requestId;

    try {
      animateSwapOut();
      setLoading(true);

      const response = await fetch(url, {
        headers: { "X-Requested-With": "XMLHttpRequest" },
      });

      const html = await response.text();

      if (currentId !== requestId) return;

      wrapper.innerHTML = html;
      animateSwapIn();
      attachPagerAjax();
      bindRowHoverDepth();
    } catch (err) {
      console.error("Load contracts failed:", err);
    } finally {
      if (currentId === requestId) {
        setLoading(false);
      }
    }
  }

  function load(page) {
    const key = `${qEl.value}|||${statusEl.value}|||${pageSizeEl.value}|||${page || 1}`;
    if (key === lastQueryKey) return;
    lastQueryKey = key;
    fetchAndReplace(buildUrl(page || 1));
  }

  function initInputEffects() {
    qEl.addEventListener("focus", () => {
      qEl.parentElement?.classList?.add("mc-focus");
    });

    qEl.addEventListener("blur", () => {
      qEl.parentElement?.classList?.remove("mc-focus");
    });
  }

  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      load(1);
    });
  }

  qEl.addEventListener("input", () => {
    clearTimeout(timer);
    timer = setTimeout(() => load(1), 350);
  });

  statusEl.addEventListener("change", () => load(1));
  pageSizeEl.addEventListener("change", () => load(1));

  attachPagerAjax();
  bindRowHoverDepth();
  initInputEffects();
})();
