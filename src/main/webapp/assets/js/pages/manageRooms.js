/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
document.addEventListener("DOMContentLoaded", function () {

    const input = document.querySelector(".searchRoom");
    const rows = document.querySelectorAll("#roomTable tr");

    if (!input) return;

    input.addEventListener("keyup", function () {
        const keyword = input.value.toLowerCase();

        rows.forEach(row => {
            const roomCell = row.querySelector(".roomNumber");

            if (!roomCell) return;

            const roomNumber = roomCell.textContent.toLowerCase();

            if (roomNumber.includes(keyword)) {
                row.style.display = "";
            } else {
                row.style.display = "none";
            }
        });
    });

});


