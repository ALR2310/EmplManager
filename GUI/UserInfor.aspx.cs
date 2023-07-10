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
        private User UserFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserFromCookie = MyLayout.UserFromCookie;
                LoadUser();
            }
        }
     
        void LoadUser()
        {
            User user = UserManager.GetUsersById(UserFromCookie.Id);

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
                lblAtCreate1.Text = DateJoin.ToString("dd/MM/yyyy");

                //Đếm số ngày hoạt động của user này
                DateTime Today = DateTime.Now;
                lblDayOnline.Text = Today.Subtract(DateJoin).Days.ToString();

                //Đếm số lượng tin nhắn
                lblChatCount.Text = UserManager.CountDayUserOnline(UserFromCookie.Id).ToString();

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