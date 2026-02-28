(function () {
  // ===== Search filter (client-side) =====
  const input = document.getElementById("arSearchInput");
  const clearBtn = document.getElementById("arClearBtn");
  const rows = Array.from(document.querySelectorAll(".ar-row"));

  function filterRows() {
    const q = (input.value || "").trim().toLowerCase();
    rows.forEach((row) => {
      const room = (row.dataset.room || "").toLowerCase();
      const block = (row.dataset.block || "").toLowerCase();
      const status = (row.dataset.status || "").toLowerCase();

      const ok =
        !q || room.includes(q) || block.includes(q) || status.includes(q);
      row.style.display = ok ? "" : "none";
    });
  }

  if (input) input.addEventListener("input", filterRows);
  if (clearBtn)
    clearBtn.addEventListener("click", () => {
      input.value = "";
      filterRows();
      input.focus();
    });

  // ===== Delete modal =====
  const modal = document.getElementById("arDeleteModal");
  const delGo = document.getElementById("arDeleteGo");
  const delText = document.getElementById("arDeleteText");

  function openModal(url, roomName) {
    if (!modal) return;
    modal.classList.add("is-open");
    modal.setAttribute("aria-hidden", "false");
    document.body.style.overflow = "hidden";

    if (delGo) delGo.setAttribute("href", url || "#");
    if (delText) {
      delText.textContent =
        'Xác nhận xoá phòng "' +
        (roomName || "") +
        '"? Hành động này không thể hoàn tác.';
    }
  }

  function closeModal() {
    if (!modal) return;
    modal.classList.remove("is-open");
    modal.setAttribute("aria-hidden", "true");
    document.body.style.overflow = "";
  }

  document.querySelectorAll(".js-delete-room").forEach((btn) => {
    btn.addEventListener("click", () => {
      const url = btn.getAttribute("data-delete-url");
      const name = btn.getAttribute("data-room-name");
      openModal(url, name);
    });
  });

  if (modal) {
    modal.addEventListener("click", (e) => {
      if (e.target && e.target.getAttribute("data-close") === "1") closeModal();
    });
  }

  document.addEventListener("keydown", (e) => {
    if (!modal || !modal.classList.contains("is-open")) return;
    if (e.key === "Escape") closeModal();
  });
})();
