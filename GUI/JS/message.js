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

function toggleDropdown(event, str) {

    var dropdownMenu = event.target.parentNode.querySelector(
        '.chat-ellips__dropdown__menu');
    console.log("Toggle");
    if (!dropdownMenu) { return; }
    dropdownMenu.style.display = str;

}

function toggleEmoji(event, str) {

    var emojiShowMenu = event.target.parentNode.querySelector(
        '.chat-ellips__show_emoji');

    if (!emojiShowMenu) { return; }
    emojiShowMenu.style.display = str;

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
var lastIndexedTime = new Date();
function getTimeGap(time) {


    var timeDiff = lastIndexedTime - time
    lastIndexedTime = time;
    console.log(timeDiff / 1000 / 60);
    if (Math.abs(timeDiff / 1000 / 60) < 30) { return false; }

    return true;


}

const DayStrList = {
    0: "Hôm nay",
    1: "Hôm qua",
    2: "Hôm kia"
}

var CurrentTime = new Date();
const FormatFuncs = {
    '_timegaptostyle_': function (message) {
        return getTimeGap(message.AtCreate) == true ? "" : "display:none";
    },
    '_timeanddatestr_': function (message) {
        var AtCreate = message.AtCreate;
        var time = message.AtCreate.toLocaleTimeString("vi-VN");
        var dayint = Math.floor(Math.abs(CurrentTime - message.AtCreate) / (1000 * 60 * 60 * 24));
        return `${time}, ${!!DayStrList[dayint] ? DayStrList[dayint] : AtCreate.toLocaleDateString("vi-VN")}`;
    },
    '_messageid_': function (message) {
        return message.Id;
    }
}

var UserFromCookie;
async function getUserFromCookie() {
    $.ajax({
        url: 'Message.aspx/GetUserFromCookieData',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ page: page }),
        success: function (response) {
            UserFromCookie = response.d;
        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
}
async function requestJsonData(page) {
    $.ajax({
        url: 'Message.aspx/GetMessageJsonData',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ page: page }),
        success: function (response) {
            const messages = JSON.parse(response.d);

            for ([key, message] of Object.entries(messages)) {

                message.AtCreate = new Date(message.AtCreate);
                const message_ele = $("#chat-template").clone();
                var finalhtml = message_ele.html();
         
                for ([replaceTargetstr,formatFunc] of Object.entries(FormatFuncs)) {
                    finalhtml = finalhtml.replaceAll(replaceTargetstr, formatFunc(message));
                }
    
                message_ele.html(finalhtml);
                message_ele.children().appendTo(".chat-main__list")[0];
                message["message_element"] = message_ele;


            }
        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
}
requestJsonData(1);