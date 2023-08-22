const SEARCH_USER_NAME_COOLDOWN = 60;

let search_bxb = $("#search-box");
let open_btn = $("#search_open");
let search_cancel_btn = $("#search_cancel");

let search_message_list = $("#chat-search__list");

let placehold_layout = $("#search__list_placeholder_layer");

var search_last_span = search_bxb.find("#search_last_span");

let searching_thread = null;

let require_reload_placehold = false;

function getRandomNumberBetween(min, max) {
    return Math.random() * (max - min) + min;
}

async function renderSearchMessage(id, message) {

    message.AtCreate = new Date(message.AtCreate);
    const message_ele = $("#chat-template").clone();
    var finalhtml = message_ele.html();



    finalhtml = finalhtml.replaceAll("_timestr_", "_timestr_, _datestr_");
    for ([replaceTargetstr, formatFunc] of Object.entries(FormatFuncs)) {
        finalhtml = finalhtml.replaceAll(replaceTargetstr, await formatFunc(message, message_ele));
    }



    message_ele.html(finalhtml);
    let chat_main__item = message_ele.find(".chat-main__item");


    if (!!message.Uploaded_Files) {
        message.Uploaded_Files = JSON.parse(message.Uploaded_Files);
        loadAttachments(message.Uploaded_Files, message_ele.find(".chat-main__item"),true);


    }

    chat_main__item.addClass("to_delete fake_chat fake_chat_anim");
    chat_main__item.on(
        "webkitAnimationEnd oanimationend msAnimationEnd animationend",
        function () {

            $(this).removeClass("fake_chat_anim");

        }
    );



    chat_main__item.find(".emoji_list").remove();
    chat_main__item.append("<div class='fc_jump_to'>đi tới tin nhắn</div>");
    chat_main__item.on("click", async function (event) {
        if (event.target.tagName.toLowerCase() == "img") return;
        loading_circle.addClass("loader_show");

        await requestJsonData(Number(id) + 11, false, "1");
        console.log(Saved_Messages[id]);
        let mess_to_scroll_to = Saved_Messages[id].message_element;
        loading_scrolling_bottom_cancel = true;
        scroll.scrollTo(0, mess_to_scroll_to[0].offsetTop - scroll.clientHeight / 4);

        mess_to_scroll_to.removeClass("message_highlight");
        setTimeout(function () {
            mess_to_scroll_to.addClass("message_highlight");

            mess_to_scroll_to.on(
                "webkitAnimationEnd oanimationend msAnimationEnd animationend",
                function () {

                    $(this).removeClass("message_highlight").dequeue();

                }
            );

        }, 0);

        setTimeout(function () {
            lastRenderedMessage = findLatestMessageId();

        }, 100);


        $("#chat-search__list").css("display", "none");
        getClosestChatElementFromWindow();
    });
    message_ele.find(".time-gap").remove();

    message_ele.children().appendTo("#fake_messages")[0];

}
const phsts = {
    title: {
        MIN_WORD_LENGTH: 4,
        MAX_WORDS: 4,
        MAX_WORD_LENGTH: 24,
        MAX_FIELD_LENGTH: 30,
    },
    content: {
        MIN_WORD_COUNT: 1,
        MIN_WORD_LENGTH: 5,
        MAX_WORDS: 15,
        MAX_WORD_LENGTH: 15,
        MAX_FIELD_LENGTH: 100
    }
}
let search_loading_placeholder_template = $("#search_loading_placeholder_template");
function createFakeChatBox() {
    let chatbox = search_loading_placeholder_template.clone();
    chatbox.attr("id", "");
    chatbox.addClass("FakeChatBox_to_delete")

    let title_ph = chatbox.find(".titles.placeholder_boxes_holder");
    let title_total_word = 0;

    for (let i = 1; i < phsts.title.MAX_WORDS; i++) {

        let space_count = Math.round(getRandomNumberBetween(phsts.title.MIN_WORD_LENGTH, phsts.title.MAX_WORD_LENGTH));
        title_total_word += space_count;
        if (title_total_word > phsts.title.MAX_FIELD_LENGTH) break;

        let ele = $(`<div>${"&nbsp;".repeat(space_count)}</div>`);

        title_ph.append(ele);
    }
    let word_count = getRandomNumberBetween(phsts.content.MIN_WORD_COUNT, phsts.content.MAX_WORDS);
    let content_ph = chatbox.find(".placeholder_content_boxes.mess_content");
    title_total_word = 0;

    for (let i = 1; i < word_count; i++) {

        let space_count = Math.round(getRandomNumberBetween(phsts.content.MIN_WORD_LENGTH, phsts.content.MAX_WORD_LENGTH));
        title_total_word += space_count;
        if (title_total_word > phsts.content.MAX_FIELD_LENGTH) { break };

        let ele = $(`<div>${"&nbsp;".repeat(space_count)}</div>`);

        content_ph.append(ele);
    }



    chatbox.insertAfter(search_loading_placeholder_template);
}
function showplacehold() {


    if (require_reload_placehold) { placehold_layout.css("display", "flex"); return; }
    $(".FakeChatBox_to_delete").remove();

    require_reload_placehold = true;

    for (let x = 1; x <= 5; x++) {


        createFakeChatBox();
    }
    placehold_layout.css("display", "flex");
}
let last_search_request = null;

