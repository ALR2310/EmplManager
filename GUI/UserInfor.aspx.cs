using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.Json;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Services;
using BUS;
using DAL;
using DAL.Model;
using SubSonic;

namespace GUI
{
    public partial class UserInfor : System.Web.UI.Page
    {
        private User UserFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Files.Count > 0)
            {
                UpLoadImage();
            }

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

            UserManager.UpdateUsers(empolyee);
            return true;
        }

        protected void UpLoadImage()
        {
            if (Request.Files.Count > 0)
            {
                HttpPostedFile uploadedFile = Request.Files[0];
                if (uploadedFile != null && uploadedFile.ContentLength > 0)
                {
                    string uploadFolderPath = Server.MapPath("~/Images/Avatar/Uploads/");
                    string fileName = Path.GetFileName(uploadedFile.FileName);

                    // Đổi tên tập tin nếu tên đã tồn tại trong thư mục
                    int counter = 1;
                    string newFileName = fileName;

                    while (File.Exists(Path.Combine(uploadFolderPath, newFileName)))
                    {
                        string fileNameWithoutExtension = Path.GetFileNameWithoutExtension(fileName);
                        string fileExtension = Path.GetExtension(fileName);

                        newFileName = $"{fileNameWithoutExtension}_{counter}{fileExtension}";
                        counter++;
                    }

                    string filePath = Path.Combine(uploadFolderPath, newFileName);

                    uploadedFile.SaveAs(filePath);

                    string userId = Request.Form["userId"];
                    string AvatarPath = "/Images/Avatar/Uploads/" + newFileName;

                    UserManager.UpdateAvatarUrl(AvatarPath, Convert.ToInt32(userId));
                }
            }
        }







    }
}