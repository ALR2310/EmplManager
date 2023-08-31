//js tự động cuộn xuống item cuối của khung chat
function scrollToBottom() {
    var chatList = document.querySelector('.chat-main__list');
    chatList.scrollTop = chatList.scrollHeight;
}


//js đặt height cho textarea khi có nội dung nhiều hơn
var chatInput = document.querySelector("#txt_Message")

var chatInput_jqr = $(chatInput);

function applyRange(container, absolute_pos) {
    let range = document.createRange();
    let elements = container.contents();


    for (ele of elements) {

        if (ele.textContent == null) { continue; }


        if (ele.textContent.length < absolute_pos) {
            absolute_pos -= ele.textContent.length;
            console.log(absolute_pos);
            continue;
        }
        console.log(absolute_pos);
        if (ele.nodeName == "BR") { return; }
        if (ele.nodeName != "#text") { ele = ele.firstChild; }

        range.setStart(ele, absolute_pos);

        let selection = document.getSelection();
        selection.removeAllRanges();
        selection.addRange(range);

        return;



    }


}
function focusOnBr(br) {

    let range = document.createRange();
    range.setStart(br[0], 0);

    let select = document.getSelection();
    select.removeAllRanges();
    select.addRange(range);
}
function cleanBr(chatInput_jqr) {
    for (ele of chatInput_jqr.children("span")) {
        ele = $(ele);
        if (ele.find("br").length > 1) {
            ele.find("br")[1].remove();
            focusOnBr($("<br>").insertAfter(ele));

            return true;
        }
    }
    return false;
}



function onMessageEdit(event) {



    let chatInput_jqr = $(event.target);
    if (cleanBr(chatInput_jqr)) { return; };
    let old_range = document.getSelection().getRangeAt(0);

    if (old_range.startContainer == event.target) { return; }
    let old_start = old_range.startOffset;
    let old_ele = old_range.startContainer;



    let array = chatInput_jqr.contents().toArray().filter(function () { return this.nodeName != "br" });

    let absolute_pos = 0;


    for (ele of array) {
        if (!ele.textContent) { continue; }

        if (ele === old_ele || $(ele).find(old_ele).length != 0) { break; }
        absolute_pos = absolute_pos + ele.textContent.length;

    }

    absolute_pos = absolute_pos + old_start;


    let converted = wrapLinksIntoHighlightTags(chatInput_jqr.html().replaceAll("<span>", "").replaceAll("</span> ", ""));



    chatInput_jqr.html(converted);


    applyRange(chatInput_jqr, absolute_pos);




}


//chatInput_jqr.on('input', onMessageEdit);
chatInput.addEventListener('input', function () {
    if (chatInput.textContent.trim() === "") {
        chatInput.parentNode.style.height = "40px";
        chatInput.parentNode.parentNode.style.height = "40px";
    }
    else {


        chatInput.parentNode.parentNode.style.height = "auto";

        chatInput.parentNode.parentNode.style.height = `${chatInput.scrollHeight + 29}px`;


    }
});

const replaceLastOccurrence = function (inputString, oldSubstring, newSubstring) {
    const lastIndexOfSubstring = inputString.lastIndexOf(oldSubstring);

    if (lastIndexOfSubstring === -1) {
        return inputString; // Substring not found
    }

    const newString = inputString.substring(0, lastIndexOfSubstring) + newSubstring + inputString.substring(lastIndexOfSubstring + oldSubstring.length);
    return newString;
}


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
    if (!event.target.parentNode) { return; }
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


function convertHtmlToRawText(html) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');

    const textNodes = [];

    function traverse(node) {
        if (node.nodeType === Node.TEXT_NODE) {
            textNodes.push(node.nodeValue);
        } else if (node.nodeName === 'BR') {
            textNodes.push('<br>');
        } else {
            for (const childNode of node.childNodes) {
                traverse(childNode);
            }
        }
    }

    traverse(doc.body);

    return textNodes.join('');
}