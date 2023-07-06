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



            Query qry = new Query("Users");
            string wherecondict = $"UserName = {userName}";
            qry.WHERE(wherecondict);
            UserCollection UserCollect = UC.FetchByQuery(qry);

            Debug.WriteLine(UserCollect.ToList().Count);
            string script = $"alert(\"{UserCollect.Count} {wherecondict}\")";

            ScriptManager.RegisterStartupScript(this, GetType(), "AlertScript", script, true);

        }
    }
}