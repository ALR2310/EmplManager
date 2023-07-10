using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BUS;
using DAL;
namespace GUI
{
    public partial class MyLayout : System.Web.UI.MasterPage
    {
        public static User UserFromCookie;

        private void AssignInfos()
        {
            lblUserName.Text = UserFromCookie.DisplayName;
        }
        protected void Page_Init(object sender, EventArgs e)
        {

            bool validcookie = UserManager.checkValidCookie(Request);

            if (!validcookie) { Response.Redirect("login.aspx"); return; }

            UserFromCookie = UserManager.getTokenUser(Request.Cookies["AuthToken"].Value);

            AssignInfos();
            // Your code logic here
        }

        protected void linkLogout_ServerClick(object sender, EventArgs e)
        {
            Logout();
        }

        protected void A1_ServerClick(object sender, EventArgs e)
        {
            Logout();
        }

        public void Logout()
        {
            HttpCookie cookie = Request.Cookies["AuthToken"];
            if (cookie != null)
            {
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }
            Response.Redirect("Login.aspx");
        }
    }
}