<%@ Page Title="" Language="C#" MasterPageFile="~/MyLayout.Master" AutoEventWireup="true" CodeBehind="Notify.aspx.cs" Inherits="GUI.Notify" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Style/notify.css" />
    <link rel="stylesheet" href="Style/toast.css" />
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/decoupled-document/ckeditor.js"></script>

</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div id="toast"></div>

    <div class="content">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:Label ID="lblCurentId" runat="server" Style="display: none"></asp:Label>

        <div class="notify">
            <div class="notify-sidebar">
                <div class="notify-sidebar-header">
                    <a>
                        <i class="fa-regular fa-inbox"></i>
                        Hộp Thư
                        <span>1</span>
                    </a>
                </div>

                <div class="notify-sidebar-body">
                    <div class="notify-sidebar-body-list">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>

                                <asp:Repeater ID="Repeater1" runat="server">
                                    <ItemTemplate>

                                        <a href="#" class="notify-sidebar-body-item">
                                            <div class="notify-sidebar-body-avatar">
                                                <img src="<%#Eval("Avatar") %>" />
                                            </div>

                                            <div class="notify-sidebar-body-content">
                                                <div class="nsb-content-title">
                                                    <p><%# Eval("DisplayName") %></p>
                                                    <span><%#Eval("AtCreate") %></span>
                                                </div>
                                                <div class="nsb-content-desc isRead">
                                                    <%#Eval("Content") %>
                                                </div>
                                            </div>
                                        </a>

                                    </ItemTemplate>
                                </asp:Repeater>

                            </ContentTemplate>
                        </asp:UpdatePanel>

                    </div>
                </div>

                <button class="notify-action" type="button" onclick="toggleNotifyModal('show')">
                    <i class="fa-solid fa-pen-to-square"></i>
                    Gửi Thông Báo Mới!
                </button>

            </div>

            <div class="notify-content">
                <div class="notify-content-header">
                    <h2>Thư từ <span>Admin</span></h2>
                </div>
                <div class="notify-content-body">
                    <div class="notify-content-userInfor">
                        <div class="notify-sidebar-body-avatar">
                            <img src="Images/Avatar/defaultAvatar.jpg" />
                        </div>

                        <div class="notify-sidebar-body-content">
                            <div class="nsb-content-title">
                                <p>Admin</p>
                                <span>1 ngày trước</span>
                            </div>
                            <div class="nsb-content-desc">
                                admin@gmail.com
                            </div>
                        </div>
                    </div>

                    <div class="notify-content-desc">
                        <p>
                            Hôm nay chủ nhật nên mình public test web phim cho tất cả member luôn. 
                            Để test xem độ chịu tải xem như thế nào, có sập hay không nhé. 
                            Nếu sập thì các bạn báo giúp mình. Follow fanpage trên web và để lại 
                            comment ở link phim cho có data các bạn nhé. Giới thiệu cho nhiều bạn 
                            bè cùng biết và vào đánh giá chất lượng nhé các mem.
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div class="notify-modal hide" onclick="closeParentNotifyModal(event)">
            <div class="notify-modal-content">
                <div id="toolbar-container"></div>
                <div id="ckeditor"></div>

                <div class="notify-modal-button">
                    <button onclick="toggleNotifyModal('hide')" type="button">Huỷ bỏ</button>
                    <button type="button" onclick="handleInsertNotify()">Gửi ngay</button>
                </div>
            </div>
        </div>

    </div>




    <script>
        function handleInsertNotify() {
            data = {
                UserId: $("#ContentPlaceHolder1_lblCurentId").text(),
                Content: $("#ckeditor").html()
            }

            console.log(data);
            $.ajax({
                type: "POST",
                "url": "Notify.aspx/InsertNotify",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == true) {
                        showSuccessToast("Bạn đã gửi thông báo thành công");
                    }

                },
                error: function (err) {
                    console.log(err)
                }
            });
        }



        function closeParentNotifyModal(event) {
            var notifyModal = document.querySelector(".notify-modal");
            if (event.target === notifyModal) {
                toggleNotifyModal("hide");
            }
        }
        function toggleNotifyModal(action) {
            if (action == "show") {
                document.querySelector(".notify-modal").classList.remove("hide");
                setTimeout(function () {
                    document.querySelector(".notify-modal-content").style.transform = "translateY(0%)";
                }, 1);
            } else if (action == "hide") {
                document.querySelector(".notify-modal-content").style.transform = "translateY(150%)";
                setTimeout(function () {
                    document.querySelector(".notify-modal").classList.add("hide");
                }, 500)
            }
        }








        DecoupledEditor
            .create(document.querySelector('#ckeditor'))
            .then(editor => {
                const toolbarContainer = document.querySelector('#toolbar-container');

                toolbarContainer.appendChild(editor.ui.view.toolbar.element);
            })
            .catch(error => {
                console.error(error);
            });
    </script>

    <script src="JS/toast.js"></script>
</asp:Content>
