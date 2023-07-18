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

        [NonSerialized]
        private Dictionary<string, Func<Dictionary<string, object>, bool>> _requestFunctions;

        private static IHubContext hubContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();

        private static string success_str = "{\"success\":true}";
        private static string failed_str = "{\"success\":false}";

        private static bool VerifyUser(HttpContext context)
        {
            if (HttpContext.Current.Request.HttpMethod != "POST")
            {

                if (HttpContext.Current.Request.HttpMethod == "GET")
                {
                    HttpContext.Current.Response.Redirect("Message.aspx");
                }
                   
                return false; // Return null, as the response will be redirected
            }

            if (context == null || context.Request.Cookies["authToken"] == null)
            {
                return false;
            }

            string authToken = context.Request.Cookies["authToken"].Value;
            int? id = UserManager.getTokenUserId(authToken);
            if (id==null) { return false; }
            BasicUserData user = UserManager.GetUserBasicDataById((int)id);

            context.Items["RequestedUser"] = user;
            if (user == null)
            {
                return false;
            }
            return true;
        }

      
        [System.Web.Services.WebMethod]
        public static string ToggleEmoji(int Message_Id, int Emoji_Id)
        {
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return failed_str; }
            BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];
            MessageManager.InsertEmoji(RequestedUser.Id, Message_Id, Emoji_Id);

            return success_str;
        }

        [System.Web.Services.WebMethod]
     
        public static string GetMessageJsonData(int page)
        {
            
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return failed_str; }

            

            var jsonData = JsonSerializer.Serialize(MessageManager.GetListMessageByAtCreate(page));

            return jsonData;
        }

        [System.Web.Services.WebMethod]
    
        public static string GetUser(int id, bool fromCookie)
        {
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return failed_str; ; }
            if (fromCookie)
            {


                BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];
                Debug.WriteLine(JsonSerializer.Serialize(RequestedUser));   
                return JsonSerializer.Serialize(RequestedUser);
            }
            return JsonSerializer.Serialize(UserManager.GetUserBasicDataById(id));
        }

        [System.Web.Services.WebMethod]
        public static string SendMessage(string content)
        {
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return failed_str; }
            if (content == "") { return failed_str; }


            BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];

            DAL.Message message = new DAL.Message();
            message.UserId = RequestedUser.Id;
            message.Content = content;
            message.AtCreate = DateTime.Now;
            message.Status = 1;


            MessageManager.InsertMessage(message);


            hubContext.Clients.All.ReceiveMessage(JsonSerializer.Serialize(message));
            return success_str;
        }
        [System.Web.Services.WebMethod]
   
        public static string DeleteMessage(int id)
        {
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return failed_str; }


            BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];
            DAL.Message DeletingMessage = MessageManager.GetMessageById(id);

            if (DeletingMessage == null) { return failed_str; }
            if (!(RequestedUser.UserType == 0 || DeletingMessage.UserId == RequestedUser.Id)) { return failed_str; }
            int deleting_status = DeletingMessage.UserId == RequestedUser.Id ? 0 : -1;
            if (MessageManager.SetMessStatusToDeleted(id, deleting_status))
            {
                hubContext.Clients.All.MessageDeleted($"{{ \"id\": {id}, \"status\": {deleting_status}}}");
            }
            return success_str;

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