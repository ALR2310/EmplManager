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

namespace GUI
{
    public partial class Authen : System.Web.UI.Page
    {
        private string verifyCode;
        protected void Page_Load(object sender, EventArgs e)
        {
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
            if (tbl_verifyCode.Text.Trim() == verifyCode)
            {
                Console.WriteLine("Mã xác thực chính xác");
                //Luồn đi ban đầu của tui như sau, sau khi đăng ký tài khoản 
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
            verifyCode = GenerateVerifyCode();

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
                .To(lbl_Email.Text.Trim())
                .Subject("Mã Xác Thực")
                .Body($"Mã xác thực của bạn là: " + verifyCode);

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