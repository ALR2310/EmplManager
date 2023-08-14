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


var CurrentTime = new Date();
const FormatFuncs = {
    '_is_admin_or_not_': async function (message) {
        if (Users[message.UserId] == null) { await fetchUser(message.UserId); }
       
        return Users[message.UserId].UserType != 2 ? "display_none" : "";
    },
    '_timegaptostyle_': async function (message) {
        return getTimeGap(message.AtCreate) == true ? "" : "display:none";
    },
    '_timestr_': function (message) {

        
        var time = message.AtCreate.toLocaleTimeString("vi-VN");

        return time;
    },
    '_date_time_str_': function (message) {
        const date1 = CurrentTime;
        const date2 = message.AtCreate;

        // Get the date components (day, month, and year) of the two Date objects
        const day1 = date1.getDate();
        const month1 = date1.getMonth();
        const year1 = date1.getFullYear();

        const day2 = date2.getDate();
        const month2 = date2.getMonth();
        const year2 = date2.getFullYear();


        var time = message.AtCreate.toLocaleTimeString("vi-VN");


        let dayint = Math.abs(day1 - day2);
        if (
            month1 === month2 &&
            year1 === year2 && dayint <= 2) {
            return time;
        }
        return date2.toLocaleDateString("vi-VN") + " - " + time; 

    },
    '_datestr_': function (message) {
        const date1 = CurrentTime;
        const date2 = message.AtCreate;

        // Get the date components (day, month, and year) of the two Date objects
        const day1 = date1.getDate();
        const month1 = date1.getMonth();
        const year1 = date1.getFullYear();

        const day2 = date2.getDate();
        const month2 = date2.getMonth();
        const year2 = date2.getFullYear();

        let dayint = Math.abs(day1 - day2);
        if (
            month1 === month2 &&
            year1 === year2 && dayint <= 2) {
            return DayStrList[dayint] + ",";
        }
        return date2.toLocaleDateString("vi-VN");
    },
    '_messageid_': function (message) {
        return message.Id;
    },
    '_isowner_mess_': function (message) {



        return Users.CLIENT_USER.Id == message.UserId ? "true" : "";
    },
    '_message_avatar_=""': async function (message) {



        if (Users[message.UserId] == null) { await fetchUser(message.UserId) }


        return "src='" + Users[message.UserId].Avatar + "'";

    },
    '_drop_hidden_': function (message) {
        return message.Status != 1 ? "true" : "";
    },
    '_display_name_': async function (message) {


        if (Users[message.UserId] == null) { await fetchUser(message.UserId); }


        return Users[message.UserId].DisplayName;
    },
    '_deleted_italic_': function (message) {

        return message.Status != null && message.Status != 1 ? "italic" : "";
    },
    '_edited_or_not_': function (message) {


        return !!message.Edited && (message.Status == null || message.Status == 1) && message.Edited == true ? "italic mess_edited" : "display_none";
    },
    '_deleted_or_content_': async function (message) {
        var messStatus = message.Status;
        let content =  messStatus == 0 ? "Tin nhắn đã được thu hồi" :
            messStatus == -1 ? "Tin nhắn đã được thu hồi bởi quản trị viên" :
                message.Content;
     
    
        return message.Edited ? content + " " : content;

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
const __deprecated = [
    "❤️",

    "👍",

    "😂",

    "😅",

    "🥳",

    "👀",

    "🤯",

    "🥲",
];
const emoji_id_to_emoji_txt = [
    "Images/Emojis/heart.svg",

    "Images/Emojis/thumbsup.svg",

    "Images/Emojis/joy.svg",

    "Images/Emojis/sweat_smile.svg",

    "Images/Emojis/party.svg",

    "Images/Emojis/eyes.svg",

    "Images/Emojis/OPPENHEIMER.svg",

    "Images/Emojis/smile_tear.svg",
];
var last_num_list = {}
var bound_reaction_lists = {};
const emoji_speech_limit = 1;
async function renderEmojiButton(emoji_list_element, list, emoji_id, message_id) {
    bound_reaction_lists[message_id] = list;
    var scroll_to_bottom_again = emoji_list_element.find(".emoji_display").length == 0 && getScrollPos() == 0;
    const emoji_display = $("#emoji_display_placeholder").clone();
    emoji_display.css("display", "unset");
    emoji_display.attr("id", null);
    emoji_display.attr("emoji_id", emoji_id);

    emoji_display.appendTo(emoji_list_element);
    emoji_display.addClass("emoji_display");
    emoji_display.find(".ogcount").text(list.length);
    emoji_display.find(".ncount").text(list.length);

    for (id of list) {
        if (Users[id] == null) { await fetchUser(id) }
    }
    emoji_display.on("mouseenter", async function () {
        if (!bound_reaction_lists[message_id]) { return; }
        let final_str = "Cảm xúc được bày tỏ bởi: ";


        let index = 0;

        for (id of bound_reaction_lists[message_id]) {
            if (index == emoji_speech_limit) {
                final_str = final_str + "và " + `<a>${bound_reaction_lists[message_id].length - index} nguời khác.</a>`;
                index = 0;
                break
            }
            index++;
            if (!!!Users[id]) await fetchUser(id);
            if (!!!Users[id]) continue;
            final_str = final_str + Users[id].DisplayName + ", ";
        }
        if (index > 0 && index <= emoji_speech_limit) {

            final_str = final_str.slice(0, -2);

        }


        let emoji_speech = emoji_display.find(".speech.bottom");
        emoji_speech.css("display", "");
        if (emoji_speech.length == 0) {
            let speech = $(`<div class='speech bottom speech_left_side'>awedaw</div >`);

            speech.appendTo(emoji_display);
            emoji_display.find(".speech.bottom").html(final_str);
        }
        else {
            emoji_speech.html(final_str);
        }

    })

    last_num_list[message_id + '' + emoji_id] = list.length;

    emoji_display.find(".emoji_emoji").attr("src", emoji_id_to_emoji_txt[emoji_id - 1]);


    var contains_own_reaction = list.indexOf(Users.CLIENT_USER.Id) != -1;
    emoji_display.addClass(contains_own_reaction ? "emoji_display_active" : "");


    var revokeCooldown = false;

    if (RenderedMessageReaction[message_id] == null) RenderedMessageReaction[message_id] = {};

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

    if (scroll_to_bottom_again) {
        scrollBottom();
        setTimeout(scrollBottom, 50);
    }
}
function condictionalScrollBottom(height) {
    height = height || scroll.clientHeight;
    if (scroll.scrollTop + scroll.clientHeight - height > scroll.clientHeight) return;

    scrollBottom();
}
let file_template = $("#attached_file_template");
function loadAttachments(Uploaded_Files, message_ele) {

    for (const file of Uploaded_Files) {
        console.log(Uploaded_Files);
        let extension = file.fileName.split('.');
        let image = extension.length > 1 && !!file_format_image[extension[extension.length - 1]] ? file_format_image[extension[extension.length - 1]] : icons.default;

        if (image == "local_image" || image == "local_video") {
            let file_ele = $(`<${image == "local_image" ? 'img' : 'video'} controls  preload="metadata"/>`);

            file_ele.on("load resize", function () {
         

                condictionalScrollBottom(message_ele[0].offsetTop);
          

            });

         
            setTimeout(function () {
                file_ele.attr("src", "/Images/UserUploads/" + file.url);


            });
          

            file_ele.appendTo(message_ele.find(".attached_files"));
            continue;
        }
        let file_ele = file_template.clone();
        console.log(message_ele.find(".attached_files"));
        file_ele.attr("id", "");
        file_ele.appendTo(message_ele.find(".attached_files"));
        file_ele.find("img").attr("src", image);
        file_ele.find(".file_title").text(file.fileName);
        file_ele.find(".file_size").text(file.size);
        file_ele.find(".file_title").attr("href", "/Images/UserUploads/" + file.url);
        file_ele.find(".file_title").attr("download", file.fileName);
    }

}
async function renderMessage(message, isNewMessage) {

    Saved_Messages[message.Id] = message;

    if (lastRenderedMessage < message.Id) {

        lastRenderedMessage = message.Id;
    }
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
    message.message_element = message_ele.find(".chat-main__item");

    if (!!message.Uploaded_Files && message.Status == 1) {
        message.Uploaded_Files = JSON.parse(message.Uploaded_Files);
        loadAttachments(message.Uploaded_Files, message_ele.find(".chat-main__item"));

    }

    message_ele.children().appendTo(".chat-main__list")[0];



    if (!!last_unread_message_id) {
        let old_bar_exists = $("#markasread_active").length > 0;
        if (old_bar_exists) { return; }

        var insert_before_ele = $(".chat-main__list").find(`.chat-main__item[message_id=${last_unread_message_id}]`);


        let new_bar = new_messages_template.clone();
        new_bar.attr("id", "markasread_active");
        new_bar.insertBefore(insert_before_ele);
    }


    /*setTimeout(function () {

        var = $(`.chat-main__item[message_id=${message["Id"]}]`).find(".emoji_emoji").find("canvas")[0];
   
    
        particleAnimate(canvas);
        return;
    }, 100);*/
}
function reloadTimegaps(id) {

    if (!!id) {
        let timegaps = $(".chat-main__list").find(".time-gap");
        for (timegap_ele of timegaps) {
            timegap_ele = $(timegap_ele);
            if (!!timegap_ele.attr("message_id") && Number(timegap_ele.attr("message_id")) > id - 25) {
                timegap_ele.remove();
            }
        }
    }
    else {
        $(".chat-main__list").find(".time-gap").remove();
    }
    let messages = $(".chat-main__list").find(".chat-main__item");
    lastIndexedTime = !!id ? Saved_Messages[id].AtCreate : new Date();
    for (message_ele of messages) {
        message_ele = $(message_ele);
        let message_id = message_ele.attr("message_id");

        if (!!id && Number(message_id) < id - 25) { continue; }
        let message_data = Saved_Messages[message_id];
        if (!!!message_data || !getTimeGap(message_data.AtCreate)) {

            continue;
        }

        let formatted_time = FormatFuncs["_timestr_"](message_data);
        let formatted_date = FormatFuncs["_datestr_"](message_data);
        let ele = $(`  <div class="time-gap" style="_timegaptostyle_" message_id='${message_id}'>
                            <div class="timer">${formatted_date} ${formatted_time} </div>
                        </div>`);
        ele.insertBefore(message_ele);
    }

}
async function loadMessages(messages_data, scrollToBottomAtLoad, wipe_old_messages) {
    let old_pos = scroll_DOM.scrollHeight - scroll_DOM.scrollTop;
    var wiped = false;
    var last_message_id = Number($(".chat-main__list").find(".chat-main__item:last").attr("message_id"));
    renderingmessages = true;

    if (wipe_old_messages == true) {

        if (Math.min(...Object.keys(messages_data)) - 1 > last_message_id) {
            $(".chat-main__list").empty();
            wiped = true;
        }

    }
    if (wipe_old_messages == "1") {

        $(".chat-main__list").empty();
    }
    for ([key, message] of Object.entries(messages_data)) {

        await renderMessage(message);

    }
    setTimeout(reloadTimegaps, 10);
    renderingmessages = false;

    if (scrollToBottomAtLoad == true && focused) { setTimeout(scrollBottom, 0); }
    else {

        if (is_firsttime_load) { return; }
        scroll_DOM.scrollTo(0, scroll_DOM.scrollHeight - old_pos);



    }

    if (wiped) {
        console.log("Wiped old messages due to id gap");
        return;
    }
    const $children = $(".chat-main__list").children();


    const customSort = function (a, b) {
        const aNum = parseInt($(a).attr('message_id'));
        const bNum = parseInt($(b).attr('message_id'));
        return aNum - bNum;
    };


    $children.sort(customSort);

    $(".chat-main__list").append($children);


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

var loading_circle = $("#loading_circle");
function requestJsonData(afterid, scrollToBottomAtLoad, Wipe_Old_Messages) {
    return new Promise((resolve, reject) => {
        loading_circle.addClass("loader_show");
        $.ajax({
            url: 'Message.aspx/GetMessageJsonData',
            type: 'POST',
            contentType: 'application/json',
            dataType: 'json',
            data: JSON.stringify({ page: afterid }),
            success: async function (response) {
                if (!scrollToBottomAtLoad) {
                    var oldpos = getScrollPos();
                }
                let wipe_old_messages = !!Wipe_Old_Messages ? Wipe_Old_Messages : (afterid == -1 && scrollToBottomAtLoad == true);
                loading_circle.removeClass("loader_show");
                var data = JSON.parse(response.d);
                await loadMessages(data, scrollToBottomAtLoad, wipe_old_messages);

                var count = Object.keys(data).length;
                data = null;

                resolve(count > 0);
            },
            error: function (xhr, status, error) {

                console.error(error);
                reject(error);
            }
        });
    });
}
const DeleteMessage = function (data) {

    data = JSON.parse(data);
    let message_id = data.id;
    let status = data.status;
    console.log(message_id);
    console.log(status);

    let deleting_ele_par_ele = $(`.chat-main__item[message_id=${message_id}]`);
    deleting_ele_par_ele.find(".attached_files").empty();
    deleting_ele_par_ele.find(".chat-item__box").attr("drop_hidden", "true");
    let deleting_ele = deleting_ele_par_ele.find(".mess_content");
    deleting_ele.addClass("italic");
    let deleted_mess =
        status == -1 ? "Tin nhắn đã được thu hồi bởi quản trị viên" : "Tin nhắn đã được thu hồi";
    deleting_ele.text(deleted_mess);

}

var sendCD = false;
function sendMessage() {
    if (sendCD || inputElement.val() == "" && fileArray.length == 0) { return; }
    sendCD = true;

    const formData = new FormData();
    fileArray.forEach((file, index) => {
        console.log(file);
        formData.append(`file${index}`, file);
    })
    formData.append('content', inputElement.val());
    console.log(formData.getAll('content'));
    $.ajax({
        url: 'Message.aspx/SendMessage',
        type: 'POST',
        processData: false,
        contentType: false,

        data: formData,
        success: function (response) {


        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }
    });

    inputElement.val("");
    fileArray = [];
    $("#uploadPreview").empty();
    setTimeout(function () { inputElement.blur(); }, 1);
    let canScrollBottom = latest_message_id == findLatestMessageId() + 1;
    if (canScrollBottom && (getScrollPos() < scroll.clientHeight / 2 && focused)) {

        console.log("Scrolled bottom on new message....");
        setTimeout(function () {
            markasread(null, false);
            scrollBottom();
        }, 0);
    }
    $(".chat-footer").css("height", "0px");
    sendCD = false;
}





function AssignNewNum(num, emoji_display_ele, key) {
    var ncount = emoji_display_ele.find(".ncount");
    var ogcount = emoji_display_ele.find(".ogcount");

    let last_num = last_num_list[key];

    var islarger = last_num >= num;



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
    AssignNewNum(data.Reaction_Ids.length, emoji_display, message_id + '' + emoji_id);
}

setTimeout(async function () {
    await fetchUser();

    await loadFirstMessages();


}, 0);





async function markasread(event, scroll_bottom) {
    if (event != null) event.stopPropagation();

    unread_messages_ele.css("display", "none");
    $(".new_messages").remove();
    last_unread_message_id = null;
    if (scroll_bottom) {
        if (latest_message_id == findLatestMessageId()) {
            setLastRenderedMessageCache(latest_message_id);


            await requestJsonData(Number(id) + 11, false, "1");

            let mess_to_scroll_to = Saved_Messages[id].message_element;
            scroll.scrollTo(0, mess_to_scroll_to[0].offsetTop - scroll.clientHeight / 2);
            return;
        }
        loading_circle.addClass("loader_show");
        requestJsonData(-1, true);

    }
    else {
        setLastRenderedMessageCache(latest_message_id);
    }
}

const forceScrollBottom = async function () {

    if (findLatestMessageId() == latest_message_id) {
        scrollBottom();
        $("#scroll_message_bottom").css("display", "none");
        return;
    }
    loading_circle.addClass("loader_show");

    await requestJsonData(-1, true, "1");
    loadedbottom = true;
    $("#scroll_message_bottom").css("display", "none");
    scrollBottom();
    loading_circle.removeClass("loader_show");



}