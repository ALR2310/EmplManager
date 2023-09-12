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
                        <%--<span>1</span>--%>
                        <asp:Label ID="lblCountNotifyBox" runat="server"></asp:Label>
                    </a>
                </div>

                <div class="notify-sidebar-body">
                    <div class="notify-sidebar-body-list">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>

                                <asp:Repeater ID="Repeater1" runat="server">
                                    <ItemTemplate>

                                        <a onclick="handleGetDataNotify(this)" notifyid="<%#Eval("Id") %>" class="notify-sidebar-body-item <%--isRead--%>">
                                            <div class="notify-sidebar-body-avatar">
                                                <img src="<%#Eval("Avatar") %>" />
                                            </div>

                                            <div class="notify-sidebar-body-content">
                                                <div class="nsb-content-title">
                                                    <p><%# Eval("DisplayName") %></p>
                                                    <span><%# FormatDate(Eval("AtCreate")) %></span>
                                                </div>
                                                <div id="lblTextContent" class="nsb-content-desc">
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
                    <h2>Thư từ <span></span></h2>
                </div>
                <div class="notify-content-body">
                    <div class="notify-content-userInfor">
                        <div class="notify-sidebar-body-avatar">
                            <img id="userAvt" src="Images/Avatar/defaultAvatar.jpg" />
                        </div>

                        <div class="notify-sidebar-body-content">
                            <div class="nsb-content-title">
                                <p id="userName"></p>
                                <span id="userTimeSend"></span>
                            </div>
                            <div id="userEmail" class="nsb-content-desc"></div>
                        </div>
                    </div>

                    <div class="notify-content-desc">
                        <p></p>
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
        //-------xem và đánh dấu vào thông báo được mở từ layout
        function viewCheckNotifyFromL() {
            var notifyId = getNotifyIdFromURL();
            var currentId = $("#ContentPlaceHolder1_lblCurentId").text();

            data = {
                "UserId": currentId,
                "NotifyId": notifyId
            }
            if (notifyId != null) {
                $.ajax({
                    type: "POST",
                    "url": "Notify.aspx/InsertUserIsRead",
                    "data": JSON.stringify(data),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d == true) {
                            console.log('The notification has not been viewed yet, but has been marked');
                            const notifyItems = document.querySelectorAll(".notify-sidebar-body-item");
                            notifyItems.forEach((notify) => {
                                var notifyCurrentId = notify.getAttribute("notifyid");

                                if (notifyCurrentId == notifyId) {
                                    notify.classList.add("isRead");
                                }
                            });
                        } else {
                            console.log('The notification has been viewed on the current user');
                        }
                    },
                    error: function (err) {
                        console.log(err);
                    }
                });
            }
        }
        viewCheckNotifyFromL();



        //---------Lấy tham số Id từ đường dẫn
        function getNotifyIdFromURL() {
            var urlParams = new URLSearchParams(window.location.search);
            var notifyId = urlParams.get("id");
            return notifyId;
        }




        //---------Loại bỏ các hình ảnh khỏi phần xem trước thông báo
        function sanitizeContent() {
            var lblTextContents = document.querySelectorAll(".nsb-content-desc");

            lblTextContents.forEach(function (lblTextContent) {
                var childNodes = lblTextContent.childNodes;

                for (var i = 0; i < childNodes.length; i++) {
                    var node = childNodes[i];
                    if (node.nodeType === Node.ELEMENT_NODE) {
                        if (node.tagName.toUpperCase() === "IMG" || node.tagName.toUpperCase() === "TABLE") {
                            lblTextContent.removeChild(node);
                        }
                    }
                }
            });
        }

        //---------Sử dụng hàm
        sanitizeContent();

        //-------xoá div thừa khi có hình ảnh được chèn trong nội dung
        function fixContent() {
            var lblContent = document.querySelector(".notify-content-desc figure");
            if (lblContent) {
                var divElement = lblContent.querySelector("div");
                if (divElement) {
                    lblContent.removeChild(divElement);
                }
            }
        }


        //-------giới hạn văn bản hiển thị
        function limitText(element, limit) {
            var text = element.innerText;
            if (text.length > limit) {
                element.innerText = text.slice(0, limit) + '...';
            }
        }
        var truncatedText = document.querySelectorAll("#lblTextContent");
        truncatedText.forEach((trncatedtexts) => {
            limitText(trncatedtexts, 25);
        });



        //---------Kiểm tra xem người dùng đã đọc tin nhắn hay chưa
        function checkIsRead() {
            var notifyItem = document.querySelectorAll(".notify-sidebar-body-item");

            data = {
                "UserId": $("#ContentPlaceHolder1_lblCurentId").text()
            }

            $.ajax({
                type: "POST",
                "url": "Notify.aspx/GetUserNotify",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var userNotify = JSON.parse(response.d);
                    console.log(userNotify);

                    // Lọc ra danh sách các NotifyId có IsRead=true
                    const readNotifyIds = userNotify.filter(obj => obj.IsRead === true).map(obj => obj.NotifyId);

                    notifyItem.forEach((notify) => {
                        var notifyId = notify.getAttribute('notifyid');

                        if (readNotifyIds.includes(parseInt(notifyId))) {
                            notify.classList.add('isRead');
                        }
                    });
                },
                error: function (err) {
                    console.log(err);
                }
            });
        }
        checkIsRead();



        //-------Đánh dấu là đã xem khi chọn vào thông báo
        function InsertUserIsRead(element) {
            data = {
                "UserId": $("#ContentPlaceHolder1_lblCurentId").text(),
                "NotifyId": element.getAttribute("notifyid")
            }

            $.ajax({
                type: "POST",
                "url": "Notify.aspx/InsertUserIsRead",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == true) {
                        console.log('result is true proceed with marking');
                        element.classList.add("isRead");
                    } else {
                        console.log('result is false has been marked');
                    }
                },
                error: function (err) {
                    console.log(err);
                }
            });
        }


        //-------Lấy dữ liệu từ server và đưa lên giao diện
        function handleGetDataNotify(element) {
            var idnotify;
            if (element != null) {
                idnotify = element.getAttribute("notifyid")

                InsertUserIsRead(element);
            } else {
                idnotify = 0;
            }

            data = {
                "NotifyId": idnotify
            }

            $.ajax({
                type: "POST",
                "url": "Notify.aspx/GetDataNotify",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var NotifyData = JSON.parse(response.d);

                    if (NotifyData != null) {
                        var userSend = $(".notify-content-header h2 span");
                        var userInfor_name = $("#userName");
                        var userInfor_email = $("#userEmail");
                        var userInfor_timesend = $("#userTimeSend");
                        var userInfor_avatar = $("#userAvt");
                        var content = $(".notify-content-desc");

                        userSend.text(NotifyData.DisplayName);
                        userInfor_name.text(NotifyData.DisplayName);
                        userInfor_email.text(NotifyData.Email);
                        userInfor_avatar.attr("src", NotifyData.Avatar);
                        content.html(NotifyData.Content);
                        userInfor_timesend.text("Ngày " + formatDate(NotifyData.AtCreate));

                        fixContent();
                    }
                },
                error: function (err) {
                    console.log(err);
                }
            });
        }
        handleGetDataNotify();


        //-----định dạng lại ngày/tháng/năm
        function formatDate(dateStr) {
            const date = new Date(dateStr);
            const day = String(date.getDate()).padStart(2, "0");
            const month = String(date.getMonth() + 1).padStart(2, "0");
            const year = date.getFullYear();
            return `${day}/${month}/${year}`;
        }




        //------Thêm bảng ghi thông báo mới
        function handleInsertNotify() {
            var content = $("#ckeditor").html();
            data = {
                UserId: $("#ContentPlaceHolder1_lblCurentId").text(),
                Content: content
            }

            if (content === '<p><br data-cke-filler="true"></p>') {
                showWarningToast("Vui lòng nhập nội dung thông báo!")
                return;
            }

            $.ajax({
                type: "POST",
                "url": "Notify.aspx/InsertNotify",
                "data": JSON.stringify(data),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d == true) {
                        showSuccessToast("Bạn đã gửi thông báo thành công");
                        toggleNotifyModal('hide');
                    }
                },
                error: function (err) {
                    console.log(err)
                }
            });
        }


        //-----Đóng mở modal gửi thông báo
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
