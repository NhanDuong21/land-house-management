document.addEventListener("DOMContentLoaded", function () {

    const modal = document.getElementById("billModal");
    if (!modal) return;

    const modalContent = modal.querySelector(".custom-modal-content");
    const paymentSelect = document.getElementById("paymentMethod");
    const qrContainer = document.getElementById("qrContainer");

    // OPEN MODAL
    window.openModal = function () {
        modal.style.display = "flex";
        document.body.style.overflow = "hidden";
    };

    // CLOSE MODAL
    window.closeModal = function () {
        modal.style.display = "none";
        document.body.style.overflow = "auto";
    };

    // CLICK OUTSIDE TO CLOSE
    modal.addEventListener("click", function (event) {
        if (modalContent && !modalContent.contains(event.target)) {
            window.closeModal();
        }
    });

    // PAYMENT METHOD CHANGE
    if (paymentSelect && qrContainer) {

        // Ẩn QR lúc đầu
        qrContainer.style.display = "none";

        paymentSelect.addEventListener("change", function () {

            if (this.value === "BANK") {
                qrContainer.style.display = "block";
            } else {
                qrContainer.style.display = "none";
            }

        });
    }

});