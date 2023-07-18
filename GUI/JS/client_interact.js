function getCookie(cname) {
    let name = cname + "=";
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for (let i = 0; i < ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

var lastIndexedTime = new Date();
function getTimeGap(time) {


    var timeDiff = lastIndexedTime - time
    lastIndexedTime = time;

    if (Math.abs(timeDiff / 1000 / 60) < 30) { return false; }

    return true;


}

const DayStrList = {
    0: "Hôm nay",
    1: "Hôm qua",
    2: "Hôm kia"
}

var Users = {};
var CurrentTime = new Date();
const FormatFuncs = {
    '_timegaptostyle_': function (message) {
        return getTimeGap(message.AtCreate) == true ? "" : "display:none";
    },
    '_timestr_': function (message) {

        var time = message.AtCreate.toLocaleTimeString("vi-VN");

        return `${time}`;
    },
    '_datestr_': function (message) {
        var dayint = Math.floor(Math.abs(CurrentTime - message.AtCreate) / (1000 * 60 * 60 * 24));
        return `${!!DayStrList[dayint] ? DayStrList[dayint] : AtCreate.toLocaleDateString("vi-VN")}`;
    },
    '_messageid_': function (message) {
        return message.Id;
    },
    '_isowner_mess_': function (message) {



        return Users.CLIENT_USER.Id == message.UserId ? "true" : "";
    },
    '_message_avatar_': function (message) {


        setTimeout(async function () {
            if (Users[message.UserId] == null) { await fetchUser(message.UserId) }


            $(`.chat-main__item[message_id=${message.Id}]`).find("img").attr("src", Users[message.UserId].Avatar);
        }, 0)

        return "";

    },
    '_drop_hidden_': function (message) {
        return message.Status != 1 ? "true" : "";
    },
    '_display_name_': async function (message) {

        setTimeout(async function () {
            if (Users[message.UserId] == null) { await fetchUser(message.UserId); }

            $(`.chat-main__item[message_id=${message.Id}]`).find(".mess_display_name").text(Users[message.UserId].DisplayName);
        }, 0)

        return "";
    },
    '_deleted_italic_': function (message) {

        return message.Status != 1 ? "italic" : "";
    },
    '_deleted_or_content': function (message) {
        var messStatus = message.Status;
        return messStatus == 0 ? "Tin nhắn đã được thu hồi" :
            messStatus == -1 ? "Tin nhắn đã được thu hồi bởi quản trị viên" :
                message.Content;

    }
}

async function fetchUser(id, fromCookie) {
    if (id == null) fromCookie = true;

    await $.ajax({
        url: 'Message.aspx/GetUser',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ id: (!!id ? id : 0), fromCookie: !!fromCookie ? fromCookie : false }),
        success: function (response) {
            var user = JSON.parse(response.d);

            if (fromCookie) {
                Users["CLIENT_USER"] = user;
                return;
            }
            Users[user.Id] = user;
        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
}

async function renderMessage(message) {
    message.AtCreate = new Date(message.AtCreate);
    const message_ele = $("#chat-template").clone();
    var finalhtml = message_ele.html();

    for ([replaceTargetstr, formatFunc] of Object.entries(FormatFuncs)) {
        finalhtml = finalhtml.replaceAll(replaceTargetstr, await formatFunc(message, message_ele));
    }

    message_ele.html(finalhtml);
    message_ele.find(".chat-main__item").on("mouseenter", toggleEllips);
    message_ele.children().appendTo(".chat-main__list")[0];
    message["message_element"] = message_ele;

}
async function loadMessages(messages_data) {
    for ([key, message] of Object.entries(messages_data)) {

        await renderMessage(message);

    }
}
var Saved_Messages
async function requestJsonData(page) {
    $.ajax({
        url: 'Message.aspx/GetMessageJsonData',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ page: page }),
        success: function (response) {
            Saved_Messages = JSON.parse(response.d);
            loadMessages(Saved_Messages);

        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
}
var sendCD = false;
function sendMessage() {
    if (sendCD) { return; }
    sendCD = true;
    $.ajax({
        url: 'Message.aspx/SendMessage',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ content: inputElement.val() }),
        success: function (response) {


        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
    inputElement.val("");
    scrollBottom();
    sendCD = false;
}
(async function main() {
    await fetchUser();
    await requestJsonData(1);
})();
