let search_bxb = $("#search-box");
let open_btn = $("#search_open");
let search_cancel_btn = $("#search_cancel");

let search_message_list = $("#chat-search__list");

let placehold_layout = $("#search__list_placeholder_layer");

//search_message_list.css("display", 'none');
let searching_thread = null;

let require_reload_placehold = true;


const phsts = {
    title:{
        MIN_WORD_LENGTH: 2,
        MAX_WORDS: 4,
        MAX_WORD_LENGTH:27,
        MAX_FIELD_LENGTH: 27,
    },
    content:{
        MIN_WORD_LENGTH:1,
        MAX_WORDS:25,
        MAX_WORD_LENGTH:10,
        MAX_FIELD_LENGTH:100
    }
}
let search_loading_placeholder_template = $("#search_loading_placeholder_template");
function createFakeChatBox() {
    var chatbox = search_loading_placeholder_template.clone();
    for (let i = 1; i < phsts.title.MAX_WORDS; i++) {
       
    }
    chatbox.insertAfter(search_loading_placeholder_template);
}
function showplacehold() {
    placehold_layout.css("display", "unset");
    if (require_reload_placehold) { return; }
    require_reload_placehold = true;

    for (let x = 1; x < 11; x++) {

    
        createFakeChatBox();
    }
}

search_bxb.on("input", function () {
    if (search_bxb.val().trim() != "") {
        open_btn.css('display', 'none');
        search_cancel_btn.css('display', 'unset');
        search_message_list.css("display", "unset");
        showplacehold();

        clearTimeout(searching_thread);
        searching_thread = setTimeout(function () {
            require_reload_placehold = false;
            let query = search_bxb.val().trim();
           //placehold_layout.css("display", "none");
            console.log("Search Query: " + search_bxb.val().trim());
            $.ajax({
                url: 'Message.aspx/SearchMessage',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                data: JSON.stringify({ search_str: query, page: 1 }),
                success: function (response) {
                    console.log(JSON.parse(response.d));
                },
                error: function (xhr, status, error) {
                    // Handle any errors
                    console.error(error);
                }
             
            });
        }, 250);
        return;
    }
    open_btn.css('display', 'unset');
    search_cancel_btn.css('display', 'none');
    search_message_list.css("display", "none");
})

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

