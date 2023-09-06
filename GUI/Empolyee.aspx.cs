using BUS;
using DAL.Model;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Text.Json;
using System.Data;
using DAL;
using SubSonic;
using System.IO;

namespace GUI
{
    public partial class Empolyee : System.Web.UI.Page
    {
        private User UserFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            UserFromCookie = ((MyLayout)Master).UserFromCookie;
            if (!IsPostBack)
            {
                LoadEmpolyee();
                lblCurrentId.Text = UserFromCookie.Id.ToString();
            }

            if (Request.Files.Count > 0)
            {
                UpLoadImage();
            }
        }

        public void LoadEmpolyee()
        {
            List<EmpolyeeInfor> empolyeeInfor = EmpolyeeManager.GetAllEmpolyee();

            Repeater1.DataSource = empolyeeInfor;
            Repeater1.DataBind();

            lblCountEmpolyee.Text = EmpolyeeManager.CountEmpolyee().ToString();
        }

        [WebMethod]
        public static string GetDataForEmpolyee(string UserId)
        {
            EmpolyeeInfor empolyee = EmpolyeeManager.GetEmpolyeeById(Convert.ToInt32(UserId));
            return JsonSerializer.Serialize(empolyee);
        }

        [WebMethod]
        public static int ChangeStatusUser(string StatusId, string UserId)
        {
            int statusId = Convert.ToInt32(StatusId);
            int userId = Convert.ToInt32(UserId);
            EmpolyeeManager.ChangeStatusUer(statusId, userId);
            return statusId;
        }

        [WebMethod]
        public static bool ChangeUserType(string UserId, string UserType)
        {
            int userId = Convert.ToInt32(UserId);
            int userType = Convert.ToInt32(UserType);
            EmpolyeeManager.ChangeUserType(userType, userId);
            if (userType == 0)
            {
                return true;
            }
            return false;
        }

        [WebMethod]
        public static bool DeleteUser(string UserId)
        {
            if (EmpolyeeManager.DeleteUser(Convert.ToInt32(UserId)) == true)
            {
                return true;
            }
            return false;
        }

        public void EmpolyeeSearch()
        {
            string SearchContent = tblSearch.Text;
            List<EmpolyeeInfor> empolyees = EmpolyeeManager.SearchEmpolyee(SearchContent);

            Repeater1.DataSource = empolyees;
            Repeater1.DataBind();
        }

        protected void tblSearch_TextChanged(object sender, EventArgs e)
        {
            EmpolyeeSearch();
            if (string.IsNullOrEmpty(tblSearch.Text)) { LoadEmpolyee(); }
        }

        protected void btnSearch_ServerClick(object sender, EventArgs e)
        {
            EmpolyeeSearch();
            if (string.IsNullOrEmpty(tblSearch.Text)) { LoadEmpolyee(); }
        }

        [WebMethod]
        public static string GetCountEmpolyee()
        {
            return EmpolyeeManager.CountEmpolyee().ToString();
        }

        [WebMethod]
        public static bool UpdateDataEmpolyee(int userid, string displayName, string phoneNumber,
                                     string email, DateTime dateJoin, string job, string department,
                                     string gender, DateTime dateOfBirth, string address, int userType, int status)
        {
            EmpolyeeInfor empolyee = new EmpolyeeInfor
            {
                Id = userid,
                DisplayName = displayName,
                PhoneNumber = phoneNumber,
                Email = email,
                AtCreate = dateJoin,
                Job = job,
                Department = department,
                Gender = gender,
                DateOfBirth = dateOfBirth,
                Address = address,
                UserType = userType,
                Status = status
            };


            EmpolyeeManager.UpdateEmpolyee(empolyee);

            return true;
        }


        [WebMethod]
        public static int ChangeStatusAllSelectUser(string status, int[] userIdarr)
        {
            int statusId = Convert.ToInt32(status);
            EmpolyeeManager.ChangeStatusAllSelectUser(statusId, userIdarr);
            return statusId;
        }

        [WebMethod]
        public static bool DeleteAllUserSelect(int[] userIdarr)
        {
            EmpolyeeManager.DeleteAlluserSelect(userIdarr);
            return true;
        }

        [WebMethod]
        public static void SendEmail(string[] recipients, string subject, string content, string[] ccRecipients, string[] bccRecipients)
        {
            EmpolyeeManager.SendEmail(recipients, subject, content, ccRecipients, bccRecipients);
        }

        [WebMethod]
        public static bool CheckCurrentUserType(string Id)
        {
            User user = new User
            {
                Id = Convert.ToInt32(Id),
                UserType = 2,
            };
            List<User> result = EmpolyeeManager.CheckCurrentUserType(user);

            if (result.Count > 0)
            {
                return true;
            }
            return false;
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