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
        }, 200);
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