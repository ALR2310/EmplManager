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
using System.Reflection;
using System.Web.Services.Description;

namespace GUI
{
    public partial class Message : System.Web.UI.Page
    {
        private static int UserIdFromCookie;
        private int index = 0;
        private List<MessageJoinUser> messages;
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
            messages = MessageManager.GetListMessageByStatus();
            index = 0;
            Repeater1.DataSource = messages;
            Repeater1.DataBind();
            return;
        }
        public string IsOwnerMessage()
        {
            string returned_str = UserIdFromCookie == messages[index].UserId ? "chat-main__item--right" : "";

            index = index + 1;

            return returned_str;
            
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