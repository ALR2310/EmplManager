var RenderedMessageReaction = {}
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
    '_timegaptostyle_': async function (message) {
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
    '_message_avatar_=""': function (message) {


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
    '_deleted_or_content_': async function (message) {
        var messStatus = message.Status;
        return messStatus == 0 ? "Tin nhắn đã được thu hồi" :
            messStatus == -1 ? "Tin nhắn đã được thu hồi bởi quản trị viên" :
                message.Content;

    }
}
var FetchingUsers = {}

async function fetchUser(id, fromCookie) {
    if (id == null) fromCookie = true;
    if (FetchingUsers[id]) {
        console.log("Found cached requets... canceling....");
        await FetchingUsers[id];
        return;
    }
    FetchingUsers[id] = $.ajax({
        url: 'Message.aspx/GetUser',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ id: (!!id ? id : 0), fromCookie: !!fromCookie ? fromCookie : false }),
        success: function (response) {
            var user = JSON.parse(response.d);

            if (fromCookie) {
                Users["CLIENT_USER"] = user;

            }
            Users[user.Id] = user;
        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        },
        complete: function () {
            FetchingUsers[id] = null;
        }
    });
    await FetchingUsers[id];
}

const emoji_id_to_emoji_txt = [
    "❤️",

    "👍",

    "😂",

    "😅",

    "🥳",

    "👀",

    "🤯",

    "🥲",
];
var last_num_list = {}
function renderEmojiButton(emoji_list_element, list, emoji_id, message_id) {
    const emoji_display = $("#emoji_display_placeholder").clone();
    emoji_display.css("display", "unset");
    emoji_display.attr("id", null);
    emoji_display.attr("emoji_id", emoji_id);

    emoji_display.appendTo(emoji_list_element);
    emoji_display.addClass("emoji_display");
    emoji_display.find(".ogcount").text(list.length);
    emoji_display.find(".ncount").text(list.length);

    last_num_list[message_id + '' + emoji_id] = list.length;

    emoji_display.find(".emoji_emoji").text(emoji_id_to_emoji_txt[emoji_id - 1]);


    var contains_own_reaction = list.indexOf(Users.CLIENT_USER.Id) != -1;
    emoji_display.addClass(contains_own_reaction ? "emoji_display_active" : "");


    var revokeCooldown = false;

    if (RenderedMessageReaction[message_id] == null) RenderedMessageReaction[message_id]= {};

    RenderedMessageReaction[message_id][emoji_id] = emoji_display;
    emoji_display.on("click",
        async function () {
            if (revokeCooldown) return;
            revokeCooldown = true;
            await $.ajax({  
                url: 'Message.aspx/ToggleEmoji',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                data: `{ "Message_Id": ${message_id},"Emoji_Id": ${emoji_id}}`,
            });
            revokeCooldown = false;
        });
}
async function renderMessage(message) {
    message.AtCreate = new Date(message.AtCreate);
    const message_ele = $("#chat-template").clone();
    var finalhtml = message_ele.html();

    for ([replaceTargetstr, formatFunc] of Object.entries(FormatFuncs)) {
        finalhtml = finalhtml.replaceAll(replaceTargetstr, await formatFunc(message, message_ele));
    }

    setTimeout(function () {
        var emoji_list_ele = $(`.chat-main__item[message_id=${message["Id"]}]`).find(".emoji_list");
        if (message.Reactions != null) {



            for (const [emoji_id, list] of Object.entries(message.Reactions)) {
                renderEmojiButton(emoji_list_ele, list, emoji_id, message["Id"]);

            }
        }

    }, 0);


    message_ele.html(finalhtml);
    message_ele.find(".chat-main__item").on("mouseenter", toggleEllips);
    message_ele.children().appendTo(".chat-main__list")[0];

    message["message_element"] = message_ele;

    Saved_Messages[message.Id] = message;


    /*setTimeout(function () {

        var = $(`.chat-main__item[message_id=${message["Id"]}]`).find(".emoji_emoji").find("canvas")[0];
   
    
        particleAnimate(canvas);
        return;
    }, 100);*/
}
async function loadMessages(messages_data) {
    for ([key, message] of Object.entries(messages_data)) {

        await renderMessage(message);

    }
}
const Saved_Messages = (() => {
    const myDictionary = {

    };

    return {
        get(key) {
            return myDictionary[key];
        },
        set(key, value) {
            myDictionary[key] = value;
        },
        getAll() {
            return { ...myDictionary };
        },
    };
})();

async function requestJsonData(page) {
    $.ajax({
        url: 'Message.aspx/GetMessageJsonData',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ page: page }),
        success: async function (response) {

            await loadMessages(JSON.parse(response.d));
            scrollBottom();
        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });
}
const DeleteMessage = function (data) {

    data = JSON.parse(data);
    var message_id = data.id;
    var status = data.status;
    console.log(message_id);
    console.log(status);

    var deleting_ele = $(`.chat-main__item[message_id=${message_id}]`).find(".mess_content");

    deleting_ele.addClass("italic");
    var deleted_mess =
        status == -1 ? "Tin nhắn đã được thu hồi bởi quản trị viên" : "Tin nhắn đã được thu hồi";
    deleting_ele.text(deleted_mess);

}

var sendCD = false;
function sendMessage() {
    if (sendCD || inputElement.val() == "") { return; }
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
    setTimeout(function () { inputElement.blur(); }, 1);
    scrollBottom();
    $(".chat-footer").css("height", "0px");
    sendCD = false;
}



setTimeout(async function () {

    await fetchUser();
    await requestJsonData(1);


}, 0);


function AssignNewNum(num, emoji_display_ele,key) {
    var ncount = emoji_display_ele.find(".ncount");
    var ogcount = emoji_display_ele.find(".ogcount");

    let last_num = last_num_list[key];
    console.log(last_num_list);
    console.log(last_num);
    console.log(num);
    var islarger = last_num >= num;
    console.log(islarger);


    last_num_list[key] = num;


    var og_num_txt = islarger ? last_num : num;
    var ncount_txt = islarger ? num : last_num;


    ogcount.text(og_num_txt);
    ncount.text(ncount_txt);


    var count_wrapper = emoji_display_ele.find(".count");
    count_wrapper.removeClass('new_count_anim new_count_reverse_anim');
    setTimeout(function () {
        count_wrapper.addClass(islarger ? 'new_count_anim' : 'new_count_reverse_anim');
    }, 0);

}




const UpdateMessageReaction = function (data) {
    console.log(data);
    var message_id = data.Message_Id;
    var emoji_id = data.Emoji_Id;
    var emoji_list_ele = $(`.chat-main__item[message_id=${message_id}]`).find(".emoji_list");

    var isRendered = !(RenderedMessageReaction[message_id] == null || RenderedMessageReaction[message_id][emoji_id] == null);
    if (data.Reaction_Ids == null && isRendered) {
        var element = RenderedMessageReaction[message_id][emoji_id];
        element.remove();
        element.off("click");
        RenderedMessageReaction[message_id][emoji_id] = null;
        return;
    }
    if (!isRendered) {

        renderEmojiButton(emoji_list_ele, data.Reaction_Ids, emoji_id, message_id);
        return;
    }
    var contains_own_reaction = data.Reaction_Ids.indexOf(Users.CLIENT_USER.Id) != -1;

    var emoji_display = emoji_list_ele.find(`.emoji_display[emoji_id=${emoji_id}]`);
    emoji_display.toggleClass("emoji_display_active", contains_own_reaction);
    AssignNewNum(data.Reaction_Ids.length,emoji_display,message_id+''+emoji_id);
}