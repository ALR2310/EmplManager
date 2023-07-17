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
using SubSonic.Sugar;
using System.Web.UI.HtmlControls;
using System.Text.Json;
using SubSonic;

namespace GUI
{
    public partial class Message : System.Web.UI.Page
    {
        public static User UserFromCookie;
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
                { "DeleteMessage", new Func<Dictionary<string, object>, bool>(DeleteMessage) }
            };
                }

                return _requestFunctions;
            }
        }
        #region RequestMethods
        protected bool InsertEmoji(Dictionary<string, object> args)
        {
            try
            {
                MessageManager.InsertEmoji(UserFromCookie.Id, int.Parse((string)args["Message_Id"]), int.Parse((string)args["Emoji_Id"]));
                return true;
            }
            catch
            {
                return false;
            }

        }
        protected bool DeleteMessage(Dictionary<string, object> args)
        {


            int Id = int.Parse(args["Message_Id"].ToString());

            MessageJoinUser DeletingMessage = messages[Id];

            if (DeletingMessage == null) { return false; }
            if (!(UserFromCookie.UserType == 0 || DeletingMessage.UserId == UserFromCookie.Id)) { return false; }
            MessageManager.SetMessStatusToDeleted(DeletingMessage, DeletingMessage.UserId == UserFromCookie.Id ? 0 : -1);
            ReloadMessages();
            return true;
        }
        #endregion
        private Dictionary<int, MessageJoinUser> messages
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



            Debug.WriteLine("Refreshing page...");
            if (!IsPostBack)
            {
                Debug.WriteLine("Refreshing messages...");
                UserFromCookie = MyLayout.UserFromCookie;
                LoadMessage();

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
                    Response.End();
                    Debug.WriteLine("Lỗi khi xử lý yêu cầu");
                    return;
                }
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "ChatListInit", "init();", true);
            Debug.WriteLine(messages.Count);
        }
        private DateTime lastIndexedTime = DateTime.Now;
        #region genericMethods
        protected bool GetTimeGap(int itemIndex)
        {
            TimeSpan TimeDiff = lastIndexedTime - messages[itemIndex].AtCreate;
            lastIndexedTime = messages[itemIndex].AtCreate;
            if (Math.Abs(TimeDiff.TotalMinutes) < 30) { return false; }

            return true;
        }

        protected string GetDateStr(int itemIndex)
        {

            DateTime atCreate = messages[itemIndex].AtCreate;
            TimeSpan TimeDiff = DateTime.Now - atCreate;
            int DayDiff = (int)TimeDiff.TotalDays;
            string DateStr = DayToStringDict.ContainsKey(DayDiff) ? DayToStringDict[DayDiff] : atCreate.ToString("dd/M/yyyy");


            return DateStr;
        }
        void ReloadMessages()
        {
            ListMessage_Repeater.DataSource = messages.Values.ToList();
            ListMessage_Repeater.DataBind();
        }
        void LoadMessage()
        {
            messages = MessageManager.GetListMessageByAtCreate(1);
            Debug.WriteLine("Loading Messages");

            ReloadMessages();


            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollBottomScript", "scrollBottom(); clearText();", true);

            return;
        }


        protected string IsOwnerMessage(int index)
        {
            string returned_str = UserFromCookie.Id == messages[index].UserId ? "owner='true'" : "";

            index = index + 1;

            return returned_str;

        }

        protected string IsHideDropdown(int index)
        {
            string returned_str = UserFromCookie.Id == messages[index].UserId ? "" : "hide";



            return returned_str;
        }

        protected string GetTime(DateTime date)
        {
            TimeSpan time = date.TimeOfDay;


            TimeSpan roundedTime = time.Subtract(TimeSpan.FromMilliseconds(time.Milliseconds));

            return roundedTime.ToString();
        }
        #endregion

        protected void btnSend_Click(object sender, EventArgs e)
        {
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