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
        public User UserFromCookie;

        private void AssignInfos()
        {
            lblUserName.Text = UserFromCookie.DisplayName;
        }
        protected void Page_Init(object sender, EventArgs e)
        {

            int? id_from_validcookie = UserManager.checkValidCookie(Request);

            if (id_from_validcookie == null) { Response.Redirect("login.aspx"); return; }
      
            UserFromCookie = UserManager.GetUsersById((int)id_from_validcookie);



            Debug.WriteLine("Loaded User");
            AssignInfos();


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