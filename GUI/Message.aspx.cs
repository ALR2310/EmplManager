using BUS;
using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;
using DAL.Model;
using System.Diagnostics;

using System.Web.UI.HtmlControls;
using System.Text.Json;





using Microsoft.AspNet.SignalR;
using SignalRChat.Hubs;

namespace GUI
{



    public partial class Message : System.Web.UI.Page
    {
        public User UserFromCookie;
        [NonSerialized]
        private Dictionary<string, Func<Dictionary<string, object>, bool>> _requestFunctions;


        private Dictionary<string, Func<Dictionary<string, object>, bool>> RequestMethods
        {
            get
            {
                if (_requestFunctions == null)
                {
                    _requestFunctions = new Dictionary<string, Func<Dictionary<string, object>, bool>>
                    {
                { "DeleteMessage", new Func<Dictionary<string, object>, bool>(DeleteMessage) },
                { "InsertEmoji", new Func<Dictionary<string, object>, bool>(InsertEmoji)  }
            };
                }

                return _requestFunctions;
            }
        }
      
        protected bool InsertEmoji(Dictionary<string, object> args)
        {
            try
            {
                MessageManager.InsertEmoji(UserFromCookie.Id, int.Parse(args["Message_Id"].ToString()), int.Parse(args["Emoji_Id"].ToString()));
                return true;
            }
            catch (Exception e)
            {
                Debug.Write(e);
                return false;
            }

        }
        [System.Web.Services.WebMethod]
        public static string GetMessageJsonData(int page)
        {
           

            var jsonData = JsonSerializer.Serialize(MessageManager.GetListMessageByAtCreate(page));

            return jsonData;
        }

        [System.Web.Services.WebMethod]
        public static string GetUser(int id,bool fromCookie)
        {
            if (fromCookie) { 
           
            string authTokenCookie = HttpContext.Current.Request.Cookies["authToken"].Value;

            return JsonSerializer.Serialize(UserManager.getTokenUser(authTokenCookie));
            }
            return JsonSerializer.Serialize(UserManager.GetUsersById(id));
        }

        [System.Web.Services.WebMethod]



        public static void SendMessage(string content)
        {
            if (content == "") { return; }
            string authTokenCookie = HttpContext.Current.Request.Cookies["authToken"].Value;
            User sendingUser = UserManager.getTokenUser(authTokenCookie);
            if (sendingUser == null) { return;  }

    
            DAL.Message message = new DAL.Message();
            message.UserId = UserManager.getTokenUser(authTokenCookie).Id;
            message.Content = content;
            message.AtCreate = DateTime.Now;
            message.Status = 1;


            MessageManager.InsertMessage(message);

            var hubContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
            hubContext.Clients.All.ReceiveMessage(JsonSerializer.Serialize(message));
        }
        protected bool DeleteMessage(Dictionary<string, object> args)
        {

            /*
            int Id = int.Parse(args["Message_Id"].ToString());

            MessageJoinUser DeletingMessage = messages[Id];

            if (DeletingMessage == null) { return false; }
            if (!(UserFromCookie.UserType == 0 || DeletingMessage.UserId == UserFromCookie.Id)) { return false; }
            MessageManager.SetMessStatusToDeleted(DeletingMessage, DeletingMessage.UserId == UserFromCookie.Id ? 0 : -1);
            ReloadMessages();
            return true;
            */
            return true;
        }
    
        protected Dictionary<int, MessageJoinUser> messages
        {
            get { return ViewState["messages"] as Dictionary<int, MessageJoinUser>; }
            set { ViewState["messages"] = value; }
        }

        private Dictionary<int, string> DayToStringDict
        {
            get
            {
                if (ViewState["DayToStringDict"] == null)
                {
                    ViewState["DayToStringDict"] = new Dictionary<int, string>
                    {
                        {0,"Hôm nay" },
                        {1,"Hôm qua" },
                        {2,"Hôm kia" }
                    };

                }
                return ViewState["DayToStringDict"] as Dictionary<int, string>;
            }
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {


            UserFromCookie = ((MyLayout)Master).UserFromCookie;
            Debug.WriteLine("Refreshing page...");
            if (!IsPostBack)
            {
                Debug.WriteLine("Refreshing messages...");

                //LoadMessage();

            }
           
            string targetControlID = Request["__EVENTTARGET"];
            string eventArgument = Request["__EVENTARGUMENT"];

            Debug.WriteLine(eventArgument);
            if (targetControlID != null && RequestMethods.ContainsKey(targetControlID))
            {
  
                bool success = RequestMethods[targetControlID].Invoke(JsonSerializer.Deserialize<Dictionary<string, object>>(eventArgument));

                if (!success)
                {
                    Response.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
                    Response.Write("Internal error");
                    Debug.WriteLine("Lỗi khi xử lý yêu cầu");
                    Response.End();
  
                    return;
                }
             
            }
            /*
            ScriptManager.RegisterStartupScript(this, GetType(), "ChatListInit", "init();", true);
            Debug.WriteLine(messages.Count);
            */
        }
  

       

     
        protected void btnSend_Click(object sender, EventArgs e)
        {   /*
            if (txt_Message.Text == "") { LoadMessage(); return; }

            Debug.WriteLine("Send");
            DAL.Message message = new DAL.Message();
            message.UserId = UserFromCookie.Id;
            message.Content = txt_Message.Text;
            message.AtCreate = DateTime.Now;
            message.Status = 1;

            MessageManager.InsertMessage(message);
            LoadMessage();

            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollBottomScript", "scrollBottom(); clearText();", true);
            return;
            */
        }

        public void LoadEmoji(int IdMessage)
        {
            List<LikeJoinUser> emojiInfor = LikeManager.GetAllUserAndEmoji(IdMessage);
            ListEmoji_Repeater.DataSource = emojiInfor;
            ListEmoji_Repeater.DataBind();

        }

        protected void OpenEmojiModal_Click(object sender, EventArgs e)
        {
            //HtmlButton htmlButton = (HtmlButton)sender;
            //int IdMessage = Convert.ToInt32(htmlButton.Attributes["CommandArgument"]);

            Button button = (Button)sender;
            int IdMessage = Convert.ToInt32(button.CommandArgument);

            LoadEmoji(IdMessage);
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "myjs", "toggleModal()", true);
        }

        protected void RemoveEmoji_ServerClick(object sender, EventArgs e)
        {
            HtmlAnchor link = (HtmlAnchor)sender;
            string commandArgument = link.Attributes["CommandArgument"];
            int likeId = Convert.ToInt32(commandArgument);

            LikeManager.ChangeStatusLike(likeId);
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "myjs", "toggleModal()", true);
        }
    }
}