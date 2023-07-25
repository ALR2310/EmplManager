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
                    <asp:Button ID="btnSearchChat" runat="server" Style="display: none" />
                    <div class="chat__search-box not_loaded">
                        <input placeholder="Tìm kiếm" id="search-box" class="chat__search-box__input" />
                        <button type="button" class="chat__search-box__btn">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </div>
                </div>
            </div>
            <div id="emoji_display_placeholder" style="display: none">
                <span class="emoji_emoji">🥳<canvas></canvas>
                </span>
                <div class="emoji_count">
                    <span class="count">
                        <span class="ogcount">1</span>
                        <span class="ncount">1</span>
                    </span>


                </div>
            </div>
            <div id="UpdatePanel1">
                <div id="unread_messages" style="display: none" onclick="markasread(event,true)">
                    <p class="unread_notif_message">9 tin nhắn mới chưa đọc kể từ 10:25AM</p>
                    <div style="height: 100%; display: flex; align-items: center;" onclick="markasread(event,false)">
                        <p>Đánh dấu là dã đọc</p>
                        <img src="Images/markasread.svg" style="height: 100%; padding: 0 5px;" />
                    </div>

                </div>
                <div id="loading_circle"></div>
                <div class="chat-main">
                    <ul class="chat-main__list">
                    </ul>
           
                    <div id="chat-template" style="display: none">
                        <div class="time-gap" style="_timegaptostyle_" message_id='_messageid_'>
                            <div class="timer">_timestr_, _datestr_</div>
                        </div>
                                
                        <li class="chat-main__item" message_id='_messageid_' owner="_isowner_mess_">

                            <div class="chat-main__content">
                                <div class="chat-main__avatar">

                                    <img _message_avatar_="" alt="avatar">
                                </div>

                                <div class="chat-wrapper">
                                    <span>_timestr_</span>
                                    <div class="chat-item__box" drop_hidden="_drop_hidden_">

                                        <div class="titles">
                                            <a class="mess_display_name" href="#">_display_name_</a>

                                        </div>

                                        <p class="_deleted_italic_ mess_content">
                                            _deleted_or_content_
                                        </p>
                                        <div class="emoji_list">
                                        </div>
                                        <button type="button" class="chat-main__like hide">
                                            <asp:Label ID="lblEmoji" runat="server" Text="&#128077"></asp:Label>
                                            <asp:Button ID="OpenEmojiModal" OnClick="OpenEmojiModal_Click" Text="button" runat="server" CommandArgument='<%# Eval("Id") %>' Style="display: inherit;" />
                                        </button>



                                    </div>


                                </div>
                            </div>

                        </li>

                    </div>
                </div>
                 <div class="new_messages" id="new_messages_template"><hr /><span>TIN NHẮN MỚI</span></div>
                <div class="chat-footer">

                    <textarea id="txt_Message" rows="2" spellcheck="false" placeholder="Nhập tin nhắn..." onkeypress="handleKeyPress(event)"></textarea>
                    <button class="btn btn-chat-footer" onclick="handleSendMessage(event)">
                        Send
                                <i class="fa-solid fa-paper-plane"></i>

                    </button>

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
                    <div class="chat-ellips__dropdown ">
                        <button type="button" class="chat-ellips__dropdown__toggle" onmouseenter="toggleDropdown(event,'block')" onmouseleave="toggleDropdown(event,'none')" onclick="toggleDropdown(event,'block')">
                            <i class="fa-solid fa-ellipsis-vertical"></i>
                            <ul class="chat-ellips__dropdown__menu">
                                <li>
                                    <asp:Button ID="btnDelete" runat="server" Text="Xoá, gỡ" OnClientClick="mess_delete(); return false;" />
                                </li>
                                <li>
                                    <asp:Button ID="Button2" runat="server" Text="Chỉnh Sửa" OnClientClick="return false;" />
                                </li>
                                <box class="boxhidentop"></box>
                                <box class="boxhidenbottom"></box>
                            </ul>
                        </button>

                    </div>
                </div>





            </div>



        </div>
    </div>

    <script src="JS/message.js"></script>



    <script src="JS/modal.js"></script>
    <script>

function findLatestMessageId() {
return Object.keys(Saved_Messages).reduce((max, current) => {

    const number = parseInt(current, 10);


    if (isNaN(number) || number <= max) {
        return max;
    }

    return number;
}, Number.NEGATIVE_INFINITY);

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
    <script>
        const new_messages_template = $("#new_messages_template");
        var lastRenderedMessage = null;
        var loadedbottom = false;
        var renderingmessages = true;
        var is_firsttime_load = true;
        var last_unread_message_id;


        var Users = {};

        const search_box = $("#search-box");

        var latest_message_id =  $.ajax({
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
        function toggleEllips(e) {

            var parele = $(e.target).closest(".chat-main__item");

            ellips.appendTo(parele.find(".chat-item__box"));
            ellips.css("display", "flex");

            ellips.attr("Message_Id", parele.attr("message_id"));
            toggleEmoji(e, 'none');
        }

        var delete_cd = {};
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
            if (search_box.is(":focus")){ return };
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

        const scroll_DOM = chat_scroll[0];
        async function loadFirstMessages() {
              if (typeof latest_message_id != 'number') latest_message_id = await latest_message_id;
                latest_message_id = JSON.parse(latest_message_id.d).Id;


            let lastRenderedMessageStr = localStorage.getItem("lastRenderedMessage" + Users.CLIENT_USER.Id);
            console.log(JSON.stringify(lastRenderedMessageStr));
            lastRenderedMessage = lastRenderedMessageStr != null && isNaN(Number(lastRenderedMessageStr)) == false ? Number(localStorage.getItem("lastRenderedMessage" + Users.CLIENT_USER.Id)) : -1;



            let last_read_message = lastRenderedMessage;

            await requestJsonData(lastRenderedMessage != -1 ? lastRenderedMessage + 1 : -1, false);



             if (latest_message_id == findLatestMessageId()) {
                console.log("it seems that we loaded the new messages! scrolling bottom...");
                is_firsttime_load = false;
                scrollBottom();
                return;
             }


            var returned_bool = await requestJsonData(lastRenderedMessage + 25, false);


            console.log(returned_bool);
            if (!returned_bool || last_read_message == 0) {
     

                is_firsttime_load = false;

                scrollBottom();
            }
            else {
               
        
              
                let new_messages_ever_since = latest_message_id - last_read_message;
                    
                last_unread_message_id = last_read_message;
                setTimeout(function () {
       
                    var new_bar = new_messages_template.clone();
                       new_bar.attr("id", "markasread_active");


                    new_bar.insertBefore(Saved_Messages[last_read_message+1].message_element);
                    scroll.scrollTo(0, Saved_Messages[last_read_message+1].message_element[0].offsetTop - scroll.clientHeight/2);
                    
                }, 0);
                 unread_messages_ele.css("display", ""); 


         
                let date = FormatFuncs["_timestr_"](Saved_Messages[last_read_message+1]);
           
                unread_messages_ele.find(".unread_notif_message").text(`Bạn có ${new_messages_ever_since} tin nhắn mới chưa đọc kể từ ${date}`);
            }
            is_firsttime_load = false;

            setTimeout(function () {
                chat_scroll.on('scroll', async function () {
                    var scrollTop = $(this).scrollTop();
                    if (scrollTop == 0) {
                        var last_ele = $(".chat-main__list").find(".chat-main__item")[0];

                        await requestJsonData(last_ele.getAttribute("message_id"));


                    }

                    if (getScrollPos() == 0) {

                        localStorage.setItem("lastRenderedMessage" + Users.CLIENT_USER.Id, latest_message_id);
                        unread_messages_ele.css("display", "none"); 
                        $(".new_messages").remove();
                        if (!loadedbottom && !renderingmessages) {

                            let oldpos = scroll.scrollTop;
                            loadedbottom = true;

                            var returned_bool = await requestJsonData(lastRenderedMessage + 25);
                            console.log(returned_bool);
                            loadedbottom = !returned_bool;

                            scroll.scrollTo(0, oldpos);
                           
                        }
                    }
                    sessionStorage.setItem("scrollpos", scrollTop.toString());
                });
            }, 500);
        }


    </script>
    <script src="JS/emoji.js"></script>
    <script src="JS/client_interact.js"></script>
    <script src="JS/signalr_connection.js"></script>
</asp:Content>

