using BUS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;
using DAL.Model;
using System.Diagnostics;

namespace GUI
{
    public partial class Message : System.Web.UI.Page
    {
        private static int UserIdFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                bool validcookie = UserManager.checkValidCookie(Request);

                if (!validcookie) { Response.Redirect("login.aspx"); return; }

                UserIdFromCookie = UserManager.getTokenUser(Request.Cookies["AuthToken"].Value);
                Debug.WriteLine(UserIdFromCookie);
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

        protected void btnSend_Click(object sender, EventArgs e)
        {

            Debug.WriteLine(UserIdFromCookie);
            DAL.Message message = new DAL.Message();
            message.UserId = UserIdFromCookie;
            message.Content = txt_Message.Text;
            message.AtCreate = DateTime.Now;
            message.Status = 1;

  
            MessageManager.InsertMessage(message);

        }
    }
}