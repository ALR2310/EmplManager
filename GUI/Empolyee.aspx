<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Empolyee.aspx.cs" Inherits="GUI.Empolyee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="content">

        <div class="employee-management">
            <div class="employee">
                <div class="employee-header">
                    <div class="employee-header__content">
                        <p class="employee-header-title">
                            <span>0</span> Thành Viên
                        </p>

                        <div class="employee-header-filter">
                            <select name="" id="">
                                <option value="">Tất Cả Nhân Viên</option>
                                <option value="">Đã Kích Hoạt</option>
                                <option value="">Chưa Kích Hoạt</option>
                                <option value="">Vô Hiệu</option>
                            </select>
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

                        <div class="employee-body-card">
                            <div class="employee-card__header">
                                <input type="checkbox" class="employee-card__header-checkbox">
                                <div class="employee-card__header-action">
                                    <button type="button"
                                        class="employee-card__header-status Active">
                                        Active</button>
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
                                <div class="employee-card__body-avatar">
                                    <img src="/images/avatar-1.jpg" alt="">
                                </div>
                                <div class="employee-card__body-name">
                                    <h4>Lê Thanh An</h4>
                                    <p>Thực Tập Sinh</p>
                                </div>
                                <div class="employee-card-desc">
                                    <div class="employee-card-desc__header">
                                        <div class="employee-card-desc-infor">
                                            <h5>Phòng Ban</h5>
                                            <p>SweeftSoft</p>
                                        </div>

                                        <div class="employee-card-desc-infor">
                                            <h5>Ngày Tham Gia</h5>
                                            <p>17/7/2023</p>
                                        </div>
                                    </div>
                                    <div class="employee-card-desc__body">
                                        <p>
                                            <i class="fa-solid fa-envelope"></i>
                                            lethanhan@gmail.com
                                        </p>

                                        <p>
                                            <i class="fa-solid fa-phone"></i>
                                            0523926718
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </div>

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
                        <img src="/images/avatar-1.jpg" alt="">
                    </div>
                    <div class="userInfor__desc">
                        <p>
                            Lê Thanh An
                                    <button type="button" class="employee-card__header-status Active">Active</button>
                        </p>
                        <span>Thực Tập Sinh</span>
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
                        <span>Lê Thanh An</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Số Điện Thoại:</p>
                        <span>0523926718</span>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Trạng Thái Tài Khoản:</p>
                        <span>Active</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Loại Tài Khoản:</p>
                        <span>Người Dùng</span>
                    </div>
                </div>
                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Email:</p>
                        <span>lethanhan342004@gmail.com</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Ngày Tham Gia:</p>
                        <span>20/07/2023</span>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Vị Trí:</p>
                        <span>Thực Tập Sinh</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Phòng Ban:</p>
                        <span>SweetSoft</span>
                    </div>
                </div>

                <div class="userInfor-Detail1">
                    <div class="userInfor-Detail__infor">
                        <p>Giới Tính:</p>
                        <span>Nam</span>
                    </div>

                    <div class="userInfor-Detail__infor">
                        <p>Ngày Sinh:</p>
                        <span>20/07/2023</span>
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

    <script src="JS/employee.js"></script>



</asp:Content>
