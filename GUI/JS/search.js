let search_bxb = $("#search-box");
let open_btn = $("#search_open");
let search_cancel_btn = $("#search_cancel");

let search_message_list = $("#chat-search__list");

search_bxb.on("input", function () {
  if (search_bxb.val().trim() != "") {
    open_btn.css('display', 'none');
    search_cancel_btn.css('display', 'unset');
    return;
  }
  open_btn.css('display', 'unset');
  search_cancel_btn.css('display', 'none');
})

var btnSearch = document.querySelector('#search_open');
var btnSearchCancel = document.querySelector("#search_cancel");
var searchInput = document.querySelector('.chat__search-box__input');
var counter = 0;


let should_focus = false;
search_cancel_btn.on('mousedown touchstart', function (event) {
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
btnSearch.addEventListener('click', function () {
  this.parentElement.classList.toggle('open');
  this.previousElementSibling.focus();
  this.parentElement.classList.remove("not_loaded");

  if (counter === 0) {

    search_bxb.focus();


    counter = 1;
  } else {
 
    search_bxb.blur();

    counter = 0;
  }
  should_focus = search_bxb.is(":focus");
})

