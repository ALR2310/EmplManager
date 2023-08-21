<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="UserInfor.aspx.cs" Inherits="GUI.UserInfor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/userinfo.css" />
    <link rel="stylesheet" href="Style/toast.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>

    <div class="content">
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
        <div class="userInfo">
            <asp:Label ID="lblCurrentUserId" runat="server" Style="display: none"></asp:Label>
            <div class="userInfor-header">
                <div class="userInfor-header-img">
                    <img id="ifAvatar" src="/images/avatar-1.jpg" alt="">
                </div>
                <div class="userInfor-header-desc">
                    <h4 id="ifDisplayName">Lê Thanh An</h4>
                    <h5 id="ifJob">Intern</h5>
                    <p id="ifAtCreate">17/8/2023</p>
                </div>
                <div id="divInforStatus" class="userInfor-header-desc">
                    <p>
                        Tình trạng tài khoản:
                                <span id="ifStatus">Tốt</span>
                    </p>
                </div>

                <div id="divUploadImg" class="userInfor-header-desc hide">
                    <label for="file-upload" class="custom-file-upload">
                        <i class="fa fa-cloud-upload"></i>
                        Tải Lênh Avatar
                    </label>
                    <input id="file-upload" onchange="previewImageFile(event)" type="file" accept="image/*" />
                </div>
                <%--<button type="button" onclick="uploadFile()">Tải Lên hình ảnh</button>--%>
            </div>

            <div class="userInfor-body">
                <div class="userInfor-body-title">
                    <h3>Thông Tin Tài Khoản</h3>
                    <button type="button" id="btnEdit" onclick="handleShowEditUser(this)">Chỉnh Sửa</button>
                    <div class="userInfor-body-title-action hide">
                        <button type="button" id="btnSave" onclick="handleUpdateData()">Lưu Lại</button>
                        <button type="button" id="btnCancel" onclick="handleHideEditUser()">Huỷ Bỏ</button>
                    </div>
                </div>

                <div class="userInfor-body-desc">
                    <p>Họ Và Tên:</p>
                    <span id="lblDisplayName">ABC</span>
                    <input id="tblDisplayName" class="hide" type="text">
                </div>

                <div class="userInfor-body-desc">
                    <p>Số Điện Thoại:</p>
                    <span id="lblPhoneNumber">ABC</span>
                    <input id="tblPhoneNumber" class="hide" type="tel">
                </div>

                <div class="userInfor-body-desc">
                    <p>Trạng Thái Tài Khoản:</p>
                    <span id="lblStatus">ABC</span>
                </div>

                <div class="userInfor-body-desc">
                    <p>Quyền Người Dùng:</p>
                    <span id="lblUserType">ABC</span>
                </div>

                <div class="userInfor-body-desc">
                    <p>Địa Chỉ Email:</p>
                    <span id="lblEmail">ABC</span>
                    <input id="tblEmail" class="hide" type="email">
                </div>

                <div class="userInfor-body-desc">
                    <p>Ngày Gia Nhập:</p>
                    <span id="lblDateJoin">ABC</span>
                    <input id="tblDateJoin" class="hide" type="date">
                </div>

                <div class="userInfor-body-desc">
                    <p>Công Việc:</p>
                    <span id="lblJob">ABC</span>
                    <input id="tblJob" class="hide" type="text">
                </div>

                <div class="userInfor-body-desc">
                    <p>Phòng Ban:</p>
                    <span id="lblDepartment">ABC</span>
                    <input id="tblDepartment" class="hide" type="text">
                </div>

                <div class="userInfor-body-desc">
                    <p>Giới Tính:</p>
                    <span id="lblGender">ABC</span>
                    <select id="sltGender" class="hide">
                        <option value="male">Nam</option>
                        <option value="female">Nữ</option>
                    </select>
                </div>

                <div class="userInfor-body-desc">
                    <p>Ngày Sinh:</p>
                    <span id="lblDateOfBirth">ABC</span>
                    <input id="tblDateOfBirth" class="hide" type="date">
                </div>

                <div class="userInfor-body-desc">
                    <p>Địa Chỉ:</p>
                    <span id="lblAddress">ABC</span>
                    <input id="tblAddress" class="hide" type="text">
                </div>

                <div class="userInfor-body-desc">
                    <p>Mã Tài Khoản:</p>
                    <span id="lblUserId">ABC</span>
                </div>

                <div class="userInfor-body-desc">
                    <p>Mã Google:</p>
                    <span id="lblGoogleId">ABC</span>
                </div>

                <div class="userInfor-body-desc">
                    <p>Số Tin Đã Nhắn:</p>
                    <asp:Label ID="lblMessageCount" runat="server"></asp:Label>
                </div>

                <div class="userInfor-body-desc">
                    <p>Số Ngày Hoạt Động:</p>
                    <asp:Label ID="lblDateOnl" runat="server"></asp:Label>
                </div>
            </div>
        </div>

    </div>

    <script>
        //Upload Avatar
        function uploadFile() {
            var fileInput = document.getElementById('file-upload');
            var file = fileInput.files[0];

            if (file) {
                var userId = $("#ContentPlaceHolder1_lblCurrentUserId").text(); console.log(userId);
                var formData = new FormData();
                formData.append('file', file);
                formData.append('userId', userId);

                var xhr = new XMLHttpRequest();
                xhr.open('POST', 'UserInfor.aspx', true);
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        console.log("Upload avatar success");
                    }
                };
                xhr.send(formData);
            }
        }

        //Xem trước hình ảnh
        function previewImageFile(event) {
            var imgElement = document.getElementById('ifAvatar');

            var selectedFile = event.target.files[0];

            if (selectedFile) {
                var reader = new FileReader();

                // Đọc tập tin và cập nhật thuộc tính src của thẻ img
                reader.onload = function (e) {
                    imgElement.src = e.target.result;
                }

                // Đọc dữ liệu tập tin như URL dạng base64
                reader.readAsDataURL(selectedFile);
            };
        };


















        // function cập nhật dữ liệu
        function handleUpdateData() {
            var Gender;

            if ($("#sltGender").val() == "female") {
                Gender = "Nữ";
            } else {
                Gender = "Nam";
            }


            var data = {
                "UserId": $("#ContentPlaceHolder1_lblCurrentUserId").text(),
                "DisplayName": $("#tblDisplayName").val(),
                "PhoneNumber": $("#tblPhoneNumber").val(),
                "Email": $("#tblEmail").val(),
                "AtCreate": $("#tblDateJoin").val(),
                "Job": $("#tblJob").val(),
                "Department": $("#tblDepartment").val(),
                "Gender": Gender,
                "DateOfBirth": $("#tblDateOfBirth").val(),
                "Address": $("#tblAddress").val(),
            }

            console.log(data)

            $.ajax({
                type: "POST",
                url: "UserInfor.aspx/UpdateDataUser",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (response) {
                    if (response.d == true) {
                        showSuccessToast("Đã cập nhật thông tin thành công") //Thông báo

                        ShowUserInforByCurrentId(); //hiển thị lại dữ liệu sau khi cập nhật
                        handleHideEditUser(); //ẩn cặp thẻ edit
                    }
                },
                error: function (error) {
                    console.log("Có lỗi xảy ra khi cập nhật dữ liệu: " + error);
                    showErrorToast("Có lỗi xảy ra khi cập nhật dữ liệu, vui lòng kiểm tra lại");
                }
            });

            uploadFile() // Cập nhật hình ảnh
        }



        // function hiển thị dữ liệu người dùng
        function ShowUserInforByCurrentId() {
            var data = {
                "Id": $("#ContentPlaceHolder1_lblCurrentUserId").text(),
            }

            $.ajax({
                type: "POST",
                "url": "UserInfor.aspx/ShowUserInforByCurrentId",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var userInfor = JSON.parse(response.d)

                    if (response.d != null) {
                        $("#lblDisplayName").text(userInfor.DisplayName);
                        $("#lblPhoneNumber").text(userInfor.PhoneNumber);
                        $("#lblEmail").text(userInfor.Email);
                        $("#lblDateJoin").text(formatDate(userInfor.AtCreate));
                        $("#lblJob").text(userInfor.Job);
                        $("#lblDepartment").text(userInfor.Department);
                        $("#lblGender").text(userInfor.Gender);
                        $("#lblDateOfBirth").text(formatDate(userInfor.DateOfBirth));
                        $("#lblAddress").text(userInfor.Address);
                        $("#lblUserId").text(userInfor.Id);
                        $("#lblGoogleId").text(userInfor.GoogleId);
                        $("#lblMessageCount").text();
                        $("#lblDateOnl").text();

                        $("#ifDisplayName").text(userInfor.DisplayName);
                        $("#ifAvatar").attr("src", userInfor.Avatar)
                        $("#ifJob").text(userInfor.Job);
                        $("#ifAtCreate").text(formatDate(userInfor.AtCreate));

                        switch (userInfor.Status) {
                            case 0:
                                $("#lblStatus").text("Chưa Kích Hoạt");
                                break;
                            case 1:
                                $("#lblStatus").text("Đã Kích Hoạt");
                                $("#ifStatus").css("color", "Green");
                                break;
                            case 2:
                                $("#lblStatus").text("Vô Hiệu Hoá");
                                $("#ifStatus").css("color", "Red");
                                break;
                        }
                        switch (userInfor.UserType) {
                            case 0:
                                $("#lblUserType").text("Quản Trị Viên");
                                break;
                            case 1:
                                $("#lblUserType").text("Nhân Viên");
                                break;
                        }
                    }
                },
                error: function (err) {

                }
            })
        }

        ShowUserInforByCurrentId()
    </script>

    <script src="JS/userInfor.js"></script>
    <script src="JS/toast.js"></script>

</asp:Content>
