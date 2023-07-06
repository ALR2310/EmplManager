using BUS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;
using DAL.Model;

namespace GUI
{
    public partial class Message : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bool validcookie = UserManager.checkValidCookie(Request);

                if (!validcookie) { Response.Redirect("login.aspx"); return; }

                LoadMessage();
            }
        }

        void LoadMessage()
        {
            List<MessageJoinUser> messages = MessageManager.GetListMessageByStatus();

            Repeater1.DataSource = messages;
            Repeater1.DataBind();
            return;
        }
    }
}