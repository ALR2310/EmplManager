using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Text.Json;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using BUS;
using DAL;
using DAL.Model;

namespace GUI
{
    public partial class UserInfor : System.Web.UI.Page
    {
        private User UserFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserFromCookie = ((MyLayout)Master).UserFromCookie;
            if (!IsPostBack)
            {
                lblCurrentUserId.Text = UserFromCookie.Id.ToString();


            }

            User user = UserManager.GetUsersById(UserFromCookie.Id);
            DateTime DateJoin = (DateTime)user.AtCreate;

            //Đếm số ngày hoạt động của user này
            DateTime Today = DateTime.Now;
            lblDateOnl.Text = Today.Subtract(DateJoin).Days.ToString() + " Ngày";

            //Đếm số lượng tin nhắn
            lblMessageCount.Text = UserManager.CountDayUserOnline(UserFromCookie.Id).ToString() + " Tin Nhắn";
        }

        [WebMethod]
        public static string ShowUserInforByCurrentId(string Id)
        {
            EmpolyeeInfor empolyee = EmpolyeeManager.GetEmpolyeeById(Convert.ToInt32(Id));
            return JsonSerializer.Serialize(empolyee);
        }

        [WebMethod]
        public static bool UpdateDataUser(int UserId, string DisplayName, string PhoneNumber, string Email, DateTime AtCreate, string Job, string Department, string Gender, DateTime DateOfBirth, string Address)
        {
            EmpolyeeInfor empolyee = new EmpolyeeInfor
            {
                Id = UserId,
                DisplayName = DisplayName,
                PhoneNumber = PhoneNumber,
                Email = Email,
                AtCreate = AtCreate,
                Job = Job,
                Department = Department,
                Gender = Gender,
                DateOfBirth = DateOfBirth,
                Address = Address,
            };

            EmpolyeeManager.UpdateEmpolyee(empolyee);
            return true;
        }
    }
}