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


        private static bool VerifyUser(HttpContext context)
        {
            Debug.WriteLine("Verifying authToken");

            if (context == null || context.Request.Cookies["authToken"] == null)
            {
                return false;
            }

            string authToken = context.Request.Cookies["authToken"].Value;
            User user = UserManager.getTokenUser(authToken);


            context.Items["RequestedUser"] = user;
            if (user == null)
            {
                return false;
            }
            return true;
        }

        protected bool InsertEmoji(Dictionary<string, object> args)
        {
            /*
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
            */
            return true;
        }
    
        [System.Web.Services.WebMethod]
     
        public static string GetMessageJsonData(int page)
        {
            
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return "{d:null}"; }

            var jsonData = JsonSerializer.Serialize(MessageManager.GetListMessageByAtCreate(page));

            return jsonData;
        }

        [System.Web.Services.WebMethod]
        [VerifyAuthToken]
        public static string GetUser(int id, bool fromCookie)
        {
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return "{d:null}"; }
            if (fromCookie)
            {


                User RequestedUser = (User)HttpContext.Current.Items["RequestedUser"];
                Debug.WriteLine(JsonSerializer.Serialize(RequestedUser));   
                return JsonSerializer.Serialize(RequestedUser);
            }
            return JsonSerializer.Serialize(UserManager.GetUsersById(id));
        }

        [System.Web.Services.WebMethod]
        public static void SendMessage(string content)
        {
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return; }
            if (content == "") { return; }
        

            User RequestedUser = (User)HttpContext.Current.Items["RequestedUser"];

            DAL.Message message = new DAL.Message();
            message.UserId = RequestedUser.Id;
            message.Content = content;
            message.AtCreate = DateTime.Now;
            message.Status = 1;


            MessageManager.InsertMessage(message);


            hubContext.Clients.All.ReceiveMessage(JsonSerializer.Serialize(message));
        }
        [System.Web.Services.WebMethod]
   
        public static void DeleteMessage(int id)
        {
            HttpContext context = HttpContext.Current;
            if (!VerifyUser(context)) { return; }


            User RequestedUser = (User)HttpContext.Current.Items["RequestedUser"];
            DAL.Message DeletingMessage = MessageManager.GetMessageById(id);

            if (DeletingMessage == null) { return; }
            if (!(RequestedUser.UserType == 0 || DeletingMessage.UserId == RequestedUser.Id)) { return; }
            if (MessageManager.SetMessStatusToDeleted(id, DeletingMessage.UserId == RequestedUser.Id ? 0 : -1))
            {
                hubContext.Clients.All.MessageDeleted(id);
            }


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