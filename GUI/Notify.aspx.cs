using MailKit.Net.Imap;
using MailKit;
using MimeKit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;
using BUS;
using System.Web.Services;
using DAL.Model;
using System.Text.Json;

namespace GUI
{
    public partial class Notify : System.Web.UI.Page
    {
        private User UserFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserFromCookie = ((MyLayout)Master).UserFromCookie;
            if (!IsPostBack)
            {
                lblCurentId.Text = UserFromCookie.Id.ToString();
                LoadNotify();
            }
        }

        void LoadNotify()
        {
            List<BasicUserNotify> notify = NotifyManager.LoadNotify();
            Repeater1.DataSource = notify;
            Repeater1.DataBind();

            lblCountNotifyBox.Text = notify.Count.ToString();
        }

        [WebMethod]
        public static string GetDataNotify(string NotifyId)
        {
            BasicUserNotify userNotify = NotifyManager.FirstDataNotify(Convert.ToInt32(NotifyId));
            return JsonSerializer.Serialize(userNotify);
        }

        [WebMethod]
        public static string GetUserNotify(string UserId)
        {
            List<UserNotify> userNotify = NotifyManager.GetDataUserNotify(Convert.ToInt32(UserId));
            return JsonSerializer.Serialize(userNotify);
        }

        [WebMethod]
        public static bool InsertNotify(string UserId, string Content)
        {
            Notifys notifys = new Notifys
            {
                UserId = Convert.ToInt32(UserId),
                Content = Content,
                Status = 1
            };

            NotifyManager.InsertNotify(notifys);

            return true;
        }

        [WebMethod]
        public static bool InsertUserIsRead(string UserId, string NotifyId)
        {
            UserNotify userNotify = new UserNotify
            {
                UserId = Convert.ToInt32(UserId),
                NotifyId = Convert.ToInt32(NotifyId)
            };

            bool chekcUser = NotifyManager.InsertUserIsRead(userNotify);
            if (chekcUser)
            {
                return true;
            }
            return false;
        }

        protected string FormatDate(object dateObj)
        {
            if (dateObj != null && dateObj != DBNull.Value)
            {
                DateTime atCreate = Convert.ToDateTime(dateObj);
                DateTime today = DateTime.Today;

                // Loại bỏ thời gian khỏi ngày
                atCreate = atCreate.Date;
                today = today.Date;

                TimeSpan timeDifference = today - atCreate;

                if (timeDifference.Days == 0)
                {
                    return "Hôm nay";
                }
                else if (timeDifference.Days == 1)
                {
                    return "Hôm qua";
                }
                else if (timeDifference.Days <= 7)
                {
                    return $"{timeDifference.Days} ngày trước";
                }
                else if (timeDifference.Days <= 30)
                {
                    int weeks = timeDifference.Days / 7;
                    return $"{weeks} tuần trước";
                }
                else if (timeDifference.Days <= 365)
                {
                    int months = timeDifference.Days / 30;
                    return $"{months} tháng trước";
                }
                else
                {
                    int years = timeDifference.Days / 365;
                    return $"{years} năm trước";
                }
            }

            return string.Empty;
        }


    }
}