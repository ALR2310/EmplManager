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
            if (IsPostBack) { return; }
            bool validcookie = UserManager.checkValidCookie(Request);
            Debug.WriteLine(validcookie);
            if (validcookie)
            {
                string script = "this.location = \"./message.aspx\";";

                ScriptManager.RegisterStartupScript(this, GetType(), "RedirectScript", script, true);
            }
            
          
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!IsPostBack) { return; }

            string userName = txtUserName.Text;
            string password = txtPassword.Text;



            String authToken = UserManager.Login(userName, password);

     
           
            HttpCookie authCookie = new HttpCookie("AuthToken", authToken);

            Response.Cookies.Add(authCookie);

            if (authToken != "_failed_")
            {
                ToastManager.SuccessToast("Đăng nhập thành công! Chuẩn bị chuyển hướng trong vài giây..");

                string script = "setTimeout(function(){this.location = \"./message.aspx\"},2000)";

                ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);
            }
        }
    }
}