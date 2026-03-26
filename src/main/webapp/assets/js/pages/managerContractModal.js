(function () {
  let isOpen = false;

  function getModal() {
    return document.getElementById("contractTypeModal");
  }

  window.openContractTypeModal = function () {
    const modal = getModal();
    if (!modal || isOpen) return;

    isOpen = true;
    modal.style.display = "flex";

    requestAnimationFrame(() => {
      modal.classList.add("mc-modal-show");
      document.body.style.overflow = "hidden";
    });
  };

  window.closeContractTypeModal = function () {
    const modal = getModal();
    if (!modal || !isOpen) return;

    isOpen = false;
    modal.classList.remove("mc-modal-show");
    document.body.style.overflow = "";

    setTimeout(() => {
      if (!isOpen) {
        modal.style.display = "none";
      }
    }, 320);
  };

  window.addEventListener("click", function (e) {
    const modal = getModal();
    if (modal && e.target === modal) {
      window.closeContractTypeModal();
    }
  });

  window.addEventListener("keydown", function (e) {
    if (e.key === "Escape" && isOpen) {
      window.closeContractTypeModal();
    }
  });
})();
