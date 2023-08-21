<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="EditUserInfor.aspx.cs" Inherits="GUI.EditUserInfor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/toast.css" />
    <link rel="stylesheet" href="Style/useredit.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />


</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>

    <div class="modal hide">
        <span class="overlay"></span>
        <div class="modal-box">

            <div class="content-modal">
                <i class="fa-regular fa-circle-check"></i>
                <h2>Cập Nhật Thành Công</h2>
                <h3>Bạn đã cập nhật thông tin thành công!</h3>
            </div>

            <div class="buttonsmodal">
                <button class="btn-modal close-btn">Đóng</button>
            </div>
        </div>
    </div>

    <div class="content">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>


        <div class="userInfo">
            <div class="userInfo__header">
                <div class="userInfo-header__content">
                    <div class="userInfo-header__img">
                        <asp:Image ID="ImageAvatar" ImageUrl="images/avatar/defaultAvatar.jpg" runat="server" />

                    </div>
                    <span id="image_upl_error" style="visibility: hidden">kích thước ảnh không được lớn hơn 10MB!</span>
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
                        <asp:TextBox ID="tblEmail" TextMode="Email" autocomplete="off" runat="server"></asp:TextBox>
                        <label>Email</label>
                    </div>
                    <div class="inputGroup">
                        <asp:TextBox ID="tblDisplayName" autocomplete="off" runat="server"></asp:TextBox>
                        <label>Họ Và Tên</label>
                    </div>
                    <div class="userInfo-header__submit">
                        <button type="button" onclick="handleSaveEdit(event)">
                            <i class="fa-solid fa-floppy-disk"></i>
                            Lưu Lại
                                <asp:Button ID="btnSave" OnClick="btnSave_Click" runat="server" Style="display: none;" />
                        </button>
                    </div>
                </div>
                <div class="userInfo-header__desc">
                    <h2>Thay Đổi Mật Khẩu</h2>
                    <div class="inputGroup">
                        <asp:TextBox ID="tblOldPassword" TextMode="Password" autocomplete="off" runat="server"></asp:TextBox>
                        <label>Mật Khẩu Cũ</label>
                    </div>
                    <div class="inputGroup">
                        <asp:TextBox ID="tblNewPassword" TextMode="Password" autocomplete="off" runat="server"></asp:TextBox>
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


    </div>
    <script>
        var image_txt = document.getElementById("image_upl_error");

        function hide_image_txt() {
            image_txt.style.visibility = "hidden";
        }

        function set_image_txt(txt) {
            image_txt.style.visibility = "unset";
            image_txt.textContent = txt;
        }

        function handleSaveEdit(e) {

            __doPostBack('<%= btnSave.UniqueID %>', '');
        }
        function handleSavePassword() {
            __doPostBack('<%= btnChanges.UniqueID %>', '');
        }
        function handleFileChange(input) {
            if (input.files && input.files[0]) {


                var fileSize = input.files[0].size;

                console.log(fileSize);
                if (fileSize > 10 * 1096 * 1096) {
                    set_image_txt("Ảnh đại diện phải nhỏ hơn 10MB!");
                    input.value = "";
                    return;
                }
                var file = input.files[0];
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
    <script src="JS/modal.js"></script>
    <script src="JS/toast.js"></script>

</asp:Content>
