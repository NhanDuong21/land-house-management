document.addEventListener("DOMContentLoaded", function () {
  const input = document.querySelector(".searchBill");
  const statusSelected = document.getElementById("status");
  const dateSelected = document.getElementById("billDate");
  const dateTrigger = document.getElementById("monthTrigger");
  const dateText = document.querySelector(".date-btn-text");
  const table = document.querySelector(".mb-table");
  const rows = Array.from(document.querySelectorAll("#billTable .bill-row"));
  const notFound = document.getElementById("notFoundBill");
  const dateWrapper = document.querySelector(".date-btn");
  const billCountTitle = document.getElementById("billCountTitle");

  if (!input || !statusSelected || !dateSelected || !table || !notFound) {
    return;
  }

  const defaultTitle = billCountTitle ? billCountTitle.textContent.trim() : "";

  function pulseTable() {
    table.classList.add("is-filtering");
    clearTimeout(pulseTable._timer);
    pulseTable._timer = setTimeout(() => {
      table.classList.remove("is-filtering");
    }, 180);
  }

  function normalizeText(value) {
    return (value || "").toString().trim().toLowerCase();
  }

  function getMonthYearFromRow(row) {
    const dateTextValue =
      row.querySelector(".dateBill")?.textContent?.trim() || "";
    const parts = dateTextValue.split("/");

    if (parts.length !== 3) return "";

    const month = parts[1];
    const year = parts[2];

    return `${year}-${month}`;
  }

  function animateRow(row) {
    row.style.opacity = "1";
    row.style.transform = "translateY(0) scale(1)";
    row.style.animation = "none";
    void row.offsetWidth;
    row.style.animation =
      "rowEnter 0.42s cubic-bezier(0.22, 1, 0.36, 1) forwards";
  }

  function formatMonthLabel(value) {
    if (!value) return "Month";
    const [year, month] = value.split("-");
    return `${month}/${year}`;
  }

  function updateDateUI() {
    if (dateSelected.value) {
      dateSelected.classList.add("has-value");
      if (dateWrapper) dateWrapper.classList.add("has-value");
      if (dateText) dateText.textContent = formatMonthLabel(dateSelected.value);
    } else {
      dateSelected.classList.remove("has-value");
      if (dateWrapper) dateWrapper.classList.remove("has-value");
      if (dateText) dateText.textContent = "Month";
    }
  }

  function filterBills() {
    pulseTable();

    const searchKeyword = normalizeText(input.value);
    const selectedStatus = statusSelected.value.trim();
    const selectedDate = dateSelected.value.trim();

    let visibleCount = 0;

    rows.forEach((row) => {
      const billId = normalizeText(row.dataset.billId);
      const roomNumber = normalizeText(row.dataset.roomNumber);
      const billStatus = (row.dataset.status || "").trim();
      const billMonth = getMonthYearFromRow(row);

      const matchSearch =
        searchKeyword === "" ||
        billId.includes(searchKeyword) ||
        roomNumber.includes(searchKeyword);

      const matchStatus =
        selectedStatus === "" || billStatus === selectedStatus;

      const matchDate = selectedDate === "" || billMonth === selectedDate;

      if (matchSearch && matchStatus && matchDate) {
        row.style.display = "";
        animateRow(row);
        visibleCount++;
      } else {
        row.style.display = "none";
      }
    });

    notFound.style.display = visibleCount === 0 ? "" : "none";

    if (billCountTitle) {
      if (
        searchKeyword !== "" ||
        selectedStatus !== "" ||
        selectedDate !== ""
      ) {
        billCountTitle.textContent = `All Bills (${visibleCount})`;
      } else {
        billCountTitle.textContent = defaultTitle;
      }
    }
  }

  let debounceTimer = null;

  input.addEventListener("input", function () {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(filterBills, 150);
  });

  statusSelected.addEventListener("change", filterBills);

  dateSelected.addEventListener("change", function () {
    updateDateUI();
    filterBills();
  });

  if (dateTrigger) {
    dateTrigger.addEventListener("click", function (e) {
      if (e.target === dateSelected) return;

      if (typeof dateSelected.showPicker === "function") {
        dateSelected.showPicker();
      } else {
        dateSelected.focus();
        dateSelected.click();
      }
    });
  }

  updateDateUI();

  const card = document.querySelector(".mb-card");
  if (card) {
    card.addEventListener("mousemove", function (e) {
      const rect = card.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;

      const rotateY = (x / rect.width - 0.5) * 2.2;
      const rotateX = (y / rect.height - 0.5) * -1.8;

      card.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
    });

    card.addEventListener("mouseleave", function () {
      card.style.transform = "";
    });
  }
});
