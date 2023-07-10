using System;
using System.Collections.Generic;
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

            Debug.WriteLine(UserIdFromCookie);
            User user = new User();
            user.Id = UserIdFromCookie;

            UserManager.GetUsersById(user.Id);

            ImageAvatar.ImageUrl = user.Avatar;
            lblAtCreate.Text = user.UserName;
            lblDisplayName.Text = user.UserName;
            lblDisplayName1.Text = user.UserName;
            lblDisplayName2.Text = user.UserName;
            lblGooogleId.Text = user.UserName;
            lblEmail.Text = user.UserName;
            lblAtCreate.Text = user.AtCreate.ToString();
            lblAtCreate1.Text = user.AtCreate.ToString();

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