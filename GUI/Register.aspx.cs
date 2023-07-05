using BUS;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GUI
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        void Toast(string scriptMessage)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "myToast", scriptMessage, true);
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtEmail.Text) && !string.IsNullOrEmpty(txtDisplayName.Text) &&
                !string.IsNullOrEmpty(txtUserName.Text) && !string.IsNullOrEmpty(txtPassword.Text))
            {
                if (txtPassword.Text == txtConfirmPassword.Text)
                {
                    User user = new User();
                    user.Avatar = "Images/Avatar/DefaultAvatar.jpg";
                    user.Email = txtEmail.Text;
                    user.DisplayName = txtDisplayName.Text;
                    user.UserName = txtUserName.Text;
                    user.Password = txtPassword.Text;
                    user.AtCreate = DateTime.Now;
                    user.UserType = 1;
                    user.Status = 1;

                    int emailExists = UserManager.CheckEmailUser(user.Email);
                    int usernameExists = UserManager.CheckUserName(user.UserName);

                    if (emailExists == 0 && usernameExists == 0)
                    {
                        UserManager.InsertUser(user);
                        lblError.Text = string.Empty;
                        Toast("showSuccessToast('Đăng ký tài khoản thành công, đăng nhập ngay!')");
                    }

                    if (emailExists != 0)
                    {
                        Toast("showWarningToast('Email đã tồn tại, vui lòng thử lại!')");
                        lblError.Text = "Email đã tồn tại";
                    }

                    if (usernameExists != 0)
                    {
                        Toast("showWarningToast('Tên đăng nhập đã tồn tại, vui lòng thử lại!')");
                        lblError.Text = "Tên đăng nhập đã tồn tại";
                    }
                }
                else
                {
                    Toast("showWarningToast('Mật khẩu không trùng nhau, vui lòng thử lại')");
                    lblError.Text = "Mật khẩu không trùng nhau";
                }
            }
            else
            {
                Toast("showWarningToast('Các trường không được để trống! vui lòng điền đầy đủ')");
                lblError.Text = "Các trường không được trống";
            }
        }
    }
}