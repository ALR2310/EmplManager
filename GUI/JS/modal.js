const modal = document.querySelector(".modal");
const overlay = document.querySelector(".overlay");
const closeBtn = document.querySelector(".close-btn");

function toggleModal() {
    modal.classList.remove("hide");
    setTimeout(() => {
        modal.classList.add("active");
    }, 300);

}

overlay.addEventListener("click", () => {
    modal.classList.remove("active");
    setTimeout(() => {
        modal.classList.add("hide");
    }, 400);

});

closeBtn.addEventListener("click", () => {
    modal.classList.remove("active");
    setTimeout(() => {
        modal.classList.add("hide");
    }, 400);

});