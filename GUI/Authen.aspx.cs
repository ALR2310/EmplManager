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

namespace GUI
{
    public partial class Authen : System.Web.UI.Page
    {
        private string verifyCode;
        public static User UserFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserFromCookie = MyLayout.UserFromCookie;
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
                User user = new User();
                user.Id = UserFromCookie.Id;
                user.Status = 1;
                UserManager.UpdateUser(user);

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