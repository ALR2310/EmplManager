//js gọi phương thức searchclick
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







// Lấy phần tử Notification-icon và Notification-container
var notificationIcon = document.querySelector('.Notification-icon');
var notificationContainer = document.querySelector('.Notification-container');

// Thêm sự kiện click vào Notification-icon
notificationIcon.addEventListener('click', function () {
    notificationContainer.classList.toggle('hide');

    // Lấy tất cả các phần tử p trong .Noti-desc và giới hạn văn bản cho mỗi phần tử p
    var descParagraphs = document.querySelectorAll('.Noti-desc p');
    descParagraphs.forEach(function (paragraph) {
        limitText(paragraph, 60);
    });
});

// Thêm sự kiện click chuột ra ngoài phạm vi của Notification
document.addEventListener('click', function (event) {
    var isClickInsideNotification = notificationContainer.contains(event.target) || notificationIcon.contains(event.target);
    if (!isClickInsideNotification) {
        notificationContainer.classList.add('hide');
    }
});




//function chuyển đổi darkmode
function toggleDarkmode(action) {
    divDark = document.getElementById("darkmode-moon");
    divLight = document.getElementById("darkmode-sun");

    action == "dark" ?
        (divDark.classList.add("hide"),
            divLight.classList.remove("hide"),
            localStorage.setItem('navbarTheme', 'dark'),
            localStorage.setItem('sidebarTheme', 'dark'),
            localStorage.setItem('layoutTheme', 'dark'),
            $("#stLayoutDark").prop("checked", true),
            $("#stTopbarDark").prop("checked", true),
            $("#stSideBarDark").prop("checked", true)) :
        (divDark.classList.remove("hide"),
            divLight.classList.add("hide"),
            localStorage.removeItem('navbarTheme'),
            localStorage.removeItem('sidebarTheme'),
            localStorage.removeItem('layoutTheme'),
            $("#stLayoutLight").prop("checked", true),
            $("#stTopbarLight").prop("checked", true),
            $("#stSideBarLight").prop("checked", true));

    handleLayoutTheme();
    handleNavbarTheme();
    handleSidebarTheme();
}

//function thay đổi màu layout
function handleLayoutTheme() {
    const theme = localStorage.getItem('layoutTheme');
    const elements = [
        ".content",
        ".modal-vertical__container",
        ".UIdetail-modal-delete",
        ".usrdetail-modal-email",
        ".nav",
        ".sidebar",
        ".chat-ellips__dropdown__menu",
        ".userInfor-body",
        ".modalSetting",
        "body"
    ];

    elements.forEach(element => {
        const el = document.querySelector(element);
        if (el) {
            el.classList.toggle("layout-dark", theme === 'dark');
        }
    });
}

handleLayoutTheme();

//function thay đổi màu navbar
function handleNavbarTheme() {
    var theme = localStorage.getItem('navbarTheme');
    if (theme == 'dark') {
        document.querySelector(".nav").classList.add("topbar-dark");
        document.querySelector(".nav").classList.remove("topbar-brand");
    } else if (theme == 'brand') {
        document.querySelector(".nav").classList.add("topbar-brand");
        document.querySelector(".nav").classList.remove("topbar-dark");
    } else {
        document.querySelector(".nav").classList.remove("topbar-brand");
        document.querySelector(".nav").classList.remove("topbar-dark");
    }
}
handleNavbarTheme();

//function thay đổi màu sidebar
function handleSidebarTheme() {
    var theme = localStorage.getItem('sidebarTheme');
    if (theme == 'dark') {
        document.querySelector('.sidebar').classList.add('sidebar-dark');
        document.querySelector('.sidebar').classList.remove('sidebar-brand');
    } else if (theme == 'brand') {
        document.querySelector('.sidebar').classList.remove('sidebar-dark');
        document.querySelector('.sidebar').classList.add('sidebar-brand');
    } else {
        document.querySelector('.sidebar').classList.remove('sidebar-dark');
        document.querySelector('.sidebar').classList.remove('sidebar-brand');
    }
}
handleSidebarTheme();


