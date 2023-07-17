<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Authen.aspx.cs" Inherits="GUI.Authen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="Style/main.css" />
    <link rel="stylesheet" href="Style/toast.css" />
    <link rel="stylesheet" href="Style/modal.css" />
    <title>Đăng Ký</title>
</head>
<body>
    <div id="toast"></div>

    <div class="modal hide">
        <span class="overlay"></span>
        <div class="modal-box">

            <div class="content-modal">
                <i class="fa-regular fa-circle-check"></i>
                <h2>Xác Thực Thành Công</h2>
                <h3>Bạn đã xác thực tài khoản thành công, tiến hành đăng nhập ngay!</h3>
            </div>

            <div class="buttonsmodal">
                <button class="btn-modal close-btn">Đóng</button>
            </div>
        </div>
    </div>

    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <div class="container login-page">
                    <div class="login">
                        <div class="login__form">
                            <div class="login-form__title">
                                <p>Xác Thực Tài Khoản</p>
                            </div>

                            <p class="authen_text">
                                Một mã xác thực kích hoạt tài khoản đã được gửi đến Email
                                <asp:Label ID="lbl_Email" runat="server" class="email-hide"></asp:Label>, vui lòng kiểm tra hộp thư.
                            </p>

                            <div class="login-form__field">
                                <asp:TextBox ID="tbl_verifyCode" runat="server" placeholder="Nhập Mã Code Tại Đây"></asp:TextBox>
                            </div>

                            <div class="authen_resend">
                                <button onclick="handleVerifySend()">Gửi lại mã</button>
                                <p id="countdown" class="hide">Gửi lại sau <span class="authen_ticks">60</span>s</p>
                                <asp:Button ID="btnVerifySend" OnClick="btnVerifySend_Click" runat="server" Style="display: none" />
                            </div>

                            <div class="login--field">
                                <asp:Button ID="btnAuthen" runat="server" class="btn" Text="Xác Thực" OnClick="btnAuthen_Click" />
                            </div>

                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>

    <script src="JS/modal.js"></script>
    <script src="JS/toast.js"></script>

    <script>
        function handleVerifySend() {
            __doPostBack('<%= btnVerifySend.UniqueID %>', '');
        }

        function startCountdown() {
            var button = document.querySelector('.authen_resend button');
            var countdown = document.getElementById('countdown');
            var span = countdown.querySelector('.authen_ticks');
            var count = 60;

            button.style.display = 'none';
            countdown.classList.remove('hide');

            var timer = setInterval(function () {
                count--;
                span.textContent = count;

                if (count === 0) {
                    clearInterval(timer);
                    button.style.display = 'block';
                    countdown.classList.add('hide');
                }
            }, 1000);
        }
    </script>

</body>
</html>
