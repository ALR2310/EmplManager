let search_bxb = $("#search-box");
let open_btn = $("#search_open");
let search_cancel_btn = $("#search_cancel");

let search_message_list = $("#chat-search__list");

search_message_list.css("display", 'none');
let searching_thread = null;
search_bxb.on("input", function () {
    if (search_bxb.val().trim() != "") {
        open_btn.css('display', 'none');
        search_cancel_btn.css('display', 'unset');
        search_message_list.css("display", "unset");

        clearTimeout(searching_thread);
        searching_thread = setTimeout(function () {
            let query = search_bxb.val().trim();
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

