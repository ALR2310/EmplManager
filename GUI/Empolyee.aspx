<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Empolyee.aspx.cs" Inherits="GUI.Empolyee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
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
                                    <input type="search" placeholder="Tên Nhân Viên">
                                    <button type="button">
                                        <i class="fa-solid fa-magnifying-glass"></i>
                                        <asp:Button runat="server" ID="btnSearch" Style="display: none;" />
                                    </button>
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

                                        <div class="employee-body-card">
                                            <div class="employee-card__header">
                                                <input type="checkbox" class="employee-card__header-checkbox">
                                                <div class="employee-card__header-action">
                                                    <button type="button" class="employee-card__header-status Active">
                                                        Active
                                                    </button>
                                                    <button type="button" onclick="employeeShowEllipsis(event, 'block')"
                                                        onmouseleave="employeeShowEllipsis(event, 'none')"
                                                        class="employee-card__header-ellipsis">
                                                        <i class="fa-solid fa-ellipsis-vertical"></i>
                                                        <ul class="employee-card__ellipsis">
                                                            <li onclick="showModal()">Xem Thông Tin
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
                                            <div class="employee-card__body">
                                                <a class="employee-card__body-avatar" title="Xem Thông Tin Chi Tiết"
                                                    commandargument='<%# Eval("Id") %>' onclick="getIdforEmpolyee(this)">
                                                    <img alt="" src="<%# Eval("Avatar") %>" />
                                                </a>

                                                <div class="employee-card__body-name" onclick="showModal()">
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
                                                            <p><%# Eval("AtCreate") %></p>
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

        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>

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
                                    <button type="button" class="employee-card__header-status Active">Active</button>
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
                                <span id="IdUser">Not Infor</span>
                            </div>

                            <div class="userInfor-Detail__infor">
                                <p>Google Id:</p>
                                <span id="GoogleId">Not Infor</span>
                            </div>
                        </div>

                        <div class="userInfor-Detail1">
                            <div class="userInfor-Detail__infor">
                                <p>Địa Chỉ:</p>
                                <span id="Address">Not Infor</span>
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
                                <asp:Button ID="btnEmoloyeeEnable" runat="server" class="btnEnable" Text="Enable" />
                                <asp:Button ID="btnEmoloyeeDisable" runat="server" class="btnDisable" Text="Disable" />
                            </div>
                        </div>

                        <div class="userInfor-Detail1">
                            <div class="UIDetail__action">
                                <p>Cấp Quyền Admin:</p>
                            </div>
                            <div class="UIDetail__action">
                                <asp:Button ID="btnGetAdmin" runat="server" class="btnUserType" Text="Cấp Quyền Ngay" />
                            </div>
                        </div>

                        <div class="userInfor-Detail1 hide">
                            <div class="UIDetail__action">
                                <p>Loại Bỏ Quyền Admin:</p>
                            </div>
                            <div class="UIDetail__action">
                                <asp:Button ID="btnRemoveAdmin" runat="server" class="btnUserType" Text="Loại Bỏ Ngay" />
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

            </ContentTemplate>
        </asp:UpdatePanel>


    </div>

    <div class="UIdetail-modal-delete-overlay hide">
        <div class="UIdetail-modal-delete ">
            <h3>Bạn có chắc muốn xoá tài khoản này không?</h3>
            <p>Tài khoản sẽ bị xoá vĩnh viễn và không thể khôi phục lại được.</p>
            <div>
                <asp:Button ID="btnEmployeeDelete" runat="server" Text="Xoá Ngay" />
                <button onclick="hideModalDeleteUser()">Huỷ Bỏ</button>
            </div>
        </div>
    </div>

    <script>

        function getIdforEmpolyee(element) {
            var id = element.getAttribute("commandargument");
            var UserId = { "UserId": id };
            console.log(id)
            $.ajax({
                type: "POST",
                "url": "empolyee.aspx/GetUserIdByJS",
                "data": JSON.stringify(UserId),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("Gửi Id đến CodeBehind thành công" + response);
                    // Cập nhật dữ liệu từ response vào các control trong div "employeeInfoContainer"
                    var empolyeeInfo = JSON.parse(response.d); // Parse JSON data from the response
                    console.log(empolyeeInfo);
                    if (empolyeeInfo != null) {
                        $("#AvatarImg").attr("src", empolyeeInfo.Avatar);
                        $("#lblDisplayName").text(empolyeeInfo.DisplayName);
                        $("#lblDisplayName1").text(empolyeeInfo.DisplayName);
                        $("#lblJob").text(empolyeeInfo.Job);
                        $("#lblJob1").text(empolyeeInfo.Job);
                        /*$("#lblPhoneNumber").text(empolyeeInfor.PhoneNumber);*/
                        $("#lblDepartment").text(empolyeeInfo.Department);
                        $("#lblEmail").text(empolyeeInfo.Email);
                        $("#lblDateOfBirth").text(empolyeeInfo.DateOfBirth);
                        console.log("Đã binding dữ liệu");
                    }
                },
                error: function (error) {
                    console.log(error)
                }
            })
        }


    </script>


    <script>
        function handleSearch() {
            __doPostBack('<%= btnSearch.UniqueID %>', '');
        }
    </script>

    <script src="JS/empolyee.js"></script>



</asp:Content>
