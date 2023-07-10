using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BUS;
using DAL;

namespace GUI
{
    public partial class UserInfor : System.Web.UI.Page
    {
        private static int UserIdFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserIdFromCookie = UserManager.getTokenUser(Request.Cookies["AuthToken"].Value);
                Debug.WriteLine(UserIdFromCookie);
                LoadUser();
            }
        }

        void LoadUser()
        {
            User user = UserManager.GetUsersById(UserIdFromCookie);

            if (user != null)
            {
                DateTime DateJoin = (DateTime)user.AtCreate;

                ImageAvatar.ImageUrl = user.Avatar;
                lblAtCreate.Text = DateJoin.ToString("dd/MM/yyyy");
                lblDisplayName.Text = user.DisplayName;
                lblDisplayName1.Text = user.DisplayName;
                lblDisplayName2.Text = user.DisplayName;
                lblGooogleId.Text = user.GoogleId.ToString();
                lblEmail.Text = user.Email;
                lblAtCreate.Text = DateJoin.ToString("dd/MM/yyyy");
                lblAtCreate1.Text = DateJoin.ToString("dd/MM/yyyy");

                switch (user.UserType)
                {
                    case 0:
                        lblUserType.Text = "Admin";
                        break;
                    case 1:
                        lblUserType.Text = "User";
                        break;
                }

                switch (user.Status)
                {
                    case 0:
                        lblStatus.Text = "Tệ";
                        lblStatus.Style.Add("Color", "red");
                        break;
                    case 1:
                        lblStatus.Text = "Tốt";
                        lblStatus.Style.Add("Color", "green");
                        break;
                }
            }
        }
    }
}