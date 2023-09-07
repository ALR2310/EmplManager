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
    }
}