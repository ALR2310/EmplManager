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



                        String authToken = UserManager.Login(txtUserName.Text, txtPassword.Text);
                        HttpCookie authCookie = new HttpCookie("AuthToken", authToken);

                        Response.Cookies.Add(authCookie);

                        string script = "toggleModal()";
                        ScriptManager.RegisterClientScriptBlock(this, GetType(), "mymodal", script, true);

                        //script = "setTimeout(function(){this.location = \"./message.aspx\"},5000)";
                        //ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);
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
                else
                {
                    ToastManager.WaringToast("Mật khẩu không trùng nhau, vui lòng thử lại");
                    lblError.Text = "Mật khẩu không trùng nhau";
                }
            }
            else
            {
                ToastManager.WaringToast("Các trường không được để trống! vui lòng điền đầy đủ");
                lblError.Text = "Các trường không được trống";
            }
        }
    }
}