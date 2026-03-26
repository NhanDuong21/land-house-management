document.addEventListener("DOMContentLoaded", function () {
  const input = document.querySelector(".searchBill");
  const statusSelected = document.getElementById("status");
  const dateSelected = document.querySelector(".bill-date");
  const table = document.querySelector(".mb-table");
  const rows = document.querySelectorAll("#billTable tr:not(#notFoundBill)");
  const notFound = document.getElementById("notFoundBill");
  const dateWrapper = document.querySelector(".date-btn");

  if (!input || !statusSelected || !dateSelected || !notFound) {
    return;
  }

  function pulseTable() {
    if (!table) return;
    table.classList.add("is-filtering");
    clearTimeout(pulseTable._timer);
    pulseTable._timer = setTimeout(() => {
      table.classList.remove("is-filtering");
    }, 180);
  }

  function filterBills() {
    pulseTable();

    const searchKeyword = input.value.toLowerCase().trim();
    const selectedStatus = statusSelected.value;
    const selectedDate = dateSelected.value;
    let countBill = 0;

    rows.forEach((row) => {
      const billIdText = row.querySelector(".billId");
      const roomNumberText = row.querySelector(".roomNumber");
      const statusText = row.querySelector("td:nth-child(6) .mb-badge");
      const dateText = row.querySelector(".dateBill");

      if (!roomNumberText || !billIdText || !statusText || !dateText) {
        return;
      }

      const billId = billIdText.textContent.toLowerCase();
      const roomNumber = roomNumberText.textContent.toLowerCase();
      const billStatus = statusText.textContent.trim();
      const dateBill = dateText.textContent.trim();

      const matchSearch =
        roomNumber.includes(searchKeyword) || billId.includes(searchKeyword);

      const matchStatus =
        selectedStatus === "" || billStatus === selectedStatus;

      let matchDate = true;
      if (selectedDate !== "") {
        const [year, month] = selectedDate.split("-");
        const parts = dateBill.split("/");
        const monthBill = parts[1];
        const yearBill = parts[2];

        matchDate = monthBill === month && yearBill === year;
      }

      if (matchSearch && matchStatus && matchDate) {
        row.style.display = "";
        row.style.animation = "none";
        void row.offsetWidth;
        row.style.animation = "rowEnter 0.42s cubic-bezier(0.22, 1, 0.36, 1)";
        countBill++;
      } else {
        row.style.display = "none";
      }
    });

    notFound.style.display = countBill === 0 ? "" : "none";
  }

  let debounceTimer = null;

  input.addEventListener("input", function () {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(filterBills, 150);
  });

  statusSelected.addEventListener("change", filterBills);
  dateSelected.addEventListener("change", filterBills);

  if (dateSelected.value) {
    dateSelected.classList.add("has-value");
    if (dateWrapper) {
      dateWrapper.style.width = "auto";
      dateWrapper.style.padding = "0 10px";
    }
  }

  dateSelected.addEventListener("change", function () {
    if (this.value) {
      this.classList.add("has-value");
      if (dateWrapper) {
        dateWrapper.style.width = "auto";
        dateWrapper.style.padding = "0 10px";
      }
    } else {
      this.classList.remove("has-value");
      if (dateWrapper) {
        dateWrapper.style.width = "";
        dateWrapper.style.padding = "";
      }
    }
  });

  // Small 3D hover on card
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
