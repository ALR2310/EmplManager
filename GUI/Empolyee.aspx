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
                                        AutoCompleteType="DisplayName" placeholder="Tên Nhân Viên"></asp:TextBox>
                                    <a runat="server" onserverclick="btnSearch_ServerClick" title="Tìm kiếm theo tên nhân viên, công việc và số Id">
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

                                        <div class="employee-body-card" commandargument='<%# Eval("Id") %>' usrtype='<%# Eval("UserType") %>' isdrop='<%# Eval("Status") %>'>
                                            <div class="employee-card__header" commandargument='<%# Eval("Id") %>' onmouseenter="getStatusAndChanges(this)">
                                                <input type="checkbox" class="employee-card__header-checkbox">
                                                <div class="employee-card__header-action">
                                                    <button id="btnStatus" type="button" class="employee-card__header-status  "
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
                        <p>Quyền Tài Khoản:</p>
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
                        <button type="button" class="btnEnable" onclick="handleToggleStatusClick(1)">Kích Hoạt</button>
                        <button type="button" class="btnDisable" onclick="handleToggleStatusClick(2)">Vô Hiệu</button>
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
        function handleFilterEmpolyee() {
            const drpElement = document.getElementById('drplist_filterEmpolyee');

            if (drpElement.value == 0) {
                clearfilterEmpolyee();
            } else if (drpElement.value == 1) {
                filterEmpolyee(1);
            } else if (drpElement.value == 2) {
                filterEmpolyee(0);
            } else if (drpElement.value == 3) {
                filterEmpolyee(2);
            } else if (drpElement.value == 4) {
                filterEmpolyeeForUserType(0)
            }
        }
        function filterEmpolyeeForUserType(usertype) {
            var UserCard = document.querySelectorAll(".employee-body-card");
            UserCard.forEach((UserCardId) => {
                const id = UserCardId.getAttribute("commandargument");
                const userTypeId = UserCardId.getAttribute("usrtype");
                if (userTypeId != usertype) {
                    UserCardId.classList.add('hide');
                } else {
                    if (id <= 9999) { UserCardId.classList.remove('hide'); };
                }
            });
        }

        function filterEmpolyee(status) {
            var UserCard = document.querySelectorAll(".employee-body-card");
            UserCard.forEach((UserCardId) => {
                const id = UserCardId.getAttribute("commandargument");
                const statusId = UserCardId.getAttribute("isdrop");
                if (statusId != status) {
                    UserCardId.classList.add('hide');
                } else {
                    if (id <= 9999) { UserCardId.classList.remove('hide'); };
                }
            });
        }

        function clearfilterEmpolyee() {
            var UserCard = document.querySelectorAll(".employee-body-card");
            UserCard.forEach((UserCardId) => {
                const id = UserCardId.getAttribute("commandargument");
                var statusId = UserCardId.getAttribute("isdrop");
                if (id <= 9999) { UserCardId.classList.remove('hide'); };
            });
        }
    </script>

    <script src="JS/empolyee.js"></script>
    <script src="JS/toast.js"></script>



</asp:Content>
