<%@ Page Title="" Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Message.aspx.cs" Inherits="GUI.Message" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/modal.css" />
    <link rel="stylesheet" href="Style/emoji_list.css" />
    <link rel="stylesheet" href="Style/speech_bubble.css" />
    <script src="Scripts/jquery-3.6.0.min.js"></script>
    <script src="Scripts/jquery.signalR-2.4.3.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div id="toast"></div>

    <div class="modal hide">
        <span class="overlay"></span>
        <div class="modal-box">

            <div class="content-modal">
                <h2>Cảm Xúc Về Tin Nhắn</h2>
                <div class="crossbar"></div>
                <ul class="list-emoji">

                    <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>

                            <asp:Repeater ID="ListEmoji_Repeater" runat="server">
                                <ItemTemplate>

                                    <li class="item-emoji">
                                        <a runat="server" id="RemoveEmoji" commandargument='<%# Eval("ID") %>' onserverclick="RemoveEmoji_ServerClick">
                                            <div class="item-emoji__avatar">
                                                <img src="<%# Eval("Avatar") %>" alt="">
                                            </div>
                                            <div class="item-emoji__content">
                                                <div class="item-emoji-infor">
                                                    <h3><%# Eval("DisplayName")  %></h3>
                                                    <p>Nhấn Để Gỡ</p>

                                                </div>
                                                <div class="emoji">
                                                    <i class="fa-solid fa-thumbs-up"></i>
                                                    <span>1</span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>

                                </ItemTemplate>
                            </asp:Repeater>

                        </ContentTemplate>
                    </asp:UpdatePanel>



                </ul>
            </div>

            <div class="buttonsmodal">
                <button type="button" class="btn-modal close-btn">Đóng</button>
            </div>
        </div>
    </div>

    <div class="content">
        <div class="chat">
            <div class="chat__header">
                <div class="chat-header__title">
                    <div class="chart-logo">
                        <img src="/images/sweetsoft-logo.png" alt="">
                    </div>
                    <p>Sweetsoft</p>
                </div>

                <div class="chat__search">

                    <div class="chat__search-box not_loaded">
                        <input placeholder="Tìm kiếm" id="search-box" onkeydown="preventDefault(event)" autocomplete="off" class="chat__search-box__input" />
                        <button type="button" id="search_open" class="chat__search-box__btn">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>

                        <button type="button" style="display: none" id="search_cancel" class="chat__search-box__btn">
                            <i class="fa-solid fa-cancel-icon"></i>
                        </button>
                    </div>
                </div>
            </div>
            <div id="emoji_display_placeholder" class="contains_speech" style="display: none">
                <img class="emoji_emoji">
                </span>
                <div class="emoji_count">
                    <span class="count">
                        <span class="ogcount">1</span>
                        <span class="ncount">1</span>
                    </span>


                </div>
            </div>
            <div id="MessageUpdatePanel">

                <div id="loading_circle"></div>
                <div class="chat-main">
                    <div id="popup_layout">
                        <div id="unread_messages" style="display: none" onclick="markasread(event,true)">
                            <p class="unread_notif_message">9 tin nhắn mới chưa đọc kể từ 10:25AM</p>
                            <div style="height: 100%; display: flex; align-items: center;" onclick="markasread(event,false)">
                                <p>Đánh dấu là đã đọc</p>
                                <img src="Images/markasread.svg" style="height: 100%; padding: 0 5px;" />
                            </div>

                        </div>
                        <div id="chat-search__list" style="display: none">
                            <div id="search_not_found">
                                <img src="Images/magnifying_glass.svg" />
                                <p>
                                    Không tìm thấy tin nhắn nào...
                                </p>
                            </div>
                            <div id="fake_messages" class="innerlist">
                                <div id="search_messages_pages">henlo</div>
                            </div>
                            <div id="search__list_placeholder_layer" class="innerlist">
                                <div id="search_loading_placeholder_template" class="placeholder_chatbox">
                                    <div class="chat-main__content">
                                        <div class="chat-main__avatar">

                                            <div class="loading_image layer_hole"></div>
                                        </div>

                                        <div>
                                            <div style="gap: 1px; transform: scale(.7,.6) translate(-18%,30%);" class="time_loading_placeholder placeholder_boxes_holder">
                                                <div>&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                                <div>&nbsp;&nbsp; </div>
                                                <div>&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                                <div>&nbsp;&nbsp; </div>
                                                <div>&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                            </div>
                                            <div class="chat-item__box placeholder_loading_chat_box" drop_hidden="_drop_hidden_">

                                                <div class="titles placeholder_boxes_holder">
                                                </div>

                                                <div class="placeholder_boxes_holder placeholder_content_boxes mess_content">
                                                </div>
                                                <div class="emoji_list">
                                                </div>




                                            </div>


                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="scroll_message_bottom" style="display: none" onclick="forceScrollBottom()">
                            <span>bạn đang xem tin nhắn cũ</span>
                            <span>bấm vào đây để xem tin nhắn hiện tại
                                <img src="Images/arrowDown.svg" /></span>
                        </div>
                    </div>
                    <ul class="chat-main__list">
                    </ul>

                    <div id="chat-template" style="display: none">

                        <div class="chat-main__item" message_id='_messageid_' owner="_isowner_mess_">

                            <div class="chat-main__content">
                                <div class="chat-main__avatar">

                                    <img _message_avatar_="" alt="avatar">
                                </div>

                                <div class="chat-wrapper">
                                    <span>_timestr_</span>
                                    <div class="chat-item__box" drop_hidden="_drop_hidden_">

                                        <div class="titles">

                                            <div class="_is_admin_or_not_">
                                                <img style="height: 20px" src="Images/Icons/admin.svg" />
                                                <div class="speech bottom">
                                                    Quản Trị Viên
                                                </div>
                                            </div>
                                            <a class="mess_display_name" href="#">_display_name_</a>
                                        </div>

                                        <p class="_deleted_italic_ mess_content">
                                            _deleted_or_content_&nbsp;<span class="_edited_or_not_">(đã chỉnh sửa)</span>
                                        </p>
                                        <div class="attached_files">
                                        </div>
                                        <div class="emoji_list">
                                        </div>
                                        <button type="button" class="chat-main__like hide">
                                            <asp:Label ID="lblEmoji" runat="server" Text="&#128077"></asp:Label>
                                            <asp:Button ID="OpenEmojiModal" OnClick="OpenEmojiModal_Click" Text="button" runat="server" CommandArgument='<%# Eval("Id") %>' Style="display: inherit;" />
                                        </button>



                                    </div>
                                    <span class="sending_status">Đang gửi</span>

                                </div>
                            </div>

                        </div>

                    </div>
                </div>
                <div id="attached_file_template" class="attached_file">
                    <img src="Images/avatar-1.jpg" />
                    <div>

                        <a class="file_title">avatar-1.jpg</a>
                        <span class="file_size">250Kb</span>
                    </div>
                </div>
                <div class="new_messages" id="new_messages_template">
                    <hr />
                    <span>TIN NHẮN MỚI</span>
                </div>
                <div class="chat-footer">
                    <div class="uploadPreviewContainer" style="border-bottom: none;">
                        <div id="uploadPreview">
                        </div>
                    </div>
                    <div class="footer-wrapper">
                        <input type="file" id="uploadInput" name="uploadInput" multiple style="display: none" />

                        <button id="attachMenuButton" onclick="openAttachMenu(event)" style="background: none; padding-right: 15px; border: none;     outline-width: 0;">
                            <img style="width: 35px; cursor: pointer;" src="Images/Icons/attach.svg" /></button>
                        <textarea id="txt_Message" maxlength="500" rows="2" spellcheck="false" placeholder="Nhập tin nhắn..." onkeypress="handleKeyPress(event)"></textarea>
                        <button class="btn btn-chat-footer" onclick="handleSendMessage(event)">
                            Gửi
                                <i class="fa-solid fa-paper-plane"></i>

                        </button>
                    </div>
                </div>
                <div id="uploadPreviewTemplate" class="filePreview">
                    <ul class="filePreviewToolbar">
                        <li onclick="" class="edit_button">

                            <img src="/Images/Icons/upload_edit.svg" />
                        </li>
                        <li onclick="" class="delete_button">

                            <img src="/Images/Icons/mess_delete_icon.svg" class="delete_icon" />
                        </li>

                    </ul>
                    <div class="preview_image_wrapper">
                        <img class="preview_image" src="Images/Icons/blank_file.svg" />
                    </div>

                    <span>archive.zip</span>
                </div>
                <div id="main__ellips" class="chat-main__ellips">
                    <div class="chat-ellips__dropdown">
                        <button type="button" class="chat-ellips__emoji__toggle"
                            onclick="toggleEmoji(event, 'flex')">
                            <i class="fa-regular fa-face-smile"></i>
                            <span class="sider-bar__span hide">Logout</span>
                            <div class="speech bottom">
                                Thêm Biểu Cảm
                            </div>
                            <ul class="chat-ellips__show_emoji">
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/heart.svg" id="Emoji_1" class="Emoji">
                                </li>
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/thumbsup.svg" id="Emoji_2" class="Emoji">
                                </li>
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/joy.svg" id="Emoji_3" class="Emoji">
                                </li>
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/sweat_smile.svg" id="Emoji_4" class="Emoji">
                                </li>
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/party.svg" id="Emoji_5" class="Emoji">
                                </li>
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/eyes.svg" id="Emoji_6" class="Emoji">
                                </li>
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/OPPENHEIMER.svg" id="Emoji_7" class="Emoji">
                                </li>
                                <li class="chat-ellips__item">
                                    <img src="Images/Emojis/smile_tear.svg" id="Emoji_8" class="Emoji">
                                </li>
                                <box class="boxhidentop"></box>
                                <box class="boxhidenbottom"></box>
                            </ul>
                        </button>

                    </div>
                    <div id="option_dropdown" class="chat-ellips__dropdown ">
                        <button type="button" class="chat-ellips__dropdown__toggle" onmouseenter="toggleDropdown(event,'block')" onmouseleave="toggleDropdown(event,'none')" onclick="toggleDropdown(event,'block')">
                            <i class="fa-solid fa-ellipsis-vertical"></i>
                            <ul class="chat-ellips__dropdown__menu">

                                <li class="edit_button" onclick="mess_edit();">
                                    <input type="submit" onclick="return false;" id="Button2" value="Chỉnh Sửa" />
                                    <img src="/Images/Icons/mess_edit_icon.svg" />
                                </li>
                                <li onclick="mess_delete();" class="delete_button button_red_highlight">
                                    <input onclick="return false;" type="submit" id="btnDelete" value="Xoá, gỡ" />
                                    <img src="/Images/Icons/mess_delete_icon.svg" />
                                </li>
                                <box class="boxhidentop"></box>
                                <box class="boxhidenbottom"></box>
                            </ul>
                        </button>

                    </div>
                </div>





            </div>



        </div>
        <div id="editTemplate" style="display: none;">

            <p class="mess_content toRemove" contenteditable="true">rwa</p>
            <button class="btn btn-chat-footer" onclick="sendEdit(event); return false;">
                Chỉnh Sửa
                                <i class="fa-solid fa-pen"></i>

            </button>

        </div>
    </div>

    <script src="JS/message.js"></script>
    <script src="JS/search.js"></script>


    <script src="JS/modal.js"></script>
    <script>
        window.history.pushState('Message', 'Message.aspx', 'Message.aspx');
        function preventDefault(e) {
            if (e.key === "Enter") {
                e.preventDefault();
            }
        }
        let Max_Allowed_Messages = 25 * 5;
        function findLatestMessageId() {
            return Number($(".chat-main__list").find(".chat-main__item").last().attr("message_id"));

        }


        var unread_messages_ele = $("#unread_messages");
        var focused = true;

        window.onfocus = function () {
            focused = true;
        };
        window.onblur = function () {
            focused = false;
        };
    </script>
    <script src="JS/image_attach.js">
      
    </script>
    <script>
        $("#loading_circle").addClass("loader_show");

        const new_messages_template = $("#new_messages_template");
        var lastRenderedMessage = null;
        var loadedbottom = false;
        var renderingmessages = true;
        var is_firsttime_load = true;
        var last_unread_message_id;
        const setLastReadMessage = function (message_id) {
            message_id = Number(message_id);
            if (isNaN(message_id) || message_id == null) {
                console.log("Rejected storing lastread"); return
            };
            let saving = {};
            saving.Id = message_id;
            saving.AtCreate = Saved_Messages[message_id].AtCreate;

            let stored_read = getLastReadMessage();
            if (stored_read != null)
                if (stored_read.Id > message_id || (stored_read.Id == message_id && !!stored_read.AtCreate)) {
                    console.log("Rejected storing lastread"); return;
                }


            localStorage.setItem("lastReadMessage" + Users.CLIENT_USER.Id, JSON.stringify(saving));
            console.log("Stored lastRead");
        }


        const getLastReadMessage = function () {
            let raw_data = JSON.parse(localStorage.getItem("lastReadMessage" + Users.CLIENT_USER.Id));
            if (raw_data == null) raw_data = { Id: latest_message_id };
            if (!!raw_data.AtCreate) raw_data.AtCreate = new Date(raw_data.AtCreate);



            return raw_data;
        }
        const setLastRenderedMessageCache = function (message_id) {
            setLastReadMessage(message_id);
            if (lastRenderedMessage == null) {
                localStorage.setItem("lastRenderedMessage" + Users.CLIENT_USER.Id, message_id);
                return;

            }

            if (message_id >= lastRenderedMessage || message_id == -1) {
                localStorage.setItem("lastRenderedMessage" + Users.CLIENT_USER.Id, message_id);
                return;
            }

        }


        var Users = {};

        const search_box = $("#search-box");

        var latest_message_id = $.ajax({
            url: 'Message.aspx/GetTotalMessage',
            type: 'POST',
            contentType: 'application/json',
            dataType: 'json',

        });


        const scroll = $(".chat-main__list")[0];
        const scrollBottom = function () {
            if (is_firsttime_load) { return; }
            console.log("scrolled bottom");

            scroll.scrollTo(0, scroll.scrollHeight);
        }


        const getScrollPos = function () {

            var pos = scroll.scrollHeight - scroll.clientHeight - scroll.scrollTop;

            return pos;
        }
        function clearText() {
            $("#ContentPlaceHolder1_txt_Message").val("");
        }

    </script>

    <script>
        var lastCheckThread = null;
        let last_dist = getScrollPos();
        function getClosestChatElementFromWindow() {
            clearTimeout(lastCheckThread);
            lastCheckThread = setTimeout(getClosestChatElementFromWindow, 1000);


            if (getScrollPos() == last_dist) {
                last_dist = getScrollPos();
                return;
            }
            last_dist = getScrollPos();


            let ele = $(".chat-main__list").find(".chat-main__item");
            let closest = null;
            let closest_dist = null;



            let scroll_top = scroll.scrollTop + scroll.clientHeight / 2;
            for (element of ele) {
                let calculated_dist = Math.abs(scroll_top - element.offsetTop);

                if (!!closest && closest_dist < calculated_dist) {
                    continue;
                }
                closest = element;
                closest_dist = calculated_dist;
            }

            let message_id_position = latest_message_id - closest.getAttribute("message_id");
            if (message_id_position > 50) {
                $("#scroll_message_bottom").css("display", "flex");
            }
            else if (message_id_position < 25) {
                $("#scroll_message_bottom").css("display", "none");
            }


        }
        function handleKeyPress(event) {
            if (event.keyCode === 13 && !event.shiftKey) {
                event.preventDefault();

                handleSendMessage(event);
            }
        }

        function handleSendMessage(event) {
            event.preventDefault();

            sendMessage();

        }
        const ellips = $("#main__ellips");

        let edit_button = ellips.find(".edit_button");
        let delete_button = ellips.find(".delete_button");

        let option_dropdown_ellips = ellips.find("#option_dropdown");
        function toggleEllips(e) {

            var parele = $(e.target).closest(".chat-main__item");

            ellips.appendTo(parele.find(".chat-item__box"));
            ellips.css("display", "flex");

            ellips.attr("Message_Id", parele.attr("message_id"));

            let isNOTowner = parele.attr("owner") != 'true';

            let isadmin = Users.CLIENT_USER.UserType == 2;

            edit_button.toggleClass("display_none", isNOTowner);

            delete_button.toggleClass("display_none", isNOTowner && !isadmin);

            let has_visible_boxes = option_dropdown_ellips.find("li:not(.display_none)").length != 0;

            option_dropdown_ellips.toggleClass("display_none", !has_visible_boxes);
            toggleEmoji(e, 'none');
        }
        const mess_edit_template = $('#editTemplate');
        mess_edit_template.attr("id", "");
        mess_edit_template.addClass("editingBoxes");
        var delete_cd = {};
        function sendEdit(event) {
            let parent_ele = $(event.target).closest(".chat-main__item.chat_force_highlight.message_editing");
            let edited_text = parent_ele.find(".mess_content.toRemove").text();
            let og_text = parent_ele.find(".mess_content:not(.toRemove)").text().trim();

            let toremove = $(".editingBoxes");

            $(toremove.parent()).find("p").css("display", "");
            console.log(toremove.closest(".chat-main__item"));
            toremove.closest(".chat-main__item").removeClass("chat_force_highlight message_editing");
            toremove.remove();


            if (edited_text == og_text) { return; }

            fetch("Message.aspx/EditMessage", {
                headers: {


                    "content-type": "application/json",

                },
                method: "POST",
                body: `{content: '${edited_text}',id: ${parent_ele.attr('message_id')}}`
            });
        }
        function mess_edit() {
            $(".chat_force_highlight").removeClass("chat_force_highlight");
            let editing_id = ellips.attr("Message_Id");

            let chat_item = $(`.chat-main__item[message_id=${editing_id}]`);
            chat_item.addClass("chat_force_highlight message_editing");
            let mess_content = chat_item.find(".mess_content");
            mess_content.css("display", "none");

            let editing_boxes = mess_edit_template.clone();
            let editing = editing_boxes.find("p");


            editing.text(mess_content.text().replaceAll("(đã chỉnh sửa)", "").trim());

            editing.focus();

            editing_boxes.insertBefore(mess_content);
            editing_boxes.css("display", "");



            const range = document.createRange();
            const selection = window.getSelection();
            range.selectNodeContents(editing[0]);
            range.collapse(false); // Collapse the range to the end
            selection.removeAllRanges(); // Remove any existing selection
            selection.addRange(range); // Add the new range with the cursor at the end


        }

        $(window).on("click", function (event) {
            let target = $(event.target);
            let closest = target.closest(".chat-item__box");
            if (closest.length != 0 && closest.closest(".message_editing").length != 0) {

            }
            else {
                let toremove = $(".editingBoxes");

                $(toremove.parent()).find("p").css("display", "");
                console.log(toremove.closest(".chat-main__item"));
                toremove.closest(".chat-main__item").removeClass("chat_force_highlight message_editing");
                toremove.remove();

            }
        });
        function mess_delete(e) {

            if (delete_cd[Number(ellips.attr("Message_Id"))] == true) { return; }
            delete_cd[Number(ellips.attr("Message_Id"))] = true;
            $.ajax({
                url: 'Message.aspx/DeleteMessage',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                data: JSON.stringify({ id: Number(ellips.attr("Message_Id")) }),
                success: function (response) {


                },
                error: function (xhr, status, error) {

                    console.error(error);
                }
            });

        }



        var inputElement = $("#txt_Message");
        document.addEventListener('keydown', function (event) {
            if (event.target.nodeName == "P") {
                let closet_ele_target = $(event.target).closest(".chat-main__item");

                if (!!closet_ele_target && closet_ele_target.hasClass("chat_force_highlight")) {
                    if (closet_ele_target.is(':last-child')) setTimeout(scrollBottom, 0);

                }
            }

            if (search_box.is(":focus") || event.target.nodeName == "TEXTAREA" || event.target.nodeName == "P") { return };
            const key = event.key;
            const isAlphaNumeric = /^[a-zA-Z0-9!@#$%^&*()_+~":<>?|}{\[\]=]$/i.test(key);

            if (isAlphaNumeric || key == "Enter" && document.activeElement != inputElement[0]) {
                inputElement.focus();
            }
        });



        var chat_scroll = $(".chat-main__list");

        //last_scroll_pos = !!sessionStorage.getItem("scrollpos") ? Number(sessionStorage.getItem("scrollpos")) : chat_scroll[0].scrollHeight;



        //chat_scroll[0].scroll(0, last_scroll_pos);

        const mark_new_message = function () {

        }
        var loading_scrolling_bottom_cancel = false;
        const scroll_DOM = chat_scroll[0];
        async function loadFirstMessages() {


            setTimeout(function () {
                chat_scroll.on('scroll', async function () {

                    var scrollTop = $(this).scrollTop();
                    if (scrollTop == 0) {
                        var last_ele = $(".chat-main__list").find(".chat-main__item")[0];

                        await requestJsonData(last_ele.getAttribute("message_id"));
                        console.log("Loading Message Above");

                    }

                    if (getScrollPos() == 0) {

                        //localStorage.setItem("lastRenderedMessage" + Users.CLIENT_USER.Id, lastRenderedMessage < latest_message_id ? latest_message_id : lastRenderedMessage);
                        loadedbottom = Number(latest_message_id) == findLatestMessageId();
                        if (!loadedbottom && !renderingmessages) {

                            let oldpos = scroll.scrollTop;
                            loadedbottom = true;

                            var returned_bool = await requestJsonData(lastRenderedMessage + 25);

                            loadedbottom = Number(latest_message_id) == findLatestMessageId();

                            if (loadedbottom) unread_messages_ele.css("display", "none");
                            if (!loading_scrolling_bottom_cancel) scroll.scrollTo(0, oldpos);
                            else loading_scrolling_bottom_cancel = false;

                        }
                        else {
                            markasread(null, false);
                            $(".new_messages").remove();
                            $("#scroll_message_bottom").css("display", "none");
                        }
                    }
                    sessionStorage.setItem("scrollpos", scrollTop.toString());
                });
            }, 500);

            if (typeof latest_message_id != 'number') latest_message_id = await latest_message_id;
            latest_message_id = JSON.parse(latest_message_id.d).Id;


            let lastRenderedMessageStr = localStorage.getItem("lastRenderedMessage" + Users.CLIENT_USER.Id);

            lastRenderedMessage = lastRenderedMessageStr != null && isNaN(Number(lastRenderedMessageStr)) == false ? Number(localStorage.getItem("lastRenderedMessage" + Users.CLIENT_USER.Id)) : -1;



            let last_read_message = lastRenderedMessage;

            await requestJsonData(lastRenderedMessage != -1 ? lastRenderedMessage + 1 : -1, false);

            loadedbottom = lastRenderedMessage == latest_message_id;

            getClosestChatElementFromWindow();


            if (latest_message_id == findLatestMessageId()) {
                is_firsttime_load = false;

                setLastRenderedMessageCache(latest_message_id);
                scrollBottom();
                setTimeout(scrollBottom, 100);
                return;
            }


            var returned_bool = await requestJsonData(lastRenderedMessage + 25, false);



            if (!returned_bool || last_read_message == 0) {


                is_firsttime_load = false;

                scrollBottom();
            }
            else {



                let new_messages_ever_since = latest_message_id - getLastReadMessage().Id;

                last_unread_message_id = last_read_message;
                setTimeout(function () {

                    var new_bar = new_messages_template.clone();
                    new_bar.attr("id", "markasread_active");


                    new_bar.insertBefore(Saved_Messages[last_read_message + 1].message_element);
                    scroll.scrollTo(0, Saved_Messages[last_read_message + 1].message_element[0].offsetTop - scroll.clientHeight / 2);

                }, 0);
                unread_messages_ele.css("display", "");



                let date = FormatFuncs["_timestr_"](Saved_Messages[last_read_message + 1]);

                unread_messages_ele.find(".unread_notif_message").text(`Bạn có ${new_messages_ever_since} tin nhắn mới chưa đọc kể từ ${date}`);
            }
            is_firsttime_load = false;


        }


    </script>
    <script src="JS/emoji.js"></script>
    <script src="JS/client_interact.js"></script>
    <script src="JS/signalr_connection.js"></script>

</asp:Content>

