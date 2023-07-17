using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using FluentEmail.Core;
using FluentEmail.Smtp;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BUS;
using DAL;

using System.Diagnostics;
using DAL.Model;

namespace GUI
{
    public partial class Authen : System.Web.UI.Page
    {
        protected User RegisteringUser;

        private string VerifyCode {

            get { return ViewState["VerifyCode"] as string; }
            set { 
                Debug.WriteLine($"New key: {value}");
                ViewState["VerifyCode"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            RegisteringUser = Register.RegisteringUser;
            if (RegisteringUser == null)
            {
                Response.Redirect("Register.aspx");
                return;
            }
            lbl_Email.Text = RegisteringUser.Email;
            Debug.WriteLine(RegisteringUser.Email);
       

            if (!IsPostBack)
            {
                SendVerificationCode();
            }

           

        }

        //Gửi lại mã xác thực
        protected void btnVerifySend_Click(object sender, EventArgs e)
        {
            SendVerificationCode();
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "myjs", "startCountdown()", true);
        }

        //Xác thực tài khoản
        protected void btnAuthen_Click(object sender, EventArgs e)
        {
            Debug.WriteLine($"Verify Code: {VerifyCode}");
            Debug.WriteLine(tbl_verifyCode.Text.Trim());
            if (tbl_verifyCode.Text.Trim() == VerifyCode)
            {

        
                UserManager.InsertUser(RegisteringUser);
                RegisteringUser.Save();

                String authToken = UserManager.Login(RegisteringUser.UserName, RegisteringUser.Password);

                HttpCookie authCookie = new HttpCookie("AuthToken", authToken);
                authCookie.Expires = DateTime.Now.AddDays(7);
                Response.Cookies.Add(authCookie);

                if (authToken == "_failed_")
                {
                    ToastManager.ErrorToast("Đã có lỗi xảy ra trong lúc đăng nhập tài khoản");
                    return;
                }
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "abc", "toggleModal()", true);

                string script = "setTimeout(function(){this.location = \"./message.aspx\"},2000)";
                ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);

                //Luồn đi ban đầu của tui như sau, sau khi đăng ký tài khoản thành công sẽ mở trang này và
                //tiến hành đưa Email đã đăng ký lên lable Email, sau đó gửi mã xác thực về Email, hiện đã gửi mã được.
                //Tiếp theo là sẽ kiểm tra mã xác thực nhập vào, nếu đúng thì tiến hành cập nhật lại Status của tài khoản từ 2 thành 1
                //để kích hoạt tài khoản rồi trả về trang Message.aspx

                //Hiện tui đang gặp chút vấn đề về việc so sánh mã xác thực, nếu có gì còn kém thì ông có thể cải tiếng thêm.
            }
            else
            {
                ToastManager.ErrorToast("Mã xác thực không đúng, vui lòng kiểm tra lại");
            }
        }

        //Tạo đoạn mã xác thực 6 số ngẫu nhiên
        private string GenerateVerifyCode()
        {
            const string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
            Random random = new Random();

            string verificationCode = new string(Enumerable.Repeat(chars, 6)
                .Select(s => s[random.Next(s.Length)]).ToArray());

            return verificationCode;
        }

        //Gửi mã code về Email
        private void SendVerificationCode()
        {

            VerifyCode = GenerateVerifyCode();
            // Khởi tạo cấu hình FluentEmail
            var sender = new SmtpSender(() => new System.Net.Mail.SmtpClient("smtp.gmail.com")
            {
                EnableSsl = true,
                DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network,
                Credentials = new System.Net.NetworkCredential("ansaka147@gmail.com", "bnbzobpxchqtlsty")
            });

            Email.DefaultSender = sender;

            // Xây dựng email
            var email = Email.From("ansaka147@gmail.com")
                .To(RegisteringUser.Email)
                .Subject("Mã Xác Thực")
                .Body($"Mã xác thực của bạn là: " + VerifyCode);

            // Gửi email
            var response = email.Send();

            // Kiểm tra kết quả
            if (response.Successful)
            {
                ToastManager.SuccessToast("Gửi mã xác thực về Email thành công");
            }
            else
            {
                ToastManager.ErrorToast("Gửi mã xác thực thất bại, vui lòng liên hệ Admin đễ được hỗ trợ");
            }
        }
    }
}