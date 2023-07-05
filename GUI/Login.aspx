<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="GUI.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link rel="stylesheet" href="Style/main.css" />
    <link rel="stylesheet" href="Style/toast.css" />
    <title>Đăng Nhập</title>
</head>
<body>
    <div id="toast"></div>
    <form id="form1" runat="server">
        <div class="container login-page">
            <div class="login">
                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="login__form">
                            <div class="login-form__title">
                                <p>Đăng Nhập</p>
                            </div>

                            <div class="login-form__field">
                                <a class="login-form__with-google" href="#">
                                    <img src="/images/google-logo.png" alt="" />
                                    Đăng Nhập Bằng Google
                                </a>
                            </div>

                            <div class="liner">
                                <hr class="liner__line" />
                                <div class="liner__text">Hoặc</div>
                            </div>

                            <div class="login-form__field">
                                <i class="fa-solid fa-envelope"></i>
                                <asp:TextBox ID="txtUserName" placeholder="Email Hoặc Tên Tài Khoản" runat="server"></asp:TextBox>
                            </div>

                            <div class="login-form__field">
                                <i class="fa-sharp fa-solid fa-key"></i>
                                <asp:TextBox ID="txtPassword" TextMode="Password" placeholder="Mật Khẩu" runat="server"></asp:TextBox>
                            </div>

                            <div class="login-form__field error-field">
                                <asp:Label ID="lblError" runat="server" class="text-error"></asp:Label>
                            </div>

                            <div class="login--field">
                                <asp:Button ID="btnLogin" runat="server" Text="Đăng Nhập " class="btn" OnClick="btnLogin_Click" />
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
    <script src="JS/toast.js"></script>
</body>
</html>
