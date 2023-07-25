<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Empolyee.aspx.cs" Inherits="GUI.Empolyee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div class="content">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
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
                                                <a class="employee-card__body-avatar" runat="server" title="Xem Thông Tin Chi Tiết"
                                                    onserverclick="ShowModalInfor_ServerClick" commandargument="1" onclick="showModal()">
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

        <div class="modal-vertical__container">
            <button type="button" class="modal-vertical__close" onclick="hidenModal(event)">
                <i class="fa-solid fa-xmark"></i>
            </button>

            <h2 class="modal-vertical__container-title">Chi Tiết Thông Tin</h2>

            <div class="userInfor">
                <div class="userInfor-Avatar">
                    <div class="userInfor__image">
                        <asp:Image ID="AvatarImg" runat="server" />
                    </div>
                    <div class="userInfor__desc">
                        <p>
                            <asp:Label ID="lblDisplayName" runat="server" Text="Admin"></asp:Label>
                            <button type="button" class="employee-card__header-status Active">Active</button>
                        </p>
                        <asp:Label ID="lblJob" runat="server" Text="Intern"></asp:Label>
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
                        <asp:Label ID="lblDisplayName1" runat="server" Text="Admin"></asp:Label>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Số Điện Thoại:</p>
                        <asp:Label ID="lblPhoneNumber" runat="server" Text="0123456789"></asp:Label>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Trạng Thái Tài Khoản:</p>
                        <asp:Label ID="lblStatus" runat="server" Text="Active"></asp:Label>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Loại Tài Khoản:</p>
                        <asp:Label ID="lblUserType" runat="server" Text="Admin"></asp:Label>
                    </div>
                </div>
                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Email:</p>
                        <asp:Label ID="lblEmail" runat="server" Text="admin@gmail.com"></asp:Label>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Ngày Tham Gia:</p>
                        <asp:Label ID="lblDateJoin" runat="server" Text="24/07/2023"></asp:Label>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Vị Trí:</p>
                        <asp:Label ID="lblJob1" runat="server" Text="Intern"></asp:Label>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Phòng Ban:</p>
                        <asp:Label ID="lblDepartment" runat="server" Text="Sweetsoft"></asp:Label>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Giới Tính:</p>
                        <asp:Label ID="lblGender" runat="server" Text="Nam"></asp:Label>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Ngày Sinh:</p>
                        <asp:Label ID="lblDateOfBirth" runat="server" Text="04/03/2004"></asp:Label>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Id Tài Khoản:</p>
                        <span>123</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Google Id:</p>
                        <span>123456789</span>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Địa Chỉ:</p>
                        <span>Phước Lâm - Ninh Xuân - Ninh Hoà - Khánh Hoà</span>
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
        function handleSearch() {
            __doPostBack('<%= btnSearch.UniqueID %>', '');
        }
    </script>

    <script src="JS/empolyee.js"></script>



</asp:Content>
