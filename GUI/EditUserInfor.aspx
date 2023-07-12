<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="EditUserInfor.aspx.cs" Inherits="GUI.EditUserInfor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/toast.css" />
    <script src="JS/toast.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />


</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>


    <div class="content">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

        <contenttemplate>
            <div class="userInfo">
                <div class="userInfo__header">
                    <div class="userInfo-header__content">
                        <div class="userInfo-header__img">
                            <asp:Image ID="ImageAvatar" ImageUrl="images/avatar/defaultAvatar.jpg" runat="server" />
                        </div>
                        <div class="userInfo-header__info">
                            <asp:Label ID="lblUpload" runat="server" AssociatedControlID="uploadAvatar" CssClass="custom-file-upload">
                                <i class="fa fa-cloud-upload"></i>Tải Lên Avatar
                            </asp:Label>

                            <asp:FileUpload onchange="handleFileChange(this)" ID="uploadAvatar" runat="server" />
                        </div>
                    </div>
                    <div class="userInfo-header__desc">
                        <h2>Cập Nhật Thông Tin</h2>
                        <div class="inputGroup">
                            <asp:TextBox ID="tblEmail" TextMode="Email" autocomplete="off" required="" runat="server"></asp:TextBox>
                            <label>Email</label>
                        </div>
                        <div class="inputGroup">
                            <asp:TextBox ID="tblDisplayName" autocomplete="off" required="" runat="server"></asp:TextBox>
                            <label>Họ Và Tên</label>
                        </div>
                        <div class="userInfo-header__submit">
                            <button type="button" onclick="handleSaveEdit()">
                                <i class="fa-solid fa-floppy-disk"></i>
                                Lưu Lại
                                <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Style="display: none;" />
                            </button>
                        </div>
                    </div>
                    <div class="userInfo-header__desc">
                        <h2>Thay Đổi Mật Khẩu</h2>
                        <div class="inputGroup">
                            <asp:TextBox ID="tblOldPassword" TextMode="Password" autocomplete="off" required="" runat="server"></asp:TextBox>
                            <label>Mật Khẩu Cũ</label>
                        </div>
                        <div class="inputGroup">
                            <asp:TextBox ID="tblNewPassword" TextMode="Password" autocomplete="off" required="" runat="server"></asp:TextBox>
                            <label>Mật Khẩu Mới</label>
                        </div>
                        <div class="userInfo-header__submit">
                            <button type="button" onclick="handleSavePassword()">
                                <i class="fa-solid fa-floppy-disk"></i>
                                Thay Đổi
                                <asp:Button ID="btnChanges" runat="server" OnClick="btnChanges_Click" Style="display: none;" />
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </contenttemplate>


    </div>
    <script>
        function handleSaveEdit() {
            __doPostBack('<%= btnSave.UniqueID %>', '');
        }
        function handleSavePassword() {
            __doPostBack('<%= btnChanges.UniqueID %>', '');
        }
        function handleFileChange(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    document.getElementById('<%= ImageAvatar.ClientID %>').src = e.target.result;
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
        function handleLabelClick() {
            document.getElementById('uploadAvatar').click();
        }

    </script>
    <script src="JS/edituser.js"></script>

</asp:Content>
