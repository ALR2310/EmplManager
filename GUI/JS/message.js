//js tự động cuộn xuống item cuối của khung chat
function scrollToBottom() {
    var chatList = document.querySelector('.chat-main__list');
    chatList.scrollTop = chatList.scrollHeight;
}


//js đặt height cho textarea khi có nội dung nhiều hơn
var chatInput = document.querySelector(".chat-footer__form textarea");

const handleInput = () => {
    if (chatInput.value.trim() === "") {
        chatInput.style.height = "40px";
    }
    else {
        chatInput.style.height = "auto";
        chatInput.style.height = `${chatInput.scrollHeight}px`;
    }
}
chatInput.addEventListener("keyup", handleInput);


//js hiệu ứng mở đống thanh search trong chat-box
var btnSearch = document.querySelector('.chat__search-box__btn');
var searchInput = document.querySelector('.chat__search-box__input');
var counter = 0;
btnSearch.addEventListener('click', function () {
    this.parentElement.classList.toggle('open');
    this.previousElementSibling.focus();
    if (counter === 0) {
        searchInput.style.border = "1px solid var(--primary-color)";
        btnSearch.style.color = "var(--primary-color)";
        counter = 1;
    } else {
        searchInput.style.border = "none";
        btnSearch.style.color = "black";
        counter = 0;
    }
})



//js cho nút dropdown trong ellips chat
function toggleDropdown(event) {
    var dropdownMenu = event.target.closest('.chat-ellips__dropdown').querySelector(
        '.chat-ellips__dropdown__menu');
    if (dropdownMenu.style.display === 'block') {
        dropdownMenu.style.display = 'none';
        document.removeEventListener('click', outsideClickHandler);
    } else {
        dropdownMenu.style.display = 'block';
        document.addEventListener('click', outsideClickHandler);
    }
}

function outsideClickHandler(event) {
    var dropdownMenus = document.querySelectorAll('.chat-ellips__dropdown__menu');
    for (var i = 0; i < dropdownMenus.length; i++) {
        var dropdownMenu = dropdownMenus[i];
        var dropdownToggle = dropdownMenu.parentNode.querySelector('.chat-ellips__dropdown__toggle');
        if (!dropdownMenu.contains(event.target) && !dropdownToggle.contains(event.target)) {
            dropdownMenu.style.display = 'none';
        }
    }
}



//js gọi sự kiện btnsend khi bấm enter
function handleKeyPress(event) {
    if (event.key === "Enter" && !event.shiftKey) {
        event.preventDefault(); // Ngăn chặn hành vi mặc định của phím Enter

        __doPostBack('<%= btnSend.UniqueID %>', '');
    }
}



//js gọi sự kiện btnSend khi click
function handlebtnSend() {
    __doPostBack('<%= btnSend.UniqueID %>', ''); //gọi sự kiện của btnSend_click
}




//js gọi sự kiện searchchat khi enter trong textbox search

function handleSearchChat(event) {
    if (event.key === "Enter" && !event.shiftKey) {
        event.preventDefault(); // Ngăn hành động mặt định của phím Enter

        __doPostBack('<%= btnSearchChat.UniqueID%>', ''); // Id của button searchchat
    }
}