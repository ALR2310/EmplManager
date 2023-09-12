using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BUS;
using DAL;
using DAL.Model;

namespace GUI
{
    public partial class MyLayout : System.Web.UI.MasterPage
    {
        public User UserFromCookie;

        protected void Page_Load(object sender, EventArgs e)
        {
            LoadNotify();
        }

        private void AssignInfos()
        {
            lblUserName.Text = UserFromCookie.DisplayName;
            ImgAvatar.ImageUrl = UserFromCookie.Avatar;
        }
        protected void Page_Init(object sender, EventArgs e)
        {

            int? id_from_validcookie = UserManager.checkValidCookie(Request);

            if (id_from_validcookie == null) { Response.Redirect("dang-nhap"); return; }

            UserFromCookie = UserManager.GetUsersById((int)id_from_validcookie);
            ViewState["UserFromCookie"] = UserFromCookie;


            Debug.WriteLine("Loaded User");
            AssignInfos();
        }

        protected void linkLogout_ServerClick(object sender, EventArgs e)
        {
            Logout();
        }

        protected void A1_ServerClick(object sender, EventArgs e)
        {
            Logout();
        }

        public void Logout()
        {
            HttpCookie cookie = Request.Cookies["AuthToken"];
            if (cookie != null)
            {
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }
            Response.Redirect("dang-nhap");
        }

        public void LoadNotify()
        {
            int CurrentUserId = UserFromCookie.Id;

            List<BasicUserNotify> notify = NotifyManager.LoadNotifyUnRead(CurrentUserId);
            Repeater1.DataSource = notify;
            Repeater1.DataBind();

            lblNotifyUnRead.Text = notify.Count.ToString();
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