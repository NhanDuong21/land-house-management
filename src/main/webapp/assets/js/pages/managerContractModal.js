function openContractTypeModal() {
  const modal = document.getElementById("contractTypeModal");
  if (modal) modal.style.display = "flex";
}

function closeContractTypeModal() {
  const modal = document.getElementById("contractTypeModal");
  if (modal) modal.style.display = "none";
}

// đóng khi click nền
window.addEventListener("click", function (e) {
  const modal = document.getElementById("contractTypeModal");
  if (e.target === modal) {
    closeContractTypeModal();
  }
});
