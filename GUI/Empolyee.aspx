<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Empolyee.aspx.cs" Inherits="GUI.Empolyee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/toast.css" />
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>



    <div class="content">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <div class="employee-management">
                    <div class="employee">
                        <div class="employee-header">
                            <div class="employee-header__content">
                                <p class="employee-header-title">
                                    <asp:Label ID="lblCountEmpolyee" runat="server" Text="0"></asp:Label>
                                    Thành Viên
                                </p>

                                <div class="employee-header-filter">
                                    <asp:DropDownList ID="DrpFilterSelect" runat="server">
                                        <asp:ListItem Selected="True" Value="0">Tất Cả Nh&#226;n Vi&#234;n</asp:ListItem>
                                        <asp:ListItem Value="1">Đ&#227; K&#237;ch Hoạt</asp:ListItem>
                                        <asp:ListItem Value="2">Chưa K&#237;ch Hoạt</asp:ListItem>
                                        <asp:ListItem Value="3">Đ&#227; V&#244; Hiệu</asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="employee-header-search">
                                    <asp:TextBox ID="tblSearch" runat="server" TextMode="Search" OnTextChanged="tblSearch_TextChanged" AutoCompleteType="DisplayName" placeholder="Tên Nhân Viên"></asp:TextBox>
                                    <%--<input type="search" placeholder="Tên Nhân Viên">--%>
                                    <%--<button type="button" onclick="handleSearch()" title="Tìm kiếm theo tên nhân viên, công việc và số Id">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                        <asp:Button runat="server" ID="btnSearch" Style="display: none;" />
                                    </button>--%>
                                    <a>
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                    </a>
                                </div>
                            </div>

                            <div class="employee-header__content">
                                <p>
                                    Đã Chọn 
                            <asp:Label ID="lblSelectCount" runat="server" Text="0"></asp:Label>
                                </p>

                                <button type="button" onclick="employeeShowEllipsis(event, 'block')"
                                    onmouseleave="employeeShowEllipsis(event, 'none')"
                                    class="employee-header__ellipsis">
                                    <i class="fa-solid fa-ellipsis-vertical"></i>

                                    <ul class="employee-card__ellipsis">
                                        <li id="clearCheckbox">Bỏ Chọn Tất Cả
                                        </li>
                                        <li class="subEllipsis-Card">◂Thay Đổi Trạng Thái
                                            <ul class="employee-card__subEllipsis">
                                                <li>Kích Hoạt</li>
                                                <li>Vô Hiệu</li>
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


                        <div class="employee-body">
                            <div class="employee-body-list">

                                <asp:Repeater ID="Repeater1" runat="server">
                                    <ItemTemplate>

                                        <div class="employee-body-card" commandargument='<%# Eval("Id") %>'>
                                            <div class="employee-card__header" commandargument='<%# Eval("Id") %>' onmouseenter="getStatusAndChanges(this)">
                                                <input type="checkbox" class="employee-card__header-checkbox">
                                                <div class="employee-card__header-action">
                                                    <button id="btnStatus" type="button" class="employee-card__header-status  "
                                                        commandargument='<%# Eval("Status") %>' empolyeecardid='<%# Eval("Id") %>'>
                                                        Active
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
                                                    <h4><%# Eval("DisplayName") %></h4>
                                                    <p><%# Eval("Job") %></p>
                                                </div>
                                                <div class="employee-card-desc">
                                                    <div class="employee-card-desc__header">
                                                        <div class="employee-card-desc-infor">
                                                            <h5>Phòng Ban</h5>
                                                            <p><%# Eval("Department") %></p>
                                                        </div>

                                                        <div class="employee-card-desc-infor">
                                                            <h5>Ngày Tham Gia</h5>
                                                            <p><%# Eval("AtCreate", "{0:dd/MM/yyyy}") %></p>
                                                        </div>
                                                    </div>
                                                    <div class="employee-card-desc__body">
                                                        <p>
                                                            <i class="fa-solid fa-envelope"></i>
                                                            <%# Eval("Email") %>
                                                        </p>

                                                        <p>
                                                            <i class="fa-solid fa-phone"></i>
                                                            <%# Eval("PhoneNumber") %>
                                                        </p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                    </ItemTemplate>
                                </asp:Repeater>


                            </div>
                        </div>

                    </div>
                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>


    <div class="modal-vertical hide">
        <span class="modal-vertical__overlay"></span>

        <%--<asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>--%>

        <div class="modal-vertical__container">
            <button type="button" class="modal-vertical__close" onclick="hidenModal(event)">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <h2 class="modal-vertical__container-title">Chi Tiết Thông Tin</h2>

            <div class="userInfor">
                <div class="userInfor-Avatar">
                    <div class="userInfor__image">
                        <img id="AvatarImg" alt="" src="#" />
                    </div>
                    <div class="userInfor__desc">
                        <p>
                            <span id="lblDisplayName">Not Infor</span>
                            <button id="userIdinfor" type="button" class="employee-card__header-status Active">Active</button>
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
                    <div class="userInfor-Detail__infor">
                        <p>Họ Và Tên:</p>
                        <span id="lblDisplayName1">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Số Điện Thoại:</p>
                        <span id="lblPhoneNumber">Not Infor</span>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Trạng Thái Tài Khoản:</p>
                        <span id="lblStatus">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Loại Tài Khoản:</p>
                        <span id="lblUserType">Not Infor</span>
                    </div>
                </div>
                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Email:</p>
                        <span id="lblEmail">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Ngày Tham Gia:</p>
                        <span id="lblDateJoin">Not Infor</span>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Công Việc:</p>
                        <span id="lblJob1">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Phòng Ban:</p>
                        <span id="lblDepartment">Not Infor</span>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Giới Tính:</p>
                        <span id="lblGender">Not Infor</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Ngày Sinh:</p>
                        <span id="lblDateOfBirth">Not Infor</span>
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

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Địa Chỉ:</p>
                        <span id="lblAddress">Not Infor</span>
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
                        <button type="button" class="btnEnable" onclick="handleToggleStatusClick(1)">Enable</button>
                        <button type="button" class="btnDisable" onclick="handleToggleStatusClick(2)">Disable</button>
                    </div>
                </div>

                <div id="divAdminAdd" class="userInfor-Detail1">
                    <div class="UIDetail__action">
                        <p>Cấp Quyền Admin:</p>
                    </div>
                    <div class="UIDetail__action">
                        <button type="button" class="btnUserType" onclick="handleToggleUserTypeClick(0)">Cấp Quyền Ngay</button>
                    </div>
                </div>

                <div id="divAdminRemove" class="userInfor-Detail1 hide" onclick="handleToggleUserTypeClick(1)">
                    <div class="UIDetail__action">
                        <p>Loại Bỏ Quyền Admin:</p>
                    </div>
                    <div class="UIDetail__action">
                        <button type="button" class="btnUserType">Xoá Quyền Admin</button>
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

        <%--</ContentTemplate>
        </asp:UpdatePanel>--%>
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
        //Hàm thực hiện chức năng ẩn usercard khi đã xoá
        function handleHideUserCard() {
            var userCard = document.querySelectorAll(".employee-body-card")
            var id = $("#lblUserId").text();

            userCard.forEach((UserCardId) => {
                const getId = UserCardId.getAttribute("commandargument");

                if (getId == id) {
                    UserCardId.classList.add("hide");
                }
            });
        }

        //Hàm thực hiện chức năng xoá tài khoản
        function handleDeleteUser() {
            var id = $("#lblUserId").text();
            var data = {
                "UserId": id
            };

            $.ajax({
                type: "POST",
                "url": "empolyee.aspx/DeleteUser",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == true) {
                        hideModalDeleteUser();
                        hidenModal();
                        handleHideUserCard();
                        showSuccessToast("Bạn đã xoá tài khoản này thành công");
                    } else {
                        showWarningToast("Xoá tài khoản thất bại");
                    }
                },
                error: function (err) {
                    console.log(err)
                }
            })
        }

        //Hàm thực hiện chức năng cấp quyền Admin
        function handleToggleUserTypeClick(UserTypeId) {
            var id = $("#lblUserId").text();
            var data = {
                "UserId": id,
                "UserType": UserTypeId
            };

            $.ajax({
                type: "POST",
                "url": "empolyee.aspx/ChangeUserType",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    divAdminAdd = document.getElementById("divAdminAdd");
                    divAdminRemove = document.getElementById("divAdminRemove");
                    if (response.d == true) {
                        divAdminAdd.classList.add("hide");
                        divAdminRemove.classList.remove("hide");
                        $("#lblUserType").text("Administrator");
                        showSuccessToast("Đã cấp quyền Administrator cho người dùng này");
                    }
                    else {
                        divAdminAdd.classList.remove("hide");
                        divAdminRemove.classList.add("hide");
                        $("#lblUserType").text("User");
                        showSuccessToast("Đã loại bỏ quyền Administrator của người dùng này");
                    }
                },
                error: function (error) {
                    console.log(error)
                }
            })
        }

        //Hàm kiểm tra userType
        function checkUserType() {
            var divAdminAdd = document.getElementById("divAdminAdd");
            var divAdminRemove = document.getElementById("divAdminRemove");
            var currentUserType = document.getElementById("lblUserType");

            switch (currentUserType.textContent) {
                case "Administrator":
                    divAdminAdd.classList.add("hide");
                    divAdminRemove.classList.remove("hide");
                    break;
                case "User":
                    divAdminAdd.classList.remove("hide");
                    divAdminRemove.classList.add("hide");
                    break;
            }
        }

        //Hàm thực hiện chức năng thay đổi Status 
        function handleToggleStatusClick(StatusId) {
            var id = $("#lblUserId").text();
            var data = {
                "UserId": id,
                "StatusId": StatusId
            };

            var checkstatus = $("#lblStatus").text();
            var convertstatustoid;
            if (checkstatus == "Actived") {
                convertstatustoid = 1;
            }
            else {
                convertstatustoid = 2;
            }

            if (convertstatustoid != StatusId) {
                $.ajax({
                    type: "POST",
                    "url": "empolyee.aspx/ChangeStatusUser",
                    "data": JSON.stringify(data),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        const CardId = document.querySelectorAll("#btnStatus");
                        var isStatus = document.querySelector("#userIdinfor");
                        var NoActiveClass = "noActive";
                        var ActiveClass = "Active";

                        if (response.d == true) {
                            $("#lblStatus").text("Actived");
                            isStatus.textContent = "Actived";
                            isStatus.classList.add(ActiveClass);
                            isStatus.classList.remove(NoActiveClass);
                            showSuccessToast("Đã kích hoạt tài khoản thành công!");

                            CardId.forEach((usersIdCard) => {
                                const getId = usersIdCard.getAttribute("empolyeecardid");

                                if (getId == id) {
                                    usersIdCard.setAttribute("commandargument", 1);
                                    const statusgetid = usersIdCard.getAttribute("commandargument");
                                    handleStatus(statusgetid, usersIdCard);
                                }
                            });
                        } else {
                            $("#lblStatus").text("Disable");
                            isStatus.textContent = "Disable";
                            isStatus.classList.add(NoActiveClass);
                            isStatus.classList.remove(ActiveClass);
                            showSuccessToast("Đã vô hiệu hoá tài khoản thành công");

                            CardId.forEach((usersIdCard) => {
                                const getId = usersIdCard.getAttribute("empolyeecardid");

                                if (getId == id) {
                                    usersIdCard.setAttribute("commandargument", 2);
                                    const statusgetid = usersIdCard.getAttribute("commandargument");
                                    handleStatus(statusgetid, usersIdCard);
                                }
                            });
                        }
                    },
                    error: function (error) {
                        console.log(error);
                    }
                })
            }
            else {
                if (StatusId == 1) {
                    showInfoToast("Tài khoản hiện đã được kích hoạt");
                }
                else {
                    showInfoToast("Tài khoản hiện đã được vô hiệu hoá");
                }
            }
        }

        // Hàm xử lý trạng thái
        const btnStatus = document.querySelectorAll(".employee-card__header-status");
        function handleStatus(status, button) {
            // Xóa tất cả các class hiện có trên button
            button.classList.remove("Active", "noActive");
            button.textContent = "Not Actived";

            // Thêm class tùy thuộc vào giá trị của trường "Status"
            if (status === "1") {
                button.textContent = "Actived";
                button.classList.add("Active");
                button.classList.remove("noActive");
            } else if (status === "2") {
                button.textContent = "Disable";
                button.classList.add("noActive");
                button.classList.remove("Active");
            }
        }
        btnStatus.forEach((button) => {
            const status = button.getAttribute("commandargument");
            handleStatus(status, button);
        });

        // Hàm định dạng lại ngày thành chuỗi "dd/MM/yyyy"
        function formatDate(dateStr) {
            const date = new Date(dateStr);
            const day = String(date.getDate()).padStart(2, "0");
            const month = String(date.getMonth() + 1).padStart(2, "0");
            const year = date.getFullYear();
            return `${day}/${month}/${year}`;
        }

        //Hàm lấy status và thay đổi
        function getStatusAndChanges(element) {
            var id = element.getAttribute("commandargument");
            var UserId = { "UserId": id };

            var curentId = $("#lblUserId").text();

            if (curentId != id) {

                $.ajax({
                    type: "POST",
                    "url": "empolyee.aspx/GetUserIdByJS",
                    "data": JSON.stringify(UserId),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var empolyeeInfo = JSON.parse(response.d);

                        if (empolyeeInfo != null) {
                            var isStatus = document.querySelector("#userIdinfor");
                            var NoActiveClass = "noActive";
                            var ActiveClass = "Active";
                            var status = empolyeeInfo.Status;

                            $("#lblUserId").text(empolyeeInfo.Id);

                            switch (status) {
                                case 0:
                                    $("#lblStatus").text("Not Actived");
                                    isStatus.textContent = "Not Actived";
                                    isStatus.classList.remove(ActiveClass);
                                    isStatus.classList.remove(NoActiveClass);
                                    break;
                                case 1:
                                    $("#lblStatus").text("Actived");
                                    isStatus.textContent = "Actived";
                                    isStatus.classList.add(ActiveClass);
                                    isStatus.classList.remove(NoActiveClass);
                                    break;
                                case 2:
                                    $("#lblStatus").text("Disable");
                                    isStatus.textContent = "Disable";
                                    isStatus.classList.add(NoActiveClass);
                                    isStatus.classList.remove(ActiveClass);
                                    break;
                            }
                        }
                    },
                    error: function (error) {
                        console.log(error)
                    }
                })
            }


        }

        // Hàm thực hiện chức năng binding dữ liệu
        function getDataforClickShow(element) {
            var id = element.getAttribute("commandargument");
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
                        showModal();

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
                        var NoActiveClass = "noActive";
                        var ActiveClass = "Active";

                        var status = empolyeeInfo.Status;
                        switch (status) {
                            case 0:
                                $("#lblStatus").text("Not Actived");
                                isStatus.textContent = "Not Actived";
                                isStatus.classList.remove(ActiveClass);
                                isStatus.classList.remove(NoActiveClass);
                                break;
                            case 1:
                                $("#lblStatus").text("Actived");
                                isStatus.textContent = "Actived";
                                isStatus.classList.add(ActiveClass);
                                isStatus.classList.remove(NoActiveClass);
                                break;
                            case 2:
                                $("#lblStatus").text("Disable");
                                isStatus.textContent = "Disable";
                                isStatus.classList.add(NoActiveClass);
                                isStatus.classList.remove(ActiveClass);
                                break;
                        }

                        var userType = empolyeeInfo.UserType;
                        switch (userType) {
                            case 0:
                                $("#lblUserType").text("Administrator")
                                break;
                            case 1:
                                $("#lblUserType").text("User")
                                break;
                        }

                        checkUserType();
                    }
                },
                error: function (error) {
                    console.log(error)
                }
            })
        }


    </script>


    <script>
        <%--function handleSearch() {
            __doPostBack('<%= btnSearch.UniqueID %>', '');
        }--%>
    </script>

    <script src="JS/empolyee.js"></script>
    <script src="JS/toast.js"></script>



</asp:Content>
