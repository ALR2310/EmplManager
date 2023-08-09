using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;

using BUS;
using System.Diagnostics;

namespace GUI
{
    public partial class Login : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int? validcookie = UserManager.checkValidCookie(Request);
                Debug.WriteLine(validcookie);
                if (validcookie != null)
                {
                    string script = "this.location = \"./tin-nhan\";";

                    ScriptManager.RegisterStartupScript(this, GetType(), "RedirectScript", script, true);
                }
            }

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (IsPostBack)
            {

                string userName = txtUserName.Text;
                string password = txtPassword.Text;

                String authToken = UserManager.Login(userName, password);

                HttpCookie authCookie = new HttpCookie("AuthToken", authToken);
                authCookie.Expires = DateTime.Now.AddDays(7);
                Response.Cookies.Add(authCookie);

                if (authToken != "_failed_")
                {
                    string script = "toggleModal()";
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "my", script, true);

                    script = "setTimeout(function(){this.location = \"./message.aspx\"},1500)";
                    ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);
                    return;
                }
                ToastManager.ErrorToast("Đăng nhập không thành công.. Sai Mật Khẩu hoặc Tên Đăng Nhập / Email");

            }
        }
    }
}