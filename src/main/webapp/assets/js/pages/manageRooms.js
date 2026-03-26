let selectedRoomId = null;
let selectedStatus = null;

const modal = document.getElementById("statusModal");
const saveBtn = document.getElementById("saveBtn");
const cancelBtn = document.getElementById("cancelBtn");
const toast = document.getElementById("roomToast");
const toastText = document.getElementById("roomToastText");

function showToast(message) {
  if (!toast || !toastText) return;
  toastText.textContent = message;
  toast.classList.add("show");

  clearTimeout(showToast._timer);
  showToast._timer = setTimeout(() => {
    toast.classList.remove("show");
  }, 2200);
}

function openModal(roomId, currentStatus) {
  selectedRoomId = roomId;
  selectedStatus = currentStatus;

  document.querySelectorAll(".room-status-options button").forEach((btn) => {
    btn.classList.toggle("active", btn.dataset.status === currentStatus);
  });

  modal.style.display = "flex";
  requestAnimationFrame(() => {
    modal.classList.remove("hide");
    modal.classList.add("show");
  });
}

function closeModal() {
  if (!modal) return;

  modal.classList.remove("show");
  modal.classList.add("hide");

  setTimeout(() => {
    modal.style.display = "none";
    modal.classList.remove("hide");
  }, 220);
}

document.querySelectorAll(".room-status-btn").forEach((btn) => {
  btn.addEventListener("click", () => {
    openModal(btn.dataset.roomId, btn.dataset.status);
  });
});

document.querySelectorAll(".room-status-options button").forEach((btn) => {
  btn.addEventListener("click", () => {
    document
      .querySelectorAll(".room-status-options button")
      .forEach((b) => b.classList.remove("active"));

    btn.classList.add("active");
    selectedStatus = btn.dataset.status;
  });
});

if (cancelBtn) {
  cancelBtn.onclick = () => {
    closeModal();
  };
}

if (modal) {
  modal.addEventListener("click", (e) => {
    if (e.target === modal) {
      closeModal();
    }
  });
}

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape" && modal && modal.style.display === "flex") {
    closeModal();
  }
});

if (saveBtn) {
  saveBtn.onclick = () => {
    if (!selectedRoomId || !selectedStatus) return;

    saveBtn.classList.add("loading");
    saveBtn.disabled = true;
    showToast("Updating room status...");

    fetch("rooms", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: `roomId=${encodeURIComponent(selectedRoomId)}&status=${encodeURIComponent(selectedStatus)}`,
    })
      .then(() => {
        showToast("Status updated successfully");
        location.reload();
      })
      .catch(() => {
        saveBtn.classList.remove("loading");
        saveBtn.disabled = false;
        showToast("Update failed");
      });
  };
}

// SEARCH + FILTER
(function () {
  const input = document.getElementById("roomSearch");
  const status = document.getElementById("roomStatus");

  let timer = null;

  function submitWithAnimation(form) {
    if (!form) return;
    document.body.classList.add("table-is-submitting");
    form.submit();
  }

  if (input) {
    input.addEventListener("input", function () {
      if (timer) {
        clearTimeout(timer);
      }

      timer = setTimeout(() => {
        const form = input.closest("form");
        submitWithAnimation(form);
      }, 400);
    });
  }

  if (status) {
    status.addEventListener("change", function () {
      const form = status.closest("form");
      submitWithAnimation(form);
    });
  }

  document.querySelectorAll(".pagination a").forEach((link) => {
    link.addEventListener("click", function () {
      document.body.classList.add("table-is-submitting");
    });
  });

  document.querySelectorAll(".room-search-form").forEach((form) => {
    form.addEventListener("submit", function () {
      document.body.classList.add("table-is-submitting");
    });
  });
})();

// SMALL PARALLAX GLOW
(function () {
  const card = document.querySelector(".room-card");
  if (!card) return;

  card.addEventListener("mousemove", (e) => {
    const rect = card.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const rotateY = (x / rect.width - 0.5) * 2.5;
    const rotateX = (y / rect.height - 0.5) * -2.2;

    card.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
  });

  card.addEventListener("mouseleave", () => {
    card.style.transform = "";
  });
})();
