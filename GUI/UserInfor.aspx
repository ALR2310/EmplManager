<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="UserInfor.aspx.cs" Inherits="GUI.UserInfor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="content">
        <div class="userInfo">
            <div class="userInfo__header">
                <div class="userInfo-header__content">
                    <div class="userInfo-header__img">
                        <asp:Image ID="ImageAvatar" AlternateText="Ảnh đại diện" runat="server" />
                    </div>
                    <div class="userInfo-header__info">
                        <asp:Label ID="lblDisplayName" runat="server" Text="Admin"></asp:Label>
                        <asp:Label ID="lblAtCreate" runat="server" Text="Tham Gia: 03/07/2023"></asp:Label>
                    </div>
                    <div class="userInfo-header__info">
                        <p>
                            Tình trạng tài khoản: 
                            <asp:Label ID="lblStatus" runat="server" ToolTip="Tốt">
                                <i class="fa-solid fa-user"></i>
                            </asp:Label>
                        </p>
                    </div>
                </div>
                <div class="userInfo-header__desc">
                    <h2>Thông tin tài khoản:
                        <asp:Label ID="lblDisplayName1" runat="server" Text="Admin"></asp:Label>
                    </h2>
                    <p>
                        <strong>Họ Tên: </strong>
                        <asp:Label ID="lblDisplayName2" runat="server" Text="Admin"></asp:Label>
                    </p>
                    <p>
                        <strong>Email: </strong>
                        <asp:Label ID="lblEmail" runat="server" Text="Admin@gmail.com"></asp:Label>
                    </p>
                    <p>
                        <strong>Google Id: </strong>
                        <asp:Label ID="lblGooogleId" runat="server" Text=""></asp:Label>
                    </p>
                    <p>
                        <strong>Loại Tài Khoản: </strong>
                        <asp:Label ID="lblUserType" runat="server" Text="Admin"></asp:Label>
                    </p>
                    <p>
                        <strong>Số tin đã nhắn: </strong>
                        <asp:Label ID="lblChatCount" runat="server" Text="0"></asp:Label>
                        Tin nhắn
                    </p>
                    <p>
                        <strong>Số ngày hoạt động: </strong>
                        <asp:Label ID="lblDayOnline" runat="server" Text="0"></asp:Label>
                        Ngày
                    </p>
                    <p>
                        <strong>Ngày tham gia: </strong>
                        <asp:Label ID="lblAtCreate1" runat="server" Text="0/0/0000"></asp:Label>
                    </p>
                    <p>
                        <a href="chinh-sua-tai-khoan">
                            <i class="fa-solid fa-pen-to-square"></i>
                            Chỉnh sửa/Cập nhật thông tin
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
