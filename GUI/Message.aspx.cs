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
        public static User UserFromCookie;
   
        private List<MessageJoinUser> messages;

        protected void Page_Load(object sender, EventArgs e)
        {
            Debug.WriteLine("Refreshing page...");
            if (!IsPostBack)
            {
                UserFromCookie = MyLayout.UserFromCookie;
                LoadMessage();
            }
        }

        void LoadMessage()
        {
            messages = MessageManager.GetListMessageByAtCreate();
            Debug.WriteLine(messages.Count);
            Repeater1.DataSource = messages;
            Repeater1.DataBind();



            return;
        }
        protected string IsOwnerMessage(int index)
        {
            string returned_str = UserFromCookie.Id == messages[index].UserId ? "chat-main__item--right" : "";

            index = index + 1;

            return returned_str;

        }

        protected string IsHideDropdown(int index)
        {
            string returned_str = UserFromCookie.Id == messages[index].UserId ? "" : "hide";

     

            return returned_str;
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            Debug.WriteLine("Delete Mess");
            if (IsPostBack)
            {
                Debug.WriteLine("Deleting ");
                Button btn = (Button)sender;
          
                int index = int.Parse(btn.CommandArgument.ToString());

                Debug.WriteLine(index);
                if (messages[index] == null) { return;  }
                if (!(UserFromCookie.UserType == 0 || messages[index].UserId == UserFromCookie.Id)) { return; }
                MessageManager.SetMessStatusToDeleted(messages[index].Id);
                
            }
            return  ;
          
        }
        protected void btnSend_Click(object sender, EventArgs e)
        {

            Debug.WriteLine("HUH");
            DAL.Message message = new DAL.Message();
            message.UserId = UserFromCookie.Id;
            message.Content = txt_Message.Text;
            message.AtCreate = DateTime.Now;
            message.Status = 1;


            MessageManager.InsertMessage(message);
            LoadMessage();

            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollBottomScript", "scrollBottom(); clearText();", true);
            return;
        }

        protected void btnLike_Click(object sender, EventArgs e)
        {

        }
    }
}