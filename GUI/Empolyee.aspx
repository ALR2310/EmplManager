<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Empolyee.aspx.cs" Inherits="GUI.Empolyee" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/toast.css" />
    <link rel="stylesheet" href="Style/modal-email.css" />
    <link rel="stylesheet" href="Style/empolyee.css" />
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.0/balloon/ckeditor.js"></script>
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>

    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>



    <div class="content">

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Label ID="lblCurrentId" runat="server" Style="display: none"></asp:Label>
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
                                        AutoCompleteType="DisplayName" placeholder="Tìm Kiếm" title="Tìm kiếm theo tên nhân viên, công việc và số Id">
                                    </asp:TextBox>
                                    <a runat="server" onserverclick="btnSearch_ServerClick">
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
                                        <li id="clearCheckbox" onclick="clearCheckboxes()">Bỏ Chọn Tất Cả</li>
                                        <li class="subEllipsis-Card">◂Thay Đổi Trạng Thái
                                            <ul class="employee-card__subEllipsis">
                                                <li onclick="handleChangeStatusForCheckboxes(1)">Kích Hoạt</li>
                                                <li onclick="handleChangeStatusForCheckboxes(2)">Vô Hiệu</li>
                                            </ul>
                                        </li>
                                        <li onclick="activeEmailModal()">Gửi Email</li>
                                        <li onclick="showModalDeleteUser()" onmouseenter="handleDelMoreUsr()">Xoá Tài Khoản</li>


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
                                                            <li onclick="showModalDeleteUser()" onmouseenter="handlehideModalDelete()">Xoá Tài Khoản
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
                    <button type="button" onclick="activeEmailModal()" onmouseenter="getEmailCurrentUserInfor()">
                        <i class="fa-regular fa-envelope"></i>
                        Gửi Email
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
                        <button type="button" onclick="showModalDeleteUser()" onmouseenter="handlehideModalDelete()" class="btnDelete">Xoá Tài Khoản Này</button>
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
                <button id="btndelapply" type="button">Xoá Ngay</button>
                <button id="btndelcancel" type="button" onclick="hideModalDeleteUser()">Huỷ Bỏ</button>
            </div>
        </div>
    </div>

    <div class="usrdetail-modal-email hide">
        <button id="btnMdEmailshw" type="button" onclick="showEmailModal(this)">
            <i class="fa-solid fa-chevrons-left fa-rotate-180"></i>
        </button>

        <button id="btnMdEmailcls" class="hide" type="button" onclick="closeEmailModal(this)">
            <i class="fa-solid fa-chevrons-left"></i>
        </button>

        <h2>Soạn Thư</h2>

        <div class="usrdetail-modal-email-Content">
            <div class="email-Content-action">
                <select id="email_action">
                    <option value="To">Đến</option>
                    <option value="CC">CC</option>
                    <option value="BCC">BCC</option>
                </select>
                <input id="tblEmail_recipients" placeholder="Người Nhận" />
            </div>
            <input id="tblEmail_subject" placeholder="Tiêu Đề" />

            <div id="tblEmail_content" placeholder="Nội Dung" class="modal-email-Content-ckeditor"></div>

            <div class="modal-email-Content-action">
                <button type="button" onclick="disableEmailModal()">Huỷ Bỏ</button>
                <button type="button" onclick="SendEmail()">Gửi Ngay</button>
            </div>
        </div>
    </div>

    <div class="ModalCheckUser hide">
        <div class="ModalCheckUser_content">
            <div class="ModalCheckUser_content_image">
                <img src="Images/images1.png" />
            </div>

            <h3>Xin Lỗi, Bạn Không Có Quyền Truy Cập Trang Này</h3>
            <p>Tài khoản bạn không có quyền truy cập trang này, để truy cập trang này vui lòng liên hệ với Administrator</p>
            <button type="button" onclick="goBack()">Quay Lại Trang Trước</button>
        </div>
    </div>


    <style>
        
    </style>

    <script>




</script>

    <script src="JS/empolyee.js"></script>
    <script src="JS/toast.js"></script>



</asp:Content>
