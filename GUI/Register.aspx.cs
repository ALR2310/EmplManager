using BUS;
using DAL;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GUI
{
    public partial class Register : System.Web.UI.Page
    {
        public static User RegisteringUser;
        private string SweetSoftDomain = "sweetsoft";
        protected void Page_Load(object sender, EventArgs e)
        {

        }



       
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtEmail.Text) || string.IsNullOrEmpty(txtDisplayName.Text) ||
                string.IsNullOrEmpty(txtUserName.Text) || string.IsNullOrEmpty(txtPassword.Text))
            {
                ToastManager.WaringToast("Các trường không được để trống! vui lòng điền đầy đủ");
                lblError.Text = "Các trường không được trống";
                return;
            }
            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                ToastManager.WaringToast("Mật khẩu không trùng nhau, vui lòng thử lại");
                lblError.Text = "Mật khẩu không trùng nhau";
                return;

            }
            if (!txtEmail.Text.ToLower().Contains("@"+ SweetSoftDomain))
            {
                ToastManager.WaringToast("Chỉ có email với tên miền \"SweetSoft\" mới được đăng ký!");
                lblError.Text = "Chỉ có email với tên miền \"SweetSoft\" mới được đăng ký!";
                return;
            }
            int emailExists = UserManager.CheckEmailUser(txtEmail.Text);
            int usernameExists = UserManager.CheckUserName(txtUserName.Text);

            if (emailExists == 0 && usernameExists == 0)
            {
                User user = new User();
                user.Avatar = "Images/Avatar/DefaultAvatar.jpg";
                user.Email = txtEmail.Text;
                user.DisplayName = txtDisplayName.Text;
                user.UserName = txtUserName.Text;
                user.Password = txtPassword.Text;
                user.AtCreate = DateTime.Now;
                user.UserType = 1;
                user.Status = 2;

                RegisteringUser = user;

                lblError.Text = string.Empty;

                Response.Redirect("Authen.aspx");
            }

            if (emailExists != 0)
            {
                ToastManager.WaringToast("Email đã tồn tại, vui lòng thử lại!");
                lblError.Text = "Email đã tồn tại";
            }

            if (usernameExists != 0)
            {
                ToastManager.WaringToast("Tên đăng nhập đã tồn tại, vui lòng thử lại!");
                lblError.Text = "Tên đăng nhập đã tồn tại";
            }
        }

    }


}
