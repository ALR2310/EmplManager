using BUS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;

namespace GUI
{
    public partial class Message : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

 

            bool validcookie = UserManager.checkValidCookie(Request);

            if (!validcookie) { Response.Redirect("login.aspx", true); return; }

            if (!IsPostBack)
            {
                List<DAL.Message> messages = MessageManager.GetListMessageByStatus(1);

                Repeater1.DataSource = messages;
                Repeater1.DataBind();
                return;
            }

     


        }
    }
}