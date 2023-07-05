using BUS;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
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
                    if (emailExists > 0)
                    {
                        UserManager.InsertUser(user);
                        lblError.Text = string.Empty;
                        string script = "showSuccessToast('Đăng ký tài khoản thành công, hãy đăng nhập ngay!')";
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "myToast", script, true);
                    }
                    else
                    {
                        string script = "showErrorToast('Email đã tồn tại, vui lòng thử lại')";
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "myToast", script, true);
                        lblError.Text = "Email đã tồn tại";
                    }
                }
                else
                {
                    string script = "showWarningToast('Mật khẩu nhập lại không giống nhau, vui lòng kiểm tra lại')";
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "myToast", script, true);
                    lblError.Text = "Mật khẩu không trùng nhau";
                }
            }
            else
            {
                string script = "showWarningToast('Các trường không được để trống!')";
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "myToast", script, true);
                lblError.Text = "Các trường không được trống";
            }
        }
    }
}