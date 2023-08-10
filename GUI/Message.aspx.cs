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
using SubSonic;
using System.Data;
using System.Threading;
using System.Threading.Tasks;
using System.IO;
using System.Linq;
using System.Runtime.Remoting.Contexts;
using System.Runtime.Remoting.Messaging;

namespace GUI
{



    public partial class Message : System.Web.UI.Page
    {



        private static IHubContext hubContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();

        private static string success_str = "{\"success\":true}";
        private static string failed_str = "{\"success\":false}";

        private static int? VerifyUser(HttpContext context)
        {
            if (HttpContext.Current.Request.HttpMethod != "POST")
            {



                return null; // Return null, as the response will be redirected
            }

            if (context == null || context.Request.Cookies["authToken"] == null)
            {
                return null;
            }

            string authToken = context.Request.Cookies["authToken"].Value;
            int? id = UserManager.getTokenUserId(authToken);
            if (id == null) { return null; }
            BasicUserData user = UserManager.GetUserBasicDataById((int)id);

            context.Items["RequestedUser"] = user;
            if (user == null)
            {
                return null;
            }
            return user.Id;
        }

        private static void updateReactions(int Message_Id, int Emoji_Id)
        {
            List<int> reactions = MessageManager.GetReactionsByMessageId(Message_Id, Emoji_Id);
            hubContext.Clients.All.UpdateReaction($"{{\"Message_Id\": {Message_Id},\"Emoji_Id\": {Emoji_Id}, \"Reaction_Ids\": {JsonSerializer.Serialize(reactions)}}}");

        }
        [System.Web.Services.WebMethod]
        public static string ToggleEmoji(int Message_Id, int Emoji_Id)
        {
            HttpContext context = HttpContext.Current;
            if (VerifyUser(context) == null) { return failed_str; }
            BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];
            MessageManager.InsertEmoji(RequestedUser.Id, Message_Id, Emoji_Id);

            Thread t = new Thread(() => updateReactions(Message_Id, Emoji_Id));
            t.Start();

            return success_str;
        }

        [System.Web.Services.WebMethod]

        public static string GetMessageJsonData(int page)
        {
            Debug.WriteLine("Verifying User..");
            HttpContext context = HttpContext.Current;
            if (VerifyUser(context) == null) { return failed_str; }


            Debug.WriteLine("Getting Data..");
            Dictionary<int, MessageJoinUser> messages = MessageManager.GetListMessageByAtCreate(page);

            Debug.WriteLine("Json Serializing..");
            string jsonData = JsonSerializer.Serialize(messages);
            Debug.WriteLine("Finished!");
            Debug.WriteLine(jsonData);
            return jsonData;
        }

        [System.Web.Services.WebMethod]