$("#search_previous_button").on("click", function () {
    if (current_page <= 1) { return; }
    clearSearchResults();
    perfom_search(current_query, current_page - 1);
})
$("#search_next_button").on("click", function () {
    if (current_page >= max_page) { return; }
    clearSearchResults();
    perfom_search(current_query, current_page + 1);
})
var max_page = 0;
var current_page = 1;
var current_query;


function parseSearchOption() {
    let option = {}
    for (const [key, values] of Object.entries(searching_options)) {
        let temp_val = [];
        for (const [sub_key, num] of Object.entries(values)) {
            if (num == 0) continue;
            temp_val.push(sub_key);
        }
        if (temp_val.length != 0) option[key] = temp_val;
    }
    return option;
}
let perfom_search = function (query, page) {
    console.log("Searching");
    page = page || 1;
    current_page = page;
    current_query = query;
    if (!!last_search_request) { last_search_request.abort(); }


    last_search_request = $.ajax({
        url: 'Message.aspx/SearchMessage',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ search_str: query, option: parseSearchOption(), page: page }),
        success: async function (response) {
            let data = JSON.parse(response.d);

            if (data.Results == 0) {

                placehold_layout.css("display", "none");
                $("#fake_messages").css("display", "none");
                $("#search_not_found").css("display", "unset"); return;
            }
            $("#fake_messages").css("display", "");
            let keys = Object.keys(data);

            max_page = Math.ceil(data.Results / 10);
            $("#search_previous_button").toggleClass("button_disabled", current_page <= 1);
            $("#search_next_button").toggleClass("button_disabled", current_page >= max_page);

            $("#search_messages_pages").css("display", data.Results < 10 ? "none" : "");


            $(`<span class='chat-main__item to_delete'>Kết quả: ${data.Results.toString()} Tin Nhắn</span>`).appendTo("#fake_messages");
            for (const [id, message] of Object.entries(data).reverse()) {

                if (isNaN(id)) {

                    continue;
                }

                await renderSearchMessage(Number(id), message);
            };
            $("#search_messages_pages").appendTo("#fake_messages");
            $("#numberic_buttons").empty();
            let min_page = Math.max(1, page - 1);
            for (let cur_page = min_page; cur_page < min_page + 3; cur_page++) {
                if (cur_page > max_page) break;
                let span = $(`<span ${cur_page == page ? "class='highlight'" : ""}>${cur_page}</span>`);
                span.appendTo("#numberic_buttons");
                if (cur_page == page) continue;
                span.on("click", function () {
                    clearSearchResults();
                    perfom_search(query, cur_page);
                })
            }
            setTimeout(function () {
                placehold_layout.css("display", "none");

            }, 100);


        },
        error: function (xhr, status, error) {
            // Handle any errors
            console.error(error);
        }

    });
}
function clearSearchResults() {
    $("#search_not_found").css("display", "");

    $(".to_delete").remove();
    open_btn.css('display', 'none');
    search_cancel_btn.css('display', 'unset');
    search_message_list.css("display", "flex");
    showplacehold();
}
const search_option_menu = $("#search_option");

