document.addEventListener("DOMContentLoaded", function () {
    const existingRadio = document.querySelector('input[name="blockMode"][value="existing"]');
    const newRadio = document.querySelector('input[name="blockMode"][value="new"]');

    const existingGroup = document.getElementById("existingBlockGroup");
    const newGroup = document.getElementById("newBlockGroup");

    const existingHint = document.getElementById("existingBlockHint");
    const newHint = document.getElementById("newBlockHint");

    const blockSelect = document.getElementById("blockId");
    const newBlockInput = document.getElementById("newBlockName");

    function applyMode() {
        if (existingRadio.checked) {
            existingGroup.classList.remove("is-hidden");
            existingHint.classList.remove("is-hidden");

            newGroup.classList.add("is-hidden");
            newHint.classList.add("is-hidden");

            if (blockSelect) blockSelect.disabled = false;
            if (newBlockInput) newBlockInput.disabled = true;
        } else if (newRadio.checked) {
            newGroup.classList.remove("is-hidden");
            newHint.classList.remove("is-hidden");

            existingGroup.classList.add("is-hidden");
            existingHint.classList.add("is-hidden");

            if (newBlockInput) newBlockInput.disabled = false;
            if (blockSelect) blockSelect.disabled = true;
        }
    }

    if (existingRadio) existingRadio.addEventListener("change", applyMode);
    if (newRadio) newRadio.addEventListener("change", applyMode);

    applyMode();
});