//function cho phần setting:
$('input[name="stLayout"]').change(function () {
    var selectedLayoutValue = $('input[name="stLayout"]:checked').attr('id');

    divDark = document.getElementById("darkmode-moon");
    divLight = document.getElementById("darkmode-sun");

    if (selectedLayoutValue === 'stLayoutDark') {
        $("#stTopbarDark").prop('checked', true);
        $("#stSideBarDark").prop('checked', true);
        divDark.classList.add("hide");
        divLight.classList.remove("hide");
    } else if (selectedLayoutValue === 'stLayoutBrand') {
        $("#stTopbarBrand").prop('checked', true);
        $("#stSidebarBrand").prop('checked', true);
    } else {
        $("#stTopbarLight").prop('checked', true);
        $("#stSideBarLight").prop('checked', true);
        divDark.classList.remove("hide");
        divLight.classList.add("hide");
    }
});

$('input[name="stLayout"]').change(function () {
    if ($(this).is(':checked')) {
        var selectedValue = $(this).attr('id');
        var themes = {
            'stLayoutLight': 'default',
            'stLayoutDark': 'dark',
            'stLayoutBrand': 'brand'
        };

        if (selectedValue in themes) {
            var theme = themes[selectedValue];
            localStorage.setItem('layoutTheme', theme);
            localStorage.setItem('navbarTheme', theme);
            localStorage.setItem('sidebarTheme', theme);
            handleLayoutTheme();
            handleNavbarTheme();
            handleSidebarTheme();
            $("#" + selectedValue).attr('checked', true);
            console.log("change " + theme + " theme");
        }
    }
});

$('input[name="stTopbar"]').change(function () {
    if ($(this).is(':checked')) {
        var selectedValue = $(this).attr('id');

        if (selectedValue === 'stTopbarDark') {
            localStorage.setItem('navbarTheme', 'dark');
            handleNavbarTheme();
            console.log("change dark theme")
        } else if (selectedValue === 'stTopbarBrand') {
            localStorage.setItem('navbarTheme', 'brand');
            handleNavbarTheme();
            console.log("change brand theme")
        } else if (selectedValue === 'stTopbarLight') {
            localStorage.removeItem('navbarTheme');
            handleNavbarTheme();
            console.log("change default theme")
        }
    }
});


$('input[name="stSideBar"').change(function () {
    if ($(this).is(':checked')) {
        var selectedValue = $(this).attr('id');

        if (selectedValue === 'stSideBarDark') {
            localStorage.setItem('sidebarTheme', 'dark');
            handleSidebarTheme();
            console.log("change dark theme")
        } else if (selectedValue === 'stSidebarBrand') {
            localStorage.setItem('sidebarTheme', 'brand');
            handleSidebarTheme();
            console.log("change brand theme")
        } else if (selectedValue === 'stSideBarLight') {
            localStorage.removeItem('sidebarTheme');
            handleSidebarTheme();
            console.log("change default theme")
        }
    }
});


//function kiểm tra localstorageTheme
function checkTheme() {
    var navbarTheme = localStorage.getItem('navbarTheme');
    var sidebarTheme = localStorage.getItem('sidebarTheme');
    var layoutTheme = localStorage.getItem('layoutTheme');

    if (navbarTheme == 'dark') {
        $("#stTopbarDark").attr('checked', true);
    } else if (navbarTheme == 'brand') {
        $("#stTopbarBrand").attr('checked', true);
    }

    if (sidebarTheme == 'dark') {
        $("#stSideBarDark").attr('checked', true);
    } else if (sidebarTheme == 'brand') {
        $("#stSidebarBrand").attr('checked', true);
    }

    if (layoutTheme == 'dark') {
        $("#stLayoutDark").attr('checked', true);

        $("#darkmode-moon").addClass('hide');
        $("#darkmode-sun").removeClass('hide');
    } else if (layoutTheme == 'brand') {
        $("#stLayoutBrand").attr('checked', true);
    }
}
checkTheme()