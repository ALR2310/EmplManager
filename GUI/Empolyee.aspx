<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Empolyee.aspx.cs" Inherits="GUI.Empolyee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/toast.css" />
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>



    <div class="content">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <contenttemplate>

                <div class="employee-management">
                    <div class="employee">
                        <div class="employee-header">
                            <div class="employee-header__content">
                                <p class="employee-header-title">
                                    <asp:Label ID="lblCountEmpolyee" runat="server" Text="0"></asp:Label>
                                    Thành Viên
                                </p>

                                <div class="employee-header-filter">
                                    <select id="drplist_filterEmpolyee" onchange="handleFilterEmpolyee()">
                                        <option value="0">Tất cả nhân viên</option>
                                        <option value="1">Đã kích hoạt</option>
                                        <option value="2">Chưa kích hoạt</option>
                                        <option value="3">Đã vô hiệu</option>
                                        <option value="4">Quản Trị Viên</option>
                                    </select>
                                </div>

                                <div class="employee-header-search">
                                    <asp:TextBox ID="tblSearch" runat="server" TextMode="Search" OnTextChanged="tblSearch_TextChanged"
                                        AutoCompleteType="DisplayName" placeholder="Tên Nhân Viên">
                                    </asp:TextBox>
                                    <a runat="server" onserverclick="btnSearch_ServerClick" title="Tìm kiếm theo tên nhân viên, công việc và số Id">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                    </a>
                                </div>
                            </div>

                            <div class="employee-header__content">
                                <p>
                                    Đã Chọn 
                                    <span id="lblcountselected">0</span>
                                </p>

                                <button type="button" onclick="employeeShowEllipsis(event, 'block')"
                                    onmouseleave="employeeShowEllipsis(event, 'none')"
                                    class="employee-header__ellipsis">
                                    <i class="fa-solid fa-ellipsis-vertical"></i>

                                    <ul class="employee-card__ellipsis">
                                        <li id="clearCheckbox">Bỏ Chọn Tất Cả</li>
                                        <li class="subEllipsis-Card">◂Thay Đổi Trạng Thái
                                            <ul class="employee-card__subEllipsis">
                                                <li onclick="handleCheckboxSelection(1)">Kích Hoạt</li>
                                                <li onclick="handleCheckboxSelection(2)">Vô Hiệu</li>
                                            </ul>
                                        </li>
                                        <li onclick="showModalDeleteUser()">Xoá Tài Khoản</li>

                                        <box class="boxhidentop"></box>
                                        <box class="boxhidenbottom"></box>
                                    </ul>
                                </button>
                            </div>
                        </div>


                        <div class="employee-body">
                            <div class="employee-body-list">

                                <asp:Repeater ID="Repeater1" runat="server">
                                    <itemtemplate>

                                        <div class="employee-body-card" commandargument='<%# Eval("Id") %>' usrtype='<%# Eval("UserType") %>' isdrop='<%# Eval("Status") %>'>
                                            <div class="employee-card__header" commandargument='<%# Eval("Id") %>' onmouseenter="getStatusAndChanges(this)">
                                                <input type="checkbox" usrid='<%# Eval("Id") %>' onchange="countCheckboxSelection()" class="employee-card__header-checkbox">
                                                <div class="employee-card__header-action">
                                                    <button id="btnStatus" type="button" class="employee-card__header-status"
                                                        commandargument='<%# Eval("Status") %>' empolyeecardid='<%# Eval("Id") %>'>
                                                        Đã Kích Hoạt
                                                    </button>
                                                    <button type="button" onclick="employeeShowEllipsis(event, 'block')"
                                                        onmouseleave="employeeShowEllipsis(event, 'none')"
                                                        class="employee-card__header-ellipsis">
                                                        <i class="fa-solid fa-ellipsis-vertical"></i>
                                                        <ul class="employee-card__ellipsis">
                                                            <li commandargument='<%# Eval("Id") %>' onclick="getDataforClickShow(this)">Xem Thông Tin
                                                            </li>
                                                            <li class="subEllipsis-Card">Thay Đổi Trạng Thái▸
                                                        <ul class="employee-card__subEllipsis">
                                                            <li onclick="handleToggleStatusClick(1)">Kích Hoạt</li>
                                                            <li onclick="handleToggleStatusClick(2)">Vô Hiệu</li>
                                                        </ul>
                                                            </li>
                                                            <li onclick="showModalDeleteUser()">Xoá Tài Khoản
                                                            </li>

                                                            <box class="boxhidentop"></box>
                                                            <box class="boxhidenbottom"></box>
                                                        </ul>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="employee-card__body">
                                                <a class="employee-card__body-avatar" title="Xem Thông Tin Chi Tiết"
                                                    commandargument='<%# Eval("Id") %>' onclick="getDataforClickShow(this)">
                                                    <img alt="" src="<%# Eval("Avatar") %>" />
                                                </a>

                                                <div class="employee-card__body-name">
                                                    <h4 usrid="<%# Eval("Id") %>"><%# Eval("DisplayName") %></h4>
                                                    <p usrid="<%# Eval("Id") %>"><%# Eval("Job") %></p>
                                                </div>
                                                <div class="employee-card-desc">
                                                    <div class="employee-card-desc__header">
                                                        <div id="department" class="employee-card-desc-infor">
                                                            <h5>Phòng Ban</h5>
                                                            <p usrid="<%# Eval("Id") %>"><%# Eval("Department") %></p>
                                                        </div>

                                                        <div id="datejoin" class="employee-card-desc-infor">
                                                            <h5>Ngày Tham Gia</h5>
                                                            <p usrid="<%# Eval("Id") %>"><%# Eval("AtCreate", "{0:dd/MM/yyyy}") %></p>
                                                        </div>
                                                    </div>
                                                    <div class="employee-card-desc__body">
                                                        <p id="email" usrid="<%# Eval("Id") %>">
                                                            <i class="fa-solid fa-envelope"></i>
                                                            <%# Eval("Email") %>
                                                        </p>

                                                        <p id="phonenumber" usrid="<%# Eval("Id") %>">
                                                            <i class="fa-solid fa-phone"></i>
                                                            <%# Eval("PhoneNumber") %>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </itemtemplate>
                                </asp:Repeater>


                            </div>
                        </div>

                    </div>
                </div>

            </contenttemplate>
        </asp:UpdatePanel>

    </div>


    <div class="modal-vertical hide">
        <span class="modal-vertical__overlay"></span>

        <div class="modal-vertical__container">
            <button type="button" class="modal-vertical__close" onclick="hidenModal(event)">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <h2 class="modal-vertical__container-title">Chi Tiết Thông Tin</h2>

            <div class="userInfor">
                <div class="userInfor-Avatar">
                    <div class="userInfor__image">
                        <img id="AvatarImg" alt="" src="#" />
                        <button id="userIdinfor" type="button" class="employee-card__header-status Active">Active</button>
                    </div>
                    <div class="userInfor__desc">
                        <p>
                            <span id="lblDisplayName">Not Infor</span>
                        </p>
                        <span id="lblJob">Not Infor</span>
                    </div>
                </div>

                <div class="userInfor-SendMail">
                    <button type="button">
                        <i class="fa-regular fa-envelope"></i>
                        Gửi Email
                                <asp:Button runat="server" ID="btnSendMail" Style="display: none;" />
                    </button>
                </div>
            </div>

            <div class="userInfor-Detail">
                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Họ Và Tên:</p>
                        <span id="lblDisplayName1">Not Infor</span>
                    </div>
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Số Điện Thoại:</p>
                        <span id="lblPhoneNumber">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__editor hide">
                        <input autocomplete="on" id="tblDisplayName" />
                        <p>Họ Và Tên:</p>
                    </div>
                    <div class="userInfor-Detail__editor hide">
                        <input autocomplete="on" type="tel" id="tblPhoneNumber" />
                        <p>Số Điện Thoại:</p>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Trạng Thái Tài Khoản:</p>
                        <span id="lblStatus">Not Infor</span>
                    </div>
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Quyền Người Dùng:</p>
                        <span id="lblUserType">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__editor hide">
                        <select id="sltStatus" class="editor_select">
                            <option value="1">Đã Kích Hoạt</option>
                            <option value="0">Chưa Kích Hoạt</option>
                            <option value="2">Vô Hiệu Hoá</option>
                        </select>
                        <p>Trạng Thái Tài Khoản:</p>
                    </div>
                    <div class="userInfor-Detail__editor hide">
                        <select id="sltUserType" class="editor_select">
                            <option value="0">Quản Trị Viên</option>
                            <option value="1">Nhân Viên</option>
                        </select>
                        <p>Quyền Người Dùng:</p>
                    </div>
                </div>
                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Email:</p>
                        <span id="lblEmail">Not Infor</span>
                    </div>
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Ngày Gia Nhập:</p>
                        <span id="lblDateJoin">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__editor hide">
                        <input type="email" id="tblEmail" />
                        <p>Email:</p>
                    </div>
                    <div class="userInfor-Detail__editor hide">
                        <input type="date" id="tblDateJoin" />
                        <p>Ngày Gia Nhập:</p>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Công Việc:</p>
                        <span id="lblJob1">Not Infor</span>
                    </div>
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Phòng Ban:</p>
                        <span id="lblDepartment">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__editor hide">
                        <input list="dtlJob" id="tblJob" />
                        <datalist id="dtlJob" class="editor_select">
                            <option value="Lập Trình Viên" />
                            <option value="Tester" />
                            <option value="Thư Ký" />
                            <option value="Kế Toán" />
                            <option value="Thực Tập Sinh" />
                        </datalist>
                        <p>Công Việc:</p>
                    </div>
                    <div class="userInfor-Detail__editor hide">
                        <input list="dldepartment" id="tblDepartment" />
                        <datalist id="dldepartment" class="editor_select">
                            <option value="SweetSoft" />
                        </datalist>
                        <p>Phòng Ban:</p>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Giới Tính:</p>
                        <span id="lblGender">Not Infor</span>
                    </div>
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Ngày Sinh:</p>
                        <span id="lblDateOfBirth">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__editor hide">
                        <select id="sltGender" class="editor_select">
                            <option value="Nam">Nam</option>
                            <option value="Nữ">Nữ</option>
                        </select>
                        <p>Giới Tính:</p>
                    </div>
                    <div class="userInfor-Detail__editor hide">
                        <input type="date" id="tblDateOfBirth" />
                        <p>Ngày Sinh:</p>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor" enbedit="1">
                        <p>Địa Chỉ:</p>
                        <span id="lblAddress">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__editor hide">
                        <input id="tblAddress" />
                        <p>Địa Chỉ:</p>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Id Tài Khoản:</p>
                        <span id="lblUserId">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Google Id:</p>
                        <span id="lblGoogleId">Not Infor</span>
                    </div>
                </div>
            </div>


            <div class="userInfor-Detail__title">
                Quản Lí Tài Khoản
            </div>

            <div class="userInfor-Detail__action">
                <div class="userInfor-Detail1">
                    <div class="UIDetail__action">
                        <p>Thay Đổi Trạng Thái Tài Khoản:</p>
                    </div>
                    <div class="UIDetail__action">
                        <button type="button" class="btnEnable" onclick="handleToggleStatusClick(1)">Kích Hoạt</button>
                        <button type="button" class="btnDisable" onclick="handleToggleStatusClick(2)">Vô Hiệu</button>
                    </div>
                </div>

                <div id="divEdit" class="userInfor-Detail1">
                    <div class="UIDetail__action">
                        <p>Chỉnh Sửa Thông Tin Tài Khoản:</p>
                    </div>
                    <div class="UIDetail__action">
                        <button type="button" class="btnUserType" onclick="handleShowEditorButton(1)">Chỉnh Sửa Ngay</button>
                    </div>
                </div>

                <div id="divSave" class="userInfor-Detail1 hide">
                    <div class="UIDetail__action">
                        <p>Chỉnh Sửa Thông Tin Tài Khoản:</p>
                    </div>
                    <div class="UIDetail__action">
                        <button type="button" class="btnEdit" onclick="UpdateInforEmpolyee()">Cập Nhật</button>
                        <button type="button" class="btnCancel" onclick="handleShowEditorButton(2)">Huỷ Bỏ</button>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="UIDetail__action">
                        <p>Xoá Tài Khoản Vĩnh Viễn:</p>
                    </div>
                    <div class="UIDetail__action">
                        <button type="button" onclick="showModalDeleteUser()" class="btnDelete">Xoá Tài Khoản Này</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="UIdetail-modal-delete-overlay hide">
        <div class="UIdetail-modal-delete ">
            <h3>Bạn có chắc muốn xoá tài khoản này không?</h3>
            <p>Tài khoản sẽ bị xoá vĩnh viễn và không thể khôi phục lại được.</p>
            <div>
                <button type="button" onclick="handleDeleteUser()">Xoá Ngay</button>
                <button type="button" onclick="hideModalDeleteUser()">Huỷ Bỏ</button>
            </div>
        </div>
    </div>

    <script>

        //Xoá các users được chọn
        function handleDeleteUserSeleted(usridArray) {
            var data = { "userIdarr": usridArray}

            $.ajax({
                type: "POST",
                "url": "empolyee.aspx/DeleteAllUserSelect",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {

                },
                error: function(err) {
                    console.log("Đã có lỗi xảy ra: "+ err);
                }
            })
        }


        //Thay đổi Status tất cả user được selected
        function handleChangeStatusSelected(statusid ,usridArray) {
            var data = {
                "status": statusid,
                "userIdarr": usridArray
            }
            $.ajax({
                type: "POST",
                "url": "empolyee.aspx/ChangeStatusAllSelectUser",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(response) {
                    if(response.d == 1) {
                        showSuccessToast("Đã Kích Hoạt Tài Khoản Thành Công");
                    } else if(response.d == 2) {
                        showSuccessToast("Đã Vô Hiệu Tài Khoản Thành Công");
                    }

                },
                error: function(err) {
                    console.log(err);
                }
            })
        }


        //Lấy và đưa dữ liệu lên userinfor 
        function handleBindingDataInfor() {
            var id = $("#lblUserId").text();
            var UserId = { "UserId": id };

            $.ajax({
                type: "POST",
                "url": "empolyee.aspx/GetUserIdByJS",
                "data": JSON.stringify(UserId),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var empolyeeInfo = JSON.parse(response.d);

                    if (empolyeeInfo != null) {
                        $("#AvatarImg").attr("src", empolyeeInfo.Avatar);
                        $("#lblDisplayName").text(empolyeeInfo.DisplayName);
                        $("#lblDisplayName1").text(empolyeeInfo.DisplayName);
                        $("#lblJob").text(empolyeeInfo.Job);
                        $("#lblJob1").text(empolyeeInfo.Job);
                        $("#lblPhoneNumber").text(empolyeeInfo.PhoneNumber);
                        $("#lblDepartment").text(empolyeeInfo.Department);
                        $("#lblEmail").text(empolyeeInfo.Email);
                        $("#lblDateOfBirth").text(formatDate(empolyeeInfo.DateOfBirth));
                        $("#lblDateJoin").text(formatDate(empolyeeInfo.AtCreate));
                        $("#lblGender").text(empolyeeInfo.Gender);
                        $("#lblAddress").text(empolyeeInfo.Address);
                        $("#lblUserId").text(empolyeeInfo.Id);

                        var googleId = empolyeeInfo.GoogleId;
                        if (googleId == 0) {
                            $("#lblGoogleId").text("Không Có Thông Tin");
                        }

                        var isStatus = document.querySelector("#userIdinfor");
                        var isAvatarImage = document.querySelector("#AvatarImg");
                        var NoActiveClass = "noActive";
                        var ActiveClass = "Active";

                        var status = empolyeeInfo.Status;
                        switch (status) {
                            case 0:
                                $("#lblStatus").text("Chưa Kích Hoạt");
                                isStatus.textContent = "Chưa Kích Hoạt";
                                isStatus.classList.remove(ActiveClass);
                                isStatus.classList.remove(NoActiveClass);

                                isAvatarImage.classList.remove(ActiveClass);
                                isAvatarImage.classList.remove(NoActiveClass);
                                break;
                            case 1:
                                $("#lblStatus").text("Đã Kích Hoạt");
                                isStatus.textContent = "Đã Kích Hoạt";
                                isStatus.classList.add(ActiveClass);
                                isStatus.classList.remove(NoActiveClass);

                                isAvatarImage.classList.add(ActiveClass);
                                isAvatarImage.classList.remove(NoActiveClass);
                                break;
                            case 2:
                                $("#lblStatus").text("Vô Hiệu Hoá");
                                isStatus.textContent = "Vô Hiệu Hoá";
                                isStatus.classList.add(NoActiveClass);
                                isStatus.classList.remove(ActiveClass);

                                isAvatarImage.classList.add(NoActiveClass);
                                isAvatarImage.classList.remove(ActiveClass);
                                break;
                        }

                        var userType = empolyeeInfo.UserType;
                        switch (userType) {
                            case 0:
                                $("#lblUserType").text("Quản Trị Viên")
                                break;
                            case 1:
                                $("#lblUserType").text("Nhân Viên")
                                break;
                        }


                        var displayName = document.querySelectorAll(".employee-card__body-name h4");
                        var job = document.querySelectorAll(".employee-card__body-name p");
                        var department = document.querySelectorAll("#department p");
                        var datejoin = document.querySelectorAll("#datejoin p");
                        var email = document.querySelectorAll("#email");
                        var phoneNumber = document.querySelectorAll("#phonenumber");

                        displayName.forEach((displayNameCard) => {
                            var idCard = displayNameCard.getAttribute("usrid");
                            if (idCard == id) {
                                displayNameCard.textContent = $("#lblDisplayName1").text();
                            }
                        });

                        job.forEach((jobCard) => {
                            var idCard = jobCard.getAttribute("usrid");
                            if (idCard == id) {
                                jobCard.textContent = $("#lblJob").text();
                            }
                        });

                        department.forEach((departmentCard) => {
                            var idCard = departmentCard.getAttribute("usrid");
                            if (idCard == id) {
                                departmentCard.textContent = $("#lblDepartment").text();
                            }
                        });

                        datejoin.forEach((datejoinCard) => {
                            var idCard = datejoinCard.getAttribute("usrid");
                            if (idCard == id) {
                                datejoinCard.textContent = $("#lblDateJoin").text();
                            }
                        });

                        email.forEach((emailCard) => {
                            var idCard = emailCard.getAttribute("usrid");
                            if (idCard == id) {
                                emailCard.textContent = $("#lblEmail").text();
                            }
                        });

                        phoneNumber.forEach((phoneNumberCard) => {
                            var idCard = phoneNumberCard.getAttribute("usrid");
                            if (idCard == id) {
                                phoneNumberCard.textContent = $("#lblPhoneNumber").text();
                            }
                        });
                    }
                },
                error: function (error) {
                    console.log(error)
                }
            })
        }

        //Cập nhật dữ liệu người dùng
        function UpdateInforEmpolyee() {
            var UserId = $("#lblUserId").text();
            var data = {
                userid: UserId,
                displayName: $("#tblDisplayName").val(),
                phoneNumber: $("#tblPhoneNumber").val(),
                email: $("#tblEmail").val(),
                dateJoin: $("#tblDateJoin").val(),
                job: $("#tblJob").val(),
                department: $("#tblDepartment").val(),
                gender: $("#sltGender").val(),
                dateOfBirth: $("#tblDateOfBirth").val(),
                address: $("#tblAddress").val(),
                userType: $("#sltUserType").val(),
                status: $("#sltStatus").val()
            };

            $.ajax({
                type: "POST",
                url: "empolyee.aspx/UpdateDataEmpolyee",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                data: JSON.stringify(data),
                success: function (response) {
                    showSuccessToast("Đã cập nhật dữ liệu cho người dùng này thành công") //Thông báo
                    handleShowEditorButton(2) //Đóng trang edit
                    handleBindingDataInfor() // binding dữ liệu sau khi cập nhật
                },
                error: function (xhr, status, error) {
                    console.log("Có lỗi xảy ra khi cập nhật dữ liệu: " + error);
                    showErrorToast("Có lỗi xảy ra khi cập nhật dữ liệu, vui lòng kiểm tra lại");
                }
            });

        }

        //Đưa dữ liệu từ các lable vào textbox
        function bindingDataUpDivEditor() {
            $("#tblDisplayName").val($("#lblDisplayName1").text());
            $("#tblPhoneNumber").val($("#lblPhoneNumber").text());
            $("#tblEmail").val($("#lblEmail").text());
            $("#tblDateJoin").val($("#lblDateJoin").text().split("/").reverse().join("-"));
            $("#tblJob").val($("#lblJob1").text());
            $("#tblDepartment").val($("#lblDepartment").text());
            $("#tblDateOfBirth").val($("#lblDateOfBirth").text().split("/").reverse().join("-"));
            $("#tblAddress").val($("#lblAddress").text());
            //Gender
            if ($("#lblGender").text() == "Nam") { $("#sltGender").val("Nam") }
            else if ($("#lblGender").text() == "Nữ") { $("#sltGender").val("Nữ") }
            //Status
            if ($("#lblStatus").text() == "Đã Kích Hoạt") { $("#sltStatus").val(1); }
            else if ($("#lblStatus").text() == "Chưa Kích Hoạt") { $("#sltStatus").val(0); }
            else if ($("#lblStatus").text() == "Vô Hiệu Hoá") { $("#sltStatus").val(2); }
            //UserType
            if ($("#lblUserType").text() == "Quản Trị Viên") { $("#sltUserType").val(0) }
            else if ($("#lblUserType").text() == "Nhân Viên") { $("#sltUserType").val(1) }
        }

        //ẩn hiện hiển thị các nút chỉnh sửa và cập nhật
        function handleShowEditorButton(action) {
            const btndivEdit = document.getElementById("divEdit");
            const btndivSave = document.getElementById("divSave");

            if (action == 1) {
                btndivSave.classList.remove("hide");
                btndivEdit.classList.add("hide");

                handleShowDivEditor("show")
                bindingDataUpDivEditor() //binding dữ liệu
            } else {
                btndivSave.classList.add("hide");
                btndivEdit.classList.remove("hide");

                handleShowDivEditor("hidden")
            }
        }

        //ẩn hiện các khối chứa thẻ lable và hiển thị các textbox edit
        function handleShowDivEditor(action) {
            const divEditor = document.querySelectorAll(".userInfor-Detail__editor")
            const divInfor = document.querySelectorAll(".userInfor-Detail__infor")

            if (action == "show") {
                divEditor.forEach((diveditor) => {
                    diveditor.classList.remove("hide");
                });

                divInfor.forEach((divInforEdit) => {
                    const enbedit = divInforEdit.getAttribute("enbedit");
                    if (enbedit == 1) {
                        divInforEdit.classList.add("hide");
                    }
                });
            } else if (action == "hidden") {
                divEditor.forEach((diveditor) => {
                    diveditor.classList.add("hide");
                });

                divInfor.forEach((divInforEdit) => {
                    const enbedit = divInforEdit.getAttribute("enbedit");
                    if (enbedit == 1) {
                        divInforEdit.classList.remove("hide");
                    }
                });
            }
        }
    </script>

    <script src="JS/empolyee.js"></script>
    <script src="JS/toast.js"></script>



</asp:Content>
