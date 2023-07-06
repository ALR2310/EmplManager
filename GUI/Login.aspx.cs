using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using SubSonic;

using DAL;
using System.Diagnostics;

namespace GUI
{
    public partial class Login : System.Web.UI.Page
    {
        UserController UC = new UserController();
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string userName = txtUserName.Text;
            string password = txtPassword.Text;



            List<User> ListUser = UC.Login(userName, password);

            Debug.WriteLine(ListUser.Count);
            string script = $"alert(\"{ListUser.Count} \")";

            ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);
            
        }
    }
}