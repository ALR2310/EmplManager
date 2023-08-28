//js tự động cuộn xuống item cuối của khung chat
function scrollToBottom() {
    var chatList = document.querySelector('.chat-main__list');
    chatList.scrollTop = chatList.scrollHeight;
}


//js đặt height cho textarea khi có nội dung nhiều hơn
var chatInput = document.querySelector("#txt_Message")

var chatInput_jqr = $(chatInput);

let selection = null;
let old_content_pos = 0;
function applyRange(old_start, old_end) {
    console.log(old_content_pos);
    let old_container = chatInput_jqr.contents()[old_content_pos];
    console.log(old_container.nodeName);
    if (old_container.nodeName != "#text") {
        old_container = $(old_container).contents()[0];
    }

    let new_range = document.createRange();
    new_range.selectNodeContents(old_container);


    console.log(old_start);
    console.log(old_end)
    new_range.setStart(old_container, old_start);
    new_range.setEnd(old_container, old_end);



    selection.removeAllRanges();
    selection.addRange(new_range);
}
let old_text_length = 0;
chatInput.addEventListener('input', function () {

    selection = document.getSelection();
    const old_range = document.getSelection().getRangeAt(0);
    const old_start = old_range.startOffset;
    const old_end = old_range.endOffset;
    const old_ele = old_range.startContainer;

    old_content_pos = chatInput_jqr.contents().toArray().indexOf(old_ele);


    setTimeout(function () {


        let raw_text = chatInput_jqr.text();



        let converted = wrapLinksIntoAnchorTags(raw_text);

        chatInput_jqr.html(converted);



        applyRange(old_start, old_end);
    }, 0);



    if (chatInput.textContent.trim() === "")    {
        chatInput.parentNode.style.height = "40px";
        chatInput.parentNode.parentNode.style.height = "40px";
    }
    else {
        chatInput.parentNode.style.height = "auto";
        chatInput.parentNode.parentNode.style.height = "auto";
        chatInput.parentNode.style.height = `${chatInput.scrollHeight}px`;
        chatInput.parentNode.parentNode.style.height = `${chatInput.scrollHeight + 29}px`;
    }
 

});



//js hiệu ứng mở đống thanh search trong chat-box


//js cho nút dropdown trong ellips chat

function toggleDropdown(event, str) {

    var dropdownMenu = event.target.parentNode.querySelector(
        '.chat-ellips__dropdown__menu');

    var emojiShowMenu = event.target.parentNode.parentNode.querySelector(
        '.chat-ellips__show_emoji');
    if (!dropdownMenu || !emojiShowMenu) { return; }

    emojiShowMenu.style.display = "none";
    dropdownMenu.style.display = str;
 
}

function toggleEmoji(event, str) {

    var emojiShowMenu = event.target.parentNode.querySelector(
        '.chat-ellips__show_emoji');
    var bubble = event.target.parentNode.querySelector('.speech, .bottom');
    if (!emojiShowMenu) { return; }
    emojiShowMenu.style.display = str;
    bubble.style.display = str == "flex" ? "none" : "unset";
}


function outsideClickHandler(event) {

    var dropdownMenus = document.querySelectorAll('.chat-ellips__dropdown__menu');

    for (var i = 0; i < dropdownMenus.length; i++) {
        var dropdownMenu = dropdownMenus[i];
        var dropdownToggle = dropdownMenu.parentNode.querySelector('.chat-ellips__dropdown__toggle');
        if (!dropdownMenu.contains(event.target) && !dropdownToggle.contains(event.target)) {
            dropdownMenu.style.display = 'none';

        }
   
    }
}






//js gọi sự kiện btnSend khi click
function handlebtnSend() {
    __doPostBack('<%= btnSend.UniqueID %>', ''); //gọi sự kiện của btnSend_click
}




//js gọi sự kiện searchchat khi enter trong textbox search

function handleSearchChat(event) {
    if (event.key === "Enter" && !event.shiftKey) {
        event.preventDefault(); // Ngăn hành động mặt định của phím Enter

        __doPostBack('<%= btnSearchChat.UniqueID%>', ''); // Id của button searchchat
    }
}

function addArrowAnimName(e) {
    $(e.target).css("animation-name", "MenuArrows_Anim");
  

}