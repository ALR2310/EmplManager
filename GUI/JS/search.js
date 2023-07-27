let search_bxb = $("#search-box");
let open_btn = $("#search_open");
let search_cancel_btn = $("#search_cancel");

let search_message_list = $("#chat-search__list");

let placehold_layout = $("#search__list_placeholder_layer");

search_message_list.css("display", 'flex');
let searching_thread = null;

let require_reload_placehold = false;

function getRandomNumberBetween(min, max) {
    return Math.random() * (max - min) + min;
}

async function renderSearchMessage(id,message) {
    const message_ele = $("#chat-template").clone();
    var finalhtml = message_ele.html();
    message.AtCreate = new Date(message.AtCreate);
    

    finalhtml = finalhtml.replaceAll("_timestr_", "_timestr_, _datestr_");
    for ([replaceTargetstr, formatFunc] of Object.entries(FormatFuncs)) {
        finalhtml = finalhtml.replaceAll(replaceTargetstr, await formatFunc(message, message_ele));
    }



    message_ele.html(finalhtml);
    let chat_main__item = message_ele.find(".chat-main__item");

    chat_main__item.addClass("to_delete fake_chat");
    chat_main__item.find(".emoji_list").remove();
    chat_main__item.append("<div class='fc_jump_to'>đi tới tin nhắn</div>");
    chat_main__item.on("click", async function () {
        console.log(id);
        loading_circle.addClass("loader_show");
        is_firsttime_load = true;
       
 
        await requestJsonData(Number(id) + 11, false, "1");   
        
        let mess_to_scroll_to = Saved_Messages[id].message_element;
        scroll.scrollTo(0, mess_to_scroll_to[0].offsetTop - scroll.clientHeight / 2);
        mess_to_scroll_to.removeClass("message_highlight");
        setTimeout(function () {
            mess_to_scroll_to.addClass("message_highlight");
            console.log("AAH");
            mess_to_scroll_to.on(
                "webkitAnimationEnd oanimationend msAnimationEnd animationend",
                function () {
                    console.log("A");
                    $(this).removeClass("message_highlight").dequeue();
                  
                }
            );
        }, 0);
        loadedbottom = false;
        renderingmessages = false;
        is_firsttime_load = false;
        setTimeout(function () {
            lastRenderedMessage = findLatestMessageId();
        }, 100);

     
        $("#chat-search__list").css("display", "none");
    });
    message_ele.find(".time-gap").remove();
    message["message_element"] = message_ele.find(".chat-main__item");
    message_ele.children().appendTo("#fake_messages")[0];

}
const phsts = {
    title:{
        MIN_WORD_LENGTH: 4,
        MAX_WORDS: 4,
        MAX_WORD_LENGTH:24,
        MAX_FIELD_LENGTH: 30,
    },
    content: {
        MIN_WORD_COUNT:1,
        MIN_WORD_LENGTH:5,
        MAX_WORDS:15,
        MAX_WORD_LENGTH:15,
        MAX_FIELD_LENGTH: 100
    }
}
let search_loading_placeholder_template = $("#search_loading_placeholder_template");
function createFakeChatBox() {
    let chatbox = search_loading_placeholder_template.clone();
    chatbox.attr("id", "");
    chatbox.addClass("to_delete")

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
    console.log(word_count);
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
    $(".to_delete").remove();
    require_reload_placehold = true;

    for (let x = 1; x <= 5; x++) {

    
        createFakeChatBox();
    }
    placehold_layout.css("display", "flex");
}
let perfom_search = function (query) {

    $.ajax({
        url: 'Message.aspx/SearchMessage',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: JSON.stringify({ search_str: query, page: 1 }),
        success: async function (response) {
            let data = JSON.parse(response.d);
         
            if (Object.keys(data).length == 0) {
  
                placehold_layout.css("display", "none");
                $("#search_not_found").css("display", "unset"); return;
            }
            for (const [id, message] of Object.entries(data)) {
                await renderSearchMessage(id, message);
            };
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
search_bxb.on("input", function () {
    if (search_bxb.val().trim() != "") {
        $("#search_not_found").css("display", ""); 
        $(".to_delete").remove();
        open_btn.css('display', 'none');
        search_cancel_btn.css('display', 'unset');
        search_message_list.css("display", "flex");
        showplacehold();

        clearTimeout(searching_thread);
        searching_thread = setTimeout(function () {
            require_reload_placehold = false;
            let query = search_bxb.val().trim();
      
            console.log("Search Query: " + search_bxb.val().trim());
            perfom_search(query);
        }, 250);
        return;
    }
    open_btn.css('display', 'unset');
    search_cancel_btn.css('display', 'none');
    search_message_list.css("display", "none");
})
showplacehold();
setTimeout(function () {
    perfom_search("hen");
}, 500);

var btnSearch = document.querySelector('#search_open');
var btnSearchCancel = document.querySelector("#search_cancel");
var searchInput = document.querySelector('.chat__search-box__input');
var counter = 0;


let should_focus = false;

search_cancel_btn.on('mousedown touchstart', function (event) {

    should_focus = search_bxb.is(":focus");
    event.stopPropagation();
    search_bxb.val("");
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

    if (ele.attr("id") != "search-box" && ele.closest("#chat-search__list").length == 0) {
        $("#chat-search__list").css("display", "none");
    }
    else {
        $("#chat-search__list").css("display", "flex");
    }
    if (ele.hasClass("fa-face-smile")) {
        return;
    }
    
    toggleEmoji(event, 'none');
  
})