let last_input_txt = null;
let last_query;
function search_box_input() {
  
    let cur_text = search_last_span.text().trim();

    let search_option_length = Object.keys(parseSearchOption()).length != 0;
    console.log(search_option_length);
    if (last_input_txt != cur_text && cur_text.length > 0 || search_option_length) {
        last_input_txt = cur_text;
      
        clearSearchResults();
        clearTimeout(searching_thread);
        searching_thread = setTimeout(function () {
            require_reload_placehold = false;
            let query = search_last_span.text().trim();
            last_query = query;
            console.log("Search Query: " + search_last_span.text().trim());
            perfom_search(query);
        }, 250);
        return;
    }
    if (cur_text != "" || search_option_length) { return; }
    last_input_txt = cur_text;
    open_btn.css('display', 'unset');
    search_cancel_btn.css('display', 'none');
    search_message_list.css("display", "none");
    search_option_menu.css("visibility", "visible");

}


var btnSearch = document.querySelector('#search_open');
var btnSearchCancel = document.querySelector("#search_cancel");
var searchInput = document.querySelector('.chat__search-box__input');
var counter = 0;


let should_focus = false;

search_cancel_btn.on('mousedown', function (event) {

    searching_options = __default_searching_options;
    search_bxb.children("div").remove();
    should_focus = search_bxb.is(":focus");
    event.stopPropagation();
    search_last_span.text("");
    console.log(should_focus);

    open_btn.css('display', 'unset');
    search_cancel_btn.css('display', 'none');
    setTimeout(function () {
        if (should_focus) search_bxb.focus();

    }
        , 0);


});

let clckcd = false;
btnSearch.addEventListener('mousedown', function () {

    if (clckcd) return; clckcd = true;
    setTimeout(function () { clckcd = false; }, 100);
    this.parentElement.classList.toggle('open');

    this.parentElement.classList.remove("not_loaded");
    search_option_menu.css("visibility", this.parentElement.classList.contains("open") ? "visible" : "");


    if (counter === 0) {

        setTimeout(function () {
            search_bxb.focus();
            should_focus = true;
        }
            , 0);



        counter = 1;
    } else {
        search_message_list.css("display", "none");
        search_bxb.blur();
        this.previousElementSibling.focus();
        counter = 0;
    }

})



$(document).on("click", function (event) {
    var ele = $(event.target);

    if (ele.closest("#MediaMenu").length != 0) return;
    if (ele.attr("id") != "search-box" && ele.closest("#search-box").length == 0 &&
        ele.closest("#chat-search__list").length == 0 && ele.closest(".search_option_menu").length == 0) {

        $("#chat-search__list").css("display", "none");
    }
    else if (last_query != null && last_query == last_input_txt) {
        $("#chat-search__list").css("display", "flex");
    }
    if (ele.hasClass("fa-face-smile")) {
        return;
    }

    toggleEmoji(event, 'none');

})

