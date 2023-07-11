<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Message.aspx.cs" Inherits="GUI.Message" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>

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

            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>

                    <div class="chat-main">
                        <ul class="chat-main__list">
                            <asp:Repeater ID="Repeater1" runat="server">
                                <ItemTemplate>

                                    <li class="chat-main__item <%# IsOwnerMessage(Container.ItemIndex) %>">
                                        <div class="chat-main__content">
                                            <div class="chat-main__avatar">
                                                <asp:Image ID="ImgAvatar" runat="server" />
                                                <img src="<%# Eval("Avatar") %>" alt="avatar">
                                            </div>
                                            <div class="chat-item__box">
                                                <a href="#"><%# Eval("DisplayName") %></a>
                                                <p title="<%# Eval("AtCreate") %>"><%# Eval("Content") %> </p>
                                                <button type="button" class="chat-main__like hide">
                                                    <i class="fa-solid fa-thumbs-up"></i>
                                                    <span>3</span>
                                                </button>
                                                <div class="chat-main__ellips">
                                                    <button type="button" class="ellips-like">
                                                        <i class="fa-solid fa-thumbs-up"></i>
                                                    </button>
                                                    <div class="chat-ellips__dropdown <%# IsHideDropdown(Container.ItemIndex) %>">
                                                        <button type="button" class="chat-ellips__dropdown__toggle"  onmouseleave="toggleDropdown(event,'none')" onmouseenter="toggleDropdown(event,'block')">
                                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                                            <ul class="chat-ellips__dropdown__menu" >
                                                                <li>
                                              
                                                                    <asp:Button  ID="Button1" OnClientClick="return preSubmit();" runat="server" Text="Xoá, gỡ" CommandArgument="<%# Container.ItemIndex %>" />
                                                                </li>
                                                                <li>
                                                                    <asp:Button ID="Button2" runat="server" Text="Chỉnh Sửa" />
                                                                </li>
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
                            <asp:TextBox ID="txt_Message" TextMode="MultiLine" runat="server" spellcheck="false" placeholder="Enter Message..." onkeypress="handleKeyPress(event)"></asp:TextBox>
                            <button class="btn btn-chat-footer" onclick="handleSendMessage()">
                                Send
                                <i class="fa-solid fa-paper-plane"></i>
                                <asp:Button ID="btnSend" runat="server" OnClick="btnSend_Click" Style="display: none" />
                            </button>
                        </div>
                    </div>

                </ContentTemplate>
            </asp:UpdatePanel>


        </div>
    </div>
    <script>
        function preSubmit() {
           __doPostBack('<%= btnSend.UniqueID %>', '');;
                    // Add your logic here before the form submission
                    return false; // Return true to allow form submission, or false to prevent it
                }
    </script>
    <script src="JS/message.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

                handleSendMessage();
            }
        }

        function handleSendMessage() {

            __doPostBack('<%= btnSend.UniqueID %>', '');
        }
    </script>

</asp:Content>

