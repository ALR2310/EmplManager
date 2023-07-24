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
                            <button type="button" onclick="handleSearch()">
                                <i class="fa-solid fa-magnifying-glass"></i>
                                <asp:Button ID="btnSearch" runat="server" Text="" Style="display: none" />
                            </button>
                        </div>
                    </div>

                    <div class="employee-header__content">
                        <p>
                            Đã chọn 
                            <asp:Label ID="lblSelectCount" runat="server" Text="0"></asp:Label>
                        </p>

                        <button type="button" onclick="employeeShowEllipsis(event, 'block')"
                            onmouseleave="employeeShowEllipsis(event, 'none')"
                            class="employee-header__ellipsis">
                            <i class="fa-solid fa-ellipsis-vertical"></i>

                            <ul class="employee-card__ellipsis">
                                <li>
                                    <a id="clearCheckbox" href="#">Bỏ Chọn Tất Cả</a>
                                </li>
                                <li class="subEllipsis-Card">◂Thay Đổi Trạng Thái
                                            <ul class="employee-card__subEllipsis">
                                                <li>
                                                    <a href="#">Kích Hoạt</a>
                                                </li>
                                                <li>
                                                    <a href="#">Vô Hiệu</a>
                                                </li>
                                            </ul>
                                </li>
                                <li>
                                    <a onclick="showModalDeleteUser()">Xoá Tài Khoản</a>
                                </li>

                                <div></div>

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
                                    <button class="employee-card__header-status Active">Active</button>
                                    <button onclick="employeeShowEllipsis(event, 'block')"
                                        onmouseleave="employeeShowEllipsis(event, 'none')"
                                        class="employee-card__header-ellipsis">
                                        <i class="fa-solid fa-ellipsis-vertical"></i>
                                        <ul class="employee-card__ellipsis">
                                            <li>
                                                <a onclick="showModal()" href="#">Chỉnh Sửa Thông Tin
                                                </a>
                                            </li>
                                            <li class="subEllipsis-Card">Thay Đổi Trạng Thái▸
                                                        <ul class="employee-card__subEllipsis">
                                                            <li>
                                                                <a href="#">Kích Hoạt</a>
                                                            </li>
                                                            <li>
                                                                <a href="#">Vô Hiệu</a>
                                                            </li>
                                                        </ul>
                                            </li>
                                            <li>
                                                <a href="#">Xoá Tài Khoản</a>
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

                        <div class="employee-body-card">
                            <div class="employee-card__header">
                                <input type="checkbox" class="employee-card__header-checkbox">
                                <div class="employee-card__header-action">
                                    <button class="employee-card__header-status Active">Active</button>
                                    <button onclick="employeeShowEllipsis(event, 'block')"
                                        onmouseleave="employeeShowEllipsis(event, 'none')"
                                        class="employee-card__header-ellipsis">
                                        <i class="fa-solid fa-ellipsis-vertical"></i>
                                        <ul class="employee-card__ellipsis">
                                            <li>
                                                <a onclick="showModal()" href="#">Chỉnh Sửa Thông Tin
                                                </a>
                                            </li>
                                            <li class="subEllipsis-Card">Thay Đổi Trạng Thái▸
                                                        <ul class="employee-card__subEllipsis">
                                                            <li>
                                                                <a href="#">Kích Hoạt</a>
                                                            </li>
                                                            <li>
                                                                <a href="#">Vô Hiệu</a>
                                                            </li>
                                                        </ul>
                                            </li>
                                            <li>
                                                <a href="#">Xoá Tài Khoản</a>
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

    <script>
        function handleSearch() {
            __doPostBack('<%= btnSearch.UniqueID %>', '');
        }


    </script>

    <script src="JS/employee.js"></script>



</asp:Content>
