﻿//js gọi phương thức searchclick
function handleSearchClick(event) {
    var searchClick = document.getElementById('<%= btnSearch.ClientID %>') //Id của nút btnSearch
    searchClick.click();
}

//js mở đóng sidebar
var sidebar = document.querySelector(".sidebar");
var btnMenuLeft = document.querySelector(".btn-menuleft");
var spanSidebarList = document.querySelectorAll(".sidebar-item__link span");
var clickCount = 0;
btnMenuLeft.addEventListener("click", function () {
    sidebar.classList.toggle("sidebar-close");
    clickCount++;
    if (clickCount % 2 === 1) {
        setTimeout(function () {
            for (var i = 0; i < spanSidebarList.length; i++) {
                spanSidebarList[i].classList.remove("hide");
            }
        }, 350);
    } else {
        for (var i = 0; i < spanSidebarList.length; i++) {
            spanSidebarList[i].classList.add("hide");
        }
    }
});

$(".speech").parent().addClass("contains_speech");


const parts = window.location.href.split('/');
var page = parts[parts.length - 1];
var elem = $(`.sidebar-item__link[href='${page}']`);
elem.addClass("active");

console.log(page == "tin-nhan");
$("#Message_Notif").css("visibility", "hidden");


var latest_message_id
$(async function () {

    if (page != "tin-nhan") {
        await fetchUser(0, true);
        console.log("Outside message page detected, setting up notification connection..");

        hubProxy.on('ReceiveMessage', async function (message) {
            console.log("Recieved new message");
            $("#Message_Notif").css("visibility", "unset");
        });
        function connect() {
            connection.start()
                .done(function () {
                    console.log('SignalR connection started.');
                })
                .fail(function (error) {

                    console.log('Error starting SignalR connection:', error);
                    setTimeout(connect, 1000);
                });


        }
        connect();
        latest_message_id = await $.ajax({
            url: 'Message.aspx/GetTotalMessage',
            type: 'POST',
            contentType: 'application/json',
            dataType: 'json',

        });

        latest_message_id = JSON.parse(latest_message_id.d).Id;



        if (latest_message_id > getLastReadMessage().Id)
            $("#Message_Notif").css("visibility", "unset");

    }

})

const getLastReadMessage = function () {
    let ClientId = Users.CLIENT_USER.Id;

    let raw_data = JSON.parse(localStorage.getItem("lastReadMessage" + ClientId));

    if (raw_data == null) raw_data = { Id: latest_message_id };
    if (!!raw_data.AtCreate) raw_data.AtCreate = new Date(raw_data.AtCreate);


    return raw_data;
}







//function đóng mở modal setting
var clickCount = 0;
function ToggleModalSettings() {
    var MdSetting = document.querySelector(".modalSetting");
    var MdOverlay = document.querySelector(".modalSetting_overlay");
    var MdContent = document.querySelector(".modalSetting_content");

    clickCount++;

    if (clickCount % 2 === 1) {

        MdSetting.classList.remove("hide");
        setTimeout(function () {
            MdOverlay.style.transform = "translateX(0)";
            MdContent.style.transform = "translateX(0)";
        }, 100);
    } else {
        MdOverlay.style.transform = "translateX(150%)";
        MdContent.style.transform = "translateX(100%)";
        setTimeout(function () {
            MdSetting.classList.add("hide");
        }, 400);
    }
}


//function chọn ngôn ngữ
function selectLanguage(language) {
    if (language == "vi") {
        $("#imgLguae").attr("src", "Images/Flags/vi.png");
    } else if (language == "us") {
        $("#imgLguae").attr("src", "Images/Flags/us.jpg");
    }
}
function toggleLanguageShow(event, str) {
    var language_content = event.currentTarget.querySelector('.language_content');

    if (!language_content) { return; }

    language_content.style.display = str;
}

//function giới hạn văn bản hiển thị
function limitText(element, limit) {
    var text = element.innerText;
    if (text.length > limit) {
        element.innerText = text.slice(0, limit) + '...';
    }
}

// Gọi limitText Giới hạn đến 60 ký tự
/*limitText(document.querySelector('.Noti-desc p'), 60);*/


//function chuyển đổi darkmode
function toggleDarkmode(action) {
    divDark = document.getElementById("darkmode-moon");
    divLight = document.getElementById("darkmode-sun");

    if (action == "dark") {
        divDark.classList.add("hide");
        divLight.classList.remove("hide");
    } else {
        divDark.classList.remove("hide");
        divLight.classList.add("hide");
    }
}