        public static string GetUser(int id, bool fromCookie)
        {
            HttpContext context = HttpContext.Current;
            if (VerifyUser(context) == null) { return failed_str; ; }
            if (fromCookie)
            {


                BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];
                Debug.WriteLine(JsonSerializer.Serialize(RequestedUser));
                return JsonSerializer.Serialize(RequestedUser);
            }
            return JsonSerializer.Serialize(UserManager.GetUserBasicDataById(id));
        }

        [System.Web.Services.WebMethod]
        public static string SearchMessage(string search_str, int page)
        {



            return MessageManager.SearchMessage(search_str, page);
        }
        [System.Web.Services.WebMethod]
        public static string GetTotalMessage()
        {
            InlineQuery query = new InlineQuery();
            IDataReader reader = query.ExecuteReader("select top 1 Id from Messages order by id desc;");


            if (reader.Read())
            {
                // Assuming 'AtCreate' is of DateTime type in the database.

                Dictionary<string, string> returned = new Dictionary<string, string>();
                returned["Id"] = Convert.ToString(reader["Id"]);
                return JsonSerializer.Serialize(returned);
            }


            reader.Close();
            return "";


        }
        [System.Web.Services.WebMethod]
        public static DAL.Message CreateMessage(string content, bool ignoreEmpty)
        {

  
            if (content == "" && !ignoreEmpty) { return null; }


            BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];

            DAL.Message message = new DAL.Message();
            message.UserId = RequestedUser.Id;
            message.Content = content;
            message.AtCreate = DateTime.Now;
            message.Status = 1;


            return message;

        }
        [System.Web.Services.WebMethod]
        public static string EditMessage(string content, int id)
        {
            Debug.WriteLine("Editing Message...");
            try
            {
                InlineQuery query = new InlineQuery();
                query.Execute($"exec edit_message @content = N'{content}', @mes_id = {id};");
                hubContext.Clients.All.MessageEdited($"{{ \"id\": {id}, \"new_content\": \"{content}\"}}");

                return success_str;
            }
            catch
            {
                HttpContext.Current.Response.StatusCode = 500;
                return failed_str;
            }
        }

        [System.Web.Services.WebMethod]
        public static string DeleteMessage(int id)
        {
            HttpContext context = HttpContext.Current;
            if (VerifyUser(context) == null) { return failed_str; }


            BasicUserData RequestedUser = (BasicUserData)HttpContext.Current.Items["RequestedUser"];
            DAL.Message DeletingMessage = MessageManager.GetMessageById(id);

            if (DeletingMessage == null) { return failed_str; }
            if (!(RequestedUser.UserType == 2 || DeletingMessage.UserId == RequestedUser.Id)) { return failed_str; }
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


        private string getSizeText(int size)
        {
            if (size > 1024*1024) { return (size / 1024 / 1024).ToString() + " MB"; }
            if (size > 1024) { return (size / 1024).ToString() + " KB"; }
            return size.ToString() + " B";
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            DAL.Message Message;
            int? UserId = VerifyUser(HttpContext.Current);
            if (UserId == null) { return; }

            string requestedUrl = Request.Url.ToString();
            string[] splited_url = requestedUrl.Split('/');
            Debug.WriteLine(splited_url[splited_url.Length - 1]);
            if (splited_url[splited_url.Length - 1] != "SendMessage")
            {

                return;
            }
     

            HttpFileCollection files = Request.Files;
            if (files.Count == 0) {
                Message = CreateMessage(Request.Form["content"], Request.Files.Count != 0);
                MessageManager.InsertMessage(Message);
                hubContext.Clients.All.ReceiveMessage(JsonSerializer.Serialize(Message));
                return; }

            List<Dictionary<object, object>> UploadedFiles = new List<Dictionary<object, object>>();

            for (int i = 0; i < files.Count; i++)
            {
                HttpPostedFile file = files[i];

                string fileName = Path.GetFileName(file.FileName);

                string fileExtension = Path.GetExtension(fileName);


                string uniqueFileName = Guid.NewGuid().ToString() + fileExtension;


                string uploadDirectory = Server.MapPath($"~/Images/UserUploads/{UserId}");
                string sizeString = getSizeText(file.ContentLength);
                UploadedFiles.Add(new Dictionary<object, object> {

                    {"fileName", Path.GetFileName(file.FileName)},
                    {"size", sizeString},
                    {"url", UserId+"/"+uniqueFileName}

                });
                if (!Directory.Exists(uploadDirectory))
                {
                    Directory.CreateDirectory(uploadDirectory);
                }

                string savePath = Path.Combine(uploadDirectory, uniqueFileName);


                file.SaveAs(savePath);

              
            }
            Debug.WriteLine("Uploaded File: " + JsonSerializer.Serialize(UploadedFiles));
            Message = CreateMessage(Request.Form["content"], Request.Files.Count != 0);
            Message.Uploaded_Files = JsonSerializer.Serialize(UploadedFiles);
            MessageManager.InsertMessage(Message);


            hubContext.Clients.All.ReceiveMessage(JsonSerializer.Serialize(Message));

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