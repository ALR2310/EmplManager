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

namespace GUI
{
    public partial class Message : System.Web.UI.Page
    {
        public static User UserFromCookie;
        private Dictionary<int, string> DayToStringDict = new Dictionary<int, string>();

        private List<MessageJoinUser> messages
        {
            get { return ViewState["messages"] as List<MessageJoinUser>; }
            set { ViewState["messages"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            DayToStringDict.Add(0, "Hôm nay");
            DayToStringDict.Add(1, "Hôm qua");
            DayToStringDict.Add(2, "Hôm kia");


            Debug.WriteLine("Refreshing page...");
            if (!IsPostBack)
            {
                Debug.WriteLine("Refreshing messages...");
                UserFromCookie = MyLayout.UserFromCookie;
                LoadMessage();
                LoadEmoji();
                return;
            }
            Debug.WriteLine(messages.Count);
        }
        private DateTime lastIndexedTime = DateTime.Now;

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
        void LoadMessage()
        {
            messages = MessageManager.GetListMessageByAtCreate(1);
            Debug.WriteLine(messages.Count);
            ListMessage_Repeater.DataSource = messages;
            ListMessage_Repeater.DataBind();

            ScriptManager.RegisterStartupScript(this, GetType(), "ScrollBottomScript", "scrollBottom(); clearText();", true);

            return;
        }


        protected string IsOwnerMessage(int index)
        {
            string returned_str = UserFromCookie.Id == messages[index].UserId ? "chat-main__item--right" : "";

            index = index + 1;

            return returned_str;

        }

        protected void InsertEmoji(int emojiid)
        {
            Debug.WriteLine(emojiid);
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

        protected void btnDelete_Click(object sender, EventArgs e)
        {

            Debug.WriteLine("Deleting");
            Button btn = (Button)sender;

            int Id = int.Parse(btn.CommandArgument.ToString());

            DAL.Message DeletingMessage = MessageManager.GetMessageById(Id);

            Debug.WriteLine(Id);
            if (DeletingMessage == null) { return; }
            if (!(UserFromCookie.UserType == 0 || DeletingMessage.UserId == UserFromCookie.Id)) { return; }
            MessageManager.SetMessStatusToDeleted(DeletingMessage.Id, DeletingMessage.UserId == UserFromCookie.Id ? 0 : -1);

            Debug.WriteLine("Deleted");
            LoadMessage();

            return;
        }
        protected void btnSend_Click(object sender, EventArgs e)
        {
            if (txt_Message.Text == "") { LoadMessage(); return; }

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

        public void LoadEmoji()
        {
            List<LikeJoinUser> emojiInfor = LikeManager.GetAllUserAndEmoji();
            ListEmoji_Repeater.DataSource = emojiInfor;
            ListEmoji_Repeater.DataBind();
        }

        protected void RemoveEmoji_ServerClick(object sender, EventArgs e)
        {

        }
    }
}