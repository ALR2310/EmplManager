<%@ Page Title="" Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Message.aspx.cs" Inherits="GUI.Message" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/modal.css" />
    <link rel="stylesheet" href="Style/emoji_list.css" />
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
                    <div class="chat__search-box">
                        <asp:TextBox ID="txtSearchChat" runat="server" onkeypress="handleSearchChat(event)" class="chat__search-box__input" placeholder="Tìm Kiếm" type="text"></asp:TextBox>
                        <button type="button" class="chat__search-box__btn">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </div>
                </div>
            </div>

            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                    <div class="chat-main">
                        <ul class="chat-main__list">
                            <div id="chat-template" style="display: none">
                                <div class="time-gap" style="_timegaptostyle_">
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
                        </ul>

                    </div>
                    <div id="emoji_display_placeholder"      style="display:none">
                        <span class="emoji_emoji">🥳<canvas></canvas>
                        </span>
                        <div class="emoji_count">
                            <span class="count"><span class="ogcount">1</span><span class="ncount">1</span></span>

                        </div>
                    </div>
                    <div class="chat-footer">
                        <div class="chat-footer__form">
                            <textarea id="txt_Message" rows="2" spellcheck="false" placeholder="Nhập tin nhắn..." onkeypress="handleKeyPress(event)"></textarea>
                            <button class="btn btn-chat-footer" onclick="handleSendMessage(event)">
                                Send
                                <i class="fa-solid fa-paper-plane"></i>

                            </button>
                        </div>
                    </div>
                    <div id="main__ellips" class="chat-main__ellips">
                        <div class="chat-ellips__dropdown">
                            <button type="button" class="chat-ellips__emoji__toggle"
                                onmouseenter="toggleEmoji(event, 'flex')"
                                onclick="toggleEmoji(event, 'flex')" onmouseleave="toggleEmoji(event, 'none')">
                                <i class="fa-regular fa-face-smile"></i>
                                <ul class="chat-ellips__show_emoji">
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_1" class="Emoji" runat="server" style="color: red;">&#10084</a>
                                    </li>
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_2" class="Emoji">&#128077</a>
                                    </li>
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_3" class="Emoji">&#128514</a>
                                    </li>
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_4" class="Emoji">&#128517</a>
                                    </li>
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_5" class="Emoji">🥳</a>
                                    </li>
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_6" class="Emoji">👀</a>
                                    </li>
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_7" class="Emoji">🤯</a>
                                    </li>
                                    <li class="chat-ellips__item">
                                        <a id="Emoji_8" class="Emoji">🥲</a>
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
                    <asp:Button ID="Button1" runat="server" OnClick="OpenEmojiModal_Click" CommandArgument="107" Text="ABCDEFG" />



                </ContentTemplate>


            </asp:UpdatePanel>



        </div>
    </div>
    <script>

</script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="JS/message.js"></script>
    <script src="Scripts/jquery.signalR-2.4.3.js"></script>

    <
    <script src="JS/modal.js"></script>
    <script>

</script>
    <script>

        const scrollBottom = function () {


            const scroll = $(".chat-main__list")[0];
            scroll.scrollTo(0, scroll.scrollHeight);
        }

        const getScrollPos = function () {
            const scroll = $(".chat-main__list")[0];
            var pos = scroll.scrollHeight - scroll.clientHeight - scroll.scrollTop;
            console.log(pos);
            return pos;
        }
        function clearText() {
            $("#ContentPlaceHolder1_txt_Message").val("");
        }
        scrollBottom();

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
            const key = event.key;
            const isAlphaNumeric = /^[a-zA-Z0-9!@#$%^&*()_+~":<>?|}{\[\]=]$/i.test(key);

            if (isAlphaNumeric || key == "Enter" && document.activeElement != inputElement[0]) {
                inputElement.focus();
            }
        });



        var chat_scroll = $(".chat-main__list");

        last_scroll_pos = !!sessionStorage.getItem("scrollpos") ? Number(sessionStorage.getItem("scrollpos")) : chat_scroll[0].scrollHeight;



        chat_scroll[0].scroll(0, last_scroll_pos);

        chat_scroll.on('scroll', function () {
            var scrollTop = $(this).scrollTop();

            sessionStorage.setItem("scrollpos", scrollTop.toString());
        });

    </script>
    <script src="JS/emoji.js"></script>
    <script src="JS/client_interact.js"></script>
    <script src="JS/signalr_connection.js"></script>
</asp:Content>

