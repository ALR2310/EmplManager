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

                                    <li class="chat-main__item">
                                        <div class="chat-main__content">
                                            <div class="chat-main__avatar">
                                                <asp:Image ID="ImgAvatar" runat="server" />
                                                <img src="<%# Eval("Avatar") %>" alt="avatar">
                                            </div>
                                            <div class="chat-item__box">
                                                <div class="chat-item__box-name">
                                                    <a href="#"><%# Eval("DisplayName") %></a>
                                                </div>
                                                <p title="<%# Eval("AtCreate") %>"><%# Eval("Content") %> </p>
                                                <div class="chat-main__ellips">
                                                    <button class="ellips-like">
                                                        <i class="fa-solid fa-thumbs-up"></i>
                                                    </button>
<div class="chat-ellips__dropdown">
                                                        <button type="button" class="chat-ellips__dropdown__toggle" onclick="toggleDropdown(event)">
                                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                                        </button>
                                                        <ul class="chat-ellips__dropdown__menu">
                                                            <li>
                                                                <asp:Button ID="Button1" runat="server" Text="Xoá, gỡ" />
                                                            </li>
                                                            <li>
                                                                <asp:Button ID="Button2" runat="server" Text="Chỉnh Sửa" />
                                                            </li>
                                                        </ul>
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
                            <button class="btn btn-chat-footer" onclick="handlebtnSend()">
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

    <script src="JS/message.js"></script>

    <script>
        function handlebtnSend() {
            __doPostBack('<%= btnSend.UniqueID %>', ''); //gọi sự kiện của btnSend_click
        }
    </script>


</asp:Content>

