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
            if (!IsPostBack) { return; }
            
            bool validcookie = UserManager.checkValidCookie(Request);

            if (validcookie) { Response.Redirect("login.aspx"); }
            
          
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!IsPostBack) { return; }

            string userName = txtUserName.Text;
            string password = txtPassword.Text;



            String authToken = UserManager.Login(userName, password);

     
           
            HttpCookie authCookie = new HttpCookie("AuthToken", authToken);

            Response.Cookies.Add(authCookie);
        }
    }
}