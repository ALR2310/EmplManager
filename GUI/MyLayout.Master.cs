using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GUI
{
    public partial class MyLayout : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Message.UserFromCookie != null)
            {
                lblUserName.Text = Message.UserFromCookie.DisplayName;
            }
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