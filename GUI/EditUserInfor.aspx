<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="EditUserInfor.aspx.cs" Inherits="GUI.EditUserInfor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
      <link rel="stylesheet" href="Style/toast.css" />
            <script src="JS/toast.js"></script>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

  
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>
    <div class="content">
        <div class="userInfo">
            <div class="userInfo__header">
                <div class="userInfo-header__content">
                    <div class="userInfo-header__img">
                        <asp:Image ID="ImageAvatar" ImageUrl="images/avatar/defaultAvatar.jpg" runat="server" />
                    </div>
                    <div class="userInfo-header__info">
                        <label for="file-upload" class="custom-file-upload">
                            <i class="fa fa-cloud-upload"></i>Tải Lên Avatar
                        </label>
            
                        <asp:FileUpload ID="uploadAvatar" runat="server" />
                    </div>
                </div>
                <div class="userInfo-header__desc">
                    <h2>Thông tin tài khoản: <span>Admin</span></h2>
                    <div class="userInfo-header__input">
                        <i class="fa-solid fa-envelope"></i>
                        <asp:TextBox ID="tblEmail" runat="server" TextMode="email" placeholder="Email"></asp:TextBox>
                    </div>
                    <div class="userInfo-header__input">
                        <i class="fa-solid fa-user"></i>
                        <asp:TextBox ID="tblDisplayName" runat="server" type="text" placeholder="Họ Tên"></asp:TextBox>
                    </div>
                    <div class="userInfo-header__input">
                        <i class="fa-solid fa-user"></i>
                        <asp:TextBox ID="tblUserName" runat="server" type="text" placeholder="Tên Đăng Nhập"></asp:TextBox>
                    </div>
                    <div class="userInfo-header__submit">
                        <button type="button" onclick="handleSaveEdit()">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Lưu Lại
                            <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Style="display: none" />
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script>
        function handleSaveEdit() {
            __doPostBack('<%= btnSave.UniqueID %>', '');
        }
    </script>
    <script src="JS/edituser.js"></script>

</asp:Content>