$(document).ready(function () {

    let styleSheet = null;
    let current_href = window.location.hostname;
    for (const [_, rule] of Object.entries(document.styleSheets)) {
        let urlObject = new URL(rule.href);

        // Get the hostname
        let hostname = urlObject.hostname;

        if (hostname == current_href) {
            styleSheet = rule;
            break;
        }
    }

    for (i = 1; i <= 25; i++) {
        var newRule = `.fake_chat_anim:nth-child(${i}) {
               animation-delay: ${.15 * (Math.min(i, 5) - 1)}s !important;
        } `;


        if (styleSheet.insertRule) {

            styleSheet.insertRule(newRule, styleSheet.cssRules.length);
        } else if (styleSheet.addRule) {

            styleSheet.addRule(newRule, styleSheet.rules.length);
        }
    }

});
var search_last_span = $("#search_last_span");
let last_input = null;
function setEmptyStr(event) {
    search_option_menu.css("visibility", "unset");
    const key = event.key;
    const isAlphaNumeric = /^[a-zA-Z0-9!@#$%^&*()_+~":<>?|}{\[\]=]$/i.test(key);


    if (event.key == "Enter") {
        $(".search_option_menu").css("visibility", "hidden");
    
        search_option_menu.css("visibility", "");
        clearSearchResults();
        let query = search_last_span.text().trim();
        last_query = query;
        console.log("Search Query: " + search_last_span.text().trim());
        perfom_search(query);
        return;
    }
    if (key == "Backspace" && search_last_span.text().trim() == "" && search_last_span.prev().length != 0) {

        setTimeout(function () {
            selectLastText(search_last_span.prev()[0]);
            search_last_span.prev().focus();
            search_last_span.prev().click();
        }, 0);

    }

    setTimeout(function () {

  
    
        const new_input = last_input != search_last_span[0].textContent;

        last_input = search_last_span[0].textContent;

       
       




        let ele = $(event.target);


       

    }
        , 0);

}
function selectLastText(raw_element, specific_pos) {

    var selection = window.getSelection();
    var range = document.createRange();




    const txt_length = specific_pos || raw_element.textContent.length;

    let node = $(raw_element).contents()[0];

    if (!node) {
        return;
    }

    range.selectNodeContents(node);

    range.setStart(node, txt_length);
    range.setEnd(node, txt_length);


    selection.removeAllRanges();
    selection.addRange(range);

}
const search_option_text = {
    "from": "Từ:",
    "mention": "Đề cập:",
    "has": "Có:",
}

var current_search_options = {

}


console.log($("#search_option").find("a"));
function a_tag_sort(a, b) {
    return !!a.getAttribute("id") && 1 || !!b.getAttribute("id") && -1;
}
const display_values = {
    "has": {
        "_title": "Tin nhắn có chứa: ",
        "Tệp, File": "file",
        "Video": "video",
        "Ảnh": "image",
        "Link": "link"
    }
}

for (const [value_name, sub_values] of Object.entries(display_values)) {
    const div = $(`<div id="${value_name}_table" class="search_option_menu">
                            <span>${sub_values["_title"]}</span>
                            <hr>
                          
                        </div>`);
    for (const [display_name, sub_value] of Object.entries(sub_values)) {
        if (display_name == "_title") { continue; }
        const a_val = $(`<a value="${sub_value}">${display_name}<img src="Images/Icons/plus.svg"></a>`);
        a_val.appendTo(div);
        sub_values[display_name.toLowerCase()] = sub_value;
        delete sub_values[display_name];
    }
    div.appendTo("#popup_layout");
}

let from_user_options = $("#from_table");
let search_option_user_template = $(` <a id="search_option_user_template" value="random_id">
                                <div>
                                    <img class="search_avatar_image" src="/Images/Avatar/Uploads/U_25562.svg"/>
                                    <span>Nguyễn Trường Sơn</span></div>
                                <img src="Images/Icons/plus.svg"></a>`);


function display_fetched_users(parentEle,searchingName) {
    let filtered_keys = Object.keys(Users).filter(key => Users[key].DisplayName.includes(searchingName));
    parentEle.children("a").remove();
    for (const id of filtered_keys) {
        if (id == "CLIENT_USER") continue;

        const user = Users[id];
        let cloned_field = search_option_user_template.clone();

        let div = cloned_field.find("div");
        div.find("img").attr("src", Users[id].Avatar);
        div.find("span").text(Users[id].DisplayName);

        cloned_field.attr("id", "");
        cloned_field.appendTo(parentEle);

        cloned_field.on("click", function () {
            let search_option = editingSpan.getAttribute("option_name");
            console.log(search_option);
            if (!(search_option == "from" || search_option == "mention")) return;
            editingSpan.textContent = editingSpan.getAttribute("og_txt") + " " + user.DisplayName;
            applySOV(editingSpan,search_option,null,id);

            $(editingSpan).next().focus();
            search_box_input();
        });
  
    }

}


const text_change_function = {
    "from": async function (text) {
        console.log("Called");
        display_fetched_users(from_user_options, text);
        if(fetched_name[text] == null || tick() - fetched_name[text]  > SEARCH_USER_NAME_COOLDOWN ){
            await fetchMissingUsers(text);
            display_fetched_users(from_user_options, text);
        }
       
    }
}
const specific_option_menu = {
    "has": $("#has_table"),
    "from": $("#from_table"),
}
const __default_searching_options = {
    has: {
        link: 0,
        image: 0,
        file: 0,
        video: 0
    },
    from: {

    }
};
var searching_options = {
    has: {
        link: 0,
        image: 0,
        file: 0,
        video: 0
    },
    from: {

    }
};

let editingSpan = null;
for (const [value_name, option_menu] of Object.entries(specific_option_menu)) {
    for (let child_ele of option_menu.children("a")) {

        child_ele = $(child_ele);

        child_ele.on("click", function () {
            if (!!!editingSpan) return;



            editingSpan.textContent = editingSpan.getAttribute("og_txt") + " " + (child_ele.attr("display_value") || child_ele.text());
            console.log(editingSpan);

            option_menu.css("visibility", "hidden");
            if (editingSpan.getAttribute("sov") != null && editingSpan.getAttribute("sov") != "") {
                console.log("Deleted old Searching option value");
                const [old_option, old_val] = editingSpan.getAttribute("sov").split("|||");
                console.log(old_option);
                console.log(old_val);
                searching_options[old_option][old_val] = 0;

            }
            let search_option_value = value_name + "|||" + child_ele.attr("value");
            $(`.search_option_edit[sov='${search_option_value}']`).parent().remove();
            editingSpan.setAttribute("sov", search_option_value);


            searching_options[value_name][child_ele.attr("value")] = 1;
     
            setTimeout(function () {
                search_message_list.css("display", "flex");
            }
                , 0);
            $(editingSpan).next().focus();
            search_box_input();
        });
    }
}
function getPos(txt_length) {
    const selection = window.getSelection();

    const range = selection.getRangeAt(0);
    const startPosition = range.startOffset;
    const endPosition = range.endOffset;


    if (startPosition == endPosition && (startPosition == 0 || startPosition == txt_length)) {
        return startPosition;
    }

}
const checkCursorPos = function (event) {
    if (event.keyCode != '37' && event.keyCode != '39') { return; }
    const target = $(event.target);
    event = null;
    const txt_length = target.text().length;
    const old_pos = getPos(txt_length);


    if (old_pos == null) { return; }
    setTimeout(function () {
        const new_pos = getPos(txt_length);
        if (old_pos != new_pos) {

            return;
        }
        console.log(new_pos);
        console.log(old_pos);
        if (new_pos == 0 && target.prev().length != 0) {

            setTimeout(function () {
                selectLastText(target.prev()[0]);
                target.prev().focus();
                target.prev().click();
            }, 0);

        }
        else if (new_pos == txt_length && target.next().length != 0) {
            setTimeout(function () {
                selectLastText(target.next()[0], 1);
                target.next().focus();
                target.next().click();
            }, 0);
        }
    }, 0);

};
let observer = new MutationObserver(_ => {



    if (search_last_span.text().length == 0) {
        search_option_menu.css("visibility", "unset");
        return;
    }
    search_box_input();
});
observer.observe($("#search_last_span")[0], { characterData: true, attributes: false, childList: false, subtree: true });

function hide_option_menus() {
    for (const [_, option_menu] of Object.entries(specific_option_menu)) {
        option_menu.css("visibility", "hidden");
    }
}
$("#search_last_span").on("focus click", function () {

    $(".search_option_menu").css("visibility", "hidden");
    if (search_last_span.text().length == 0) {
        search_option_menu.css("visibility", "unset");
    }


});
function applySOV(editingSpan, search_option, new_text, rv) {
    let real_value = rv || display_values[search_option][new_text];

    if (real_value != null) {

        if (editingSpan.getAttribute("sov") != null && editingSpan.getAttribute("sov") != "") {
            console.log("Deleted old Searching option value");
            const [old_option, old_val] = editingSpan.getAttribute("sov").split("|||");
            console.log(old_option);
            console.log(old_val);
            searching_options[old_option][old_val] = 0;
    
        }

        let search_option_value = search_option + "|||" + real_value;
        $(`.search_option_edit[sov='${search_option_value}']`).parent().remove();
        editingSpan.setAttribute("sov", search_option_value);
        console.log(  searching_options[search_option]);
        console.log(real_value);
        searching_options[search_option][real_value] = 1;
    }


}
search_option_menu.find("a").on("click", function (event) {
    console.log(event.target);
    let click_event = $(event.target);
    const search_option = click_event.attr("search_option");
    if (!search_option) { return; }

    const display_txt_lower = search_option_text[search_option].toLowerCase() + " ";
    let str = `<div autocomplete='off' onkeydown="checkCursorPos(event);" tabindex="100"  spellcheck='false' og_txt="${search_option_text[search_option]}" contenteditable="true" autocorrect='off'>${search_option_text[search_option]}&nbsp;</div>`;
    const element = $(str);

    search_box.append(element);


    editing_span = element


    search_last_span.appendTo(search_box);

    element.on("click", function (event) {
        console.log("a");
        if (event.target != element[0]) {
            selectLastText(element[0]);
        }
    });

    const min_length = search_option_text[search_option].length;
    const observer = new MutationObserver(_ => {
    
        let new_text = editing_span.text().toLowerCase();
        new_text = new_text.replace(display_txt_lower, "");
        console.log(new_text);
        (text_change_function[search_option] && text_change_function[search_option](new_text));

        if (display_values[search_option] != null) {
            applySOV(element[0],search_option,new_text);
        }
       
        
        if (element.text().length < min_length + 1) {
    
            specific_option_menu[search_option].css("visibility", "hidden");


            let prev = element.prev();
            if (element.prev().length != 0) {
                setTimeout(function () {

                    prev.focus();
                    prev.click();
                    selectLastText(prev[0]);
                }, 0);
            }
            else {
                element.next().focus();
                element.next().click();

            }
            editing_span.remove();
        };

    });

    (text_change_function[search_option] && text_change_function[search_option](""));

    editing_span = $(editing_span);

    observer.observe(editing_span[0], { characterData: true, attributes: false, childList: false, subtree: true });

    element.attr("option_name",search_option);
    element.on("focus click change select", function (event) {
        hide_option_menus();
        console.log(specific_option_menu);
        specific_option_menu[search_option].css("visibility", "unset");
        search_option_menu.css("visibility", "hidden");
        editingSpan = element[0];
    });





    element.focusin(function () {
        hide_option_menus();
    })


    selectLastText(element[0]);
    element.click();
});
open_btn.on("click", function () {
    search_last_span.focus();
    search_last_span.click();
});
function closeSearchOption_Main(event) {
    event.preventDefault();
    event.stopPropagation();
    console.log("Brah");
    search_option_menu.css("visibility", "hidden");
   
}
function tick() {
    return Date.now()/1000;
}
const fetched_name = {};
const fetchMissingUsers = async function (search_name) {
  
    if (!!fetched_name[search_name] && tick() - fetched_name[search_name] < SEARCH_USER_NAME_COOLDOWN) {
        return;
    }
    fetched_name[search_name] = tick();
    const response = await fetch("Message.aspx/SearchUsers", {
        "headers": {
            "accept": "application/json, text/javascript, */*; q=0.01",
            "content-type": "application/json",

        },


        "body": JSON.stringify({name: search_name}),
        "method": "POST",
        "mode": "cors",
        "credentials": "include"
    })
    var data = await response.json();
    for (user of data.d) {
   
        if (!Users[user.Id]) {
            Users[user.Id] = user;
        }
    }
    return data;
}