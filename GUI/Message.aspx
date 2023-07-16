<%@ Page Title="" Language="C#" MaintainScrollPositionOnPostback="true" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Message.aspx.cs" Inherits="GUI.Message" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/modal.css" />
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

                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
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
                            <asp:Repeater ID="ListMessage_Repeater" runat="server">
                                <ItemTemplate>
                                    <div class="time-gap" <%#GetTimeGap(Container.ItemIndex) == true ? "" : "style='display:none'" %>>
                                        <div class="timer"><%# GetTime((DateTime)Eval("AtCreate")) + " " + GetDateStr(Container.ItemIndex)  %></div>
                                    </div>
                                    <li class="chat-main__item <%# IsOwnerMessage(Container.ItemIndex) %>">
                                        <div class="chat-main__content">
                                            <div class="chat-main__avatar">
                                                <asp:Image ID="ImgAvatar" runat="server" />
                                                <img src="<%# Eval("Avatar") %>" alt="avatar">
                                            </div>

                                            <div class="chat-wrapper">
                                                <span><%# GetTime((DateTime)Eval("AtCreate")) %> </span>
                                                <div class="chat-item__box">

                                                    <div class="titles">
                                                        <a href="#"><%#  Eval("DisplayName")%></a>

                                                    </div>

                                                    <p class="<%#(int)Eval("Status") != 1 ? "italic" : "" %>" title="<%# GetTime((DateTime)Eval("AtCreate")) %>">
                                                        <%# (int)Eval("Status") == 0 ? "Tin nhắn đã được thu hồi" : (int)Eval("Status") == -1 ? "Tin nhắn đã được thu hồi bởi quản trị viên" : Eval("Content")  %>
                                                    </p>
                                                    <button type="button" class="chat-main__like <%--hide--%>">
                                                        <asp:Label ID="lblEmoji" runat="server" Text="&#128077"></asp:Label>
                                                        <asp:Button ID="OpenEmojiModal" OnClick="OpenEmojiModal_Click" Text="button" runat="server" CommandArgument='<%# Eval("Id") %>' Style="display: inherit;" />
                                                    </button>


                                                    <div class="chat-main__ellips" <%#(int)Eval("Status") != 1 ? "style='display:none !important'" : ""%>>
                                                        <div class="chat-ellips__dropdown">
                                                            <button type="button" class="chat-ellips__emoji__toggle"
                                                                onmouseenter="toggleEmoji(event, 'flex')"
                                                                onclick="toggleEmoji(event, 'flex')" onmouseleave="toggleEmoji(event, 'none')">
                                                                <i class="fa-regular fa-face-smile"></i>
                                                                <ul class="chat-ellips__show_emoji">
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_1" runat="server" style="color: red;">&#10084</a>
                                                                    </li>
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_2" runat="server">&#128077</a>
                                                                    </li>
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_3" runat="server">&#128514</a>
                                                                    </li>
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_4" runat="server">&#128517</a>
                                                                    </li>
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_5" runat="server">🥳</a>
                                                                    </li>
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_6" runat="server">👀</a>
                                                                    </li>
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_7" runat="server">🤯</a>
                                                                    </li>
                                                                    <li class="chat-ellips__item">
                                                                        <a id="Emoji_8" runat="server">🥲</a>
                                                                    </li>
                                                                    <box class="boxhidentop"></box>
                                                                    <box class="boxhidenbottom"></box>
                                                                </ul>
                                                            </button>

                                                        </div>
                                                        <div class="chat-ellips__dropdown <%# IsHideDropdown(Container.ItemIndex) %>">
                                                            <button type="button" class="chat-ellips__dropdown__toggle" onmouseenter="toggleDropdown(event,'block')" onmouseleave="toggleDropdown(event,'none')" onclick="toggleDropdown(event,'block')">
                                                                <i class="fa-solid fa-ellipsis-vertical"></i>
                                                                <ul class="chat-ellips__dropdown__menu">
                                                                    <li>
                                                                        <asp:Button ID="btnDelete" runat="server" Text="Xoá, gỡ" OnClick="btnDelete_Click" CommandArgument='<%# Eval("Id") %>' />
                                                                    </li>
                                                                    <li>
                                                                        <asp:Button ID="Button2" runat="server" Text="Chỉnh Sửa" />
                                                                    </li>
                                                                    <box class="boxhidentop"></box>
                                                                    <box class="boxhidenbottom"></box>
                                                                </ul>
                                                            </button>

                                                        </div>
                                                    </div>
                                                </div>

                                            </div>
                                    </li>

                                </ItemTemplate>
                            </asp:Repeater>

                        </ul>

                    </div>

                    <div class="chat-footer">
                        <div class="chat-footer__form">
                            <asp:TextBox ID="txt_Message" TextMode="MultiLine" runat="server" spellcheck="false" placeholder="Nhập tin nhắn..." onkeypress="handleKeyPress(event)"></asp:TextBox>
                            <button class="btn btn-chat-footer" onclick="handleSendMessage()">
                                Send
                                <i class="fa-solid fa-paper-plane"></i>
                                <asp:Button ID="btnSend" runat="server" OnClick="btnSend_Click" Style="display: none" />
                            </button>
                        </div>
                    </div>

                    <asp:Button ID="Button1" runat="server" OnClick="OpenEmojiModal_Click" CommandArgument="107" Text="ABCDEFG" />

                </ContentTemplate>

                <Triggers>
                    <asp:PostBackTrigger ControlID="Button1" />
                </Triggers>
            </asp:UpdatePanel>

        </div>
    </div>
    <script>

    </script>
    <script src="JS/message.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="JS/modal.js"></script>
    <script>

        function scrollBottom() {

            const scroll = $(".chat-main__list")[0];
            scroll.scrollTo(0, scroll.scrollHeight);
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

        function handleSendMessage() {

            __doPostBack('<%= btnSend.UniqueID %>', '');
        }

        <%--function handleShowModalEmoji() {
            __doPostBack('<%= OpenModalEmoji.UniqueID %>', '');
        }--%>
    </script>

</asp:Content>

