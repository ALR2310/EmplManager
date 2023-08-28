﻿//js tự động cuộn xuống item cuối của khung chat
function scrollToBottom() {
    var chatList = document.querySelector('.chat-main__list');
    chatList.scrollTop = chatList.scrollHeight;
}


//js đặt height cho textarea khi có nội dung nhiều hơn
var chatInput = document.querySelector("#txt_Message")

var chatInput_jqr = $(chatInput);


function applyRange(absolute_position,target_container) {

    console.log(absolute_position);
    let focusing_element = null;
    for (let element of target_container.contents().toArray()) {
        const text_length = element.textContent.length

        if (absolute_position <= text_length) {

            focusing_element = element;
            break;
        }
        absolute_position -= text_length;
    }
    if (focusing_element.nodeName != "#text") {
        focusing_element = $(focusing_element).contents()[0];
    }
    let new_range = document.createRange();

        new_range.selectNodeContents(focusing_element);

    console.log(absolute_position);
        new_range.setStart(focusing_element, absolute_position);
        new_range.setEnd(focusing_element, absolute_position);



        selection.removeAllRanges();
        selection.addRange(new_range);

  
}


chatInput.addEventListener('input', function (event) {

    selection = document.getSelection();
    const old_range = document.getSelection().getRangeAt(0);
    const old_start = old_range.startOffset;
    const old_end = old_range.endOffset;
    const old_ele = old_range.startContainer;


    let array = chatInput_jqr.contents().toArray();
    const pos = array.indexOf(old_ele);

    
    const new_array = array.slice(0, pos);

    array = null;
 
    let absolute_position = 0;
    for (ele of new_array) {
        absolute_position += ele.textContent.length;
    }

    absolute_position += old_start;

    setTimeout(function () {


        let raw_text = chatInput_jqr.text();



        let converted = wrapLinksIntoAnchorTags(raw_text);

        chatInput_jqr.html(converted);


        if (chatInput_jqr.contents().length == 0) { return; }
        applyRange(absolute_position, chatInput_jqr);
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