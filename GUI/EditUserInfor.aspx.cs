using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using DAL;
using BUS;
using System.IO;
namespace GUI
{
    public partial class EditUserInfor : System.Web.UI.Page
    {
        private static User UserFromCookie;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserFromCookie = MyLayout.UserFromCookie;
                AssignInfo();
                Debug.WriteLine("Assigned User");
            }
            return;
        }

        private void AssignInfo()
        {
            tblEmail.Text = UserFromCookie.Email;
            tblDisplayName.Text = UserFromCookie.DisplayName;
            ImageAvatar.ImageUrl = UserFromCookie.Avatar;
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            User CheckingValidUser = UserManager.getTokenUser(Request.Cookies["AuthToken"].Value);
            if (CheckingValidUser == null) { return; }

            Debug.WriteLine(UserFromCookie.Id);
            Debug.WriteLine(CheckingValidUser.Id);
            if (UserFromCookie.Id == CheckingValidUser.Id)
            {
              
                Debug.WriteLine("Saving...");
                Debug.WriteLine(uploadAvatar.HasFile);
                if (uploadAvatar.HasFile)
                {
                    Debug.WriteLine(uploadAvatar.FileName);
                    // Get the file name and extension
                    string fileName = $"U_{CheckingValidUser.Id}";
                    string extension = Path.GetExtension(uploadAvatar.FileName);

                    // Specify the directory to save the file
                    string uploadDirectory = Server.MapPath("~/Images/Avatar/Uploads");

                    // Generate a unique file name

                    string uniqueFileName = fileName + ((DateTimeOffset)DateTime.UtcNow).Millisecond + extension;

                    Debug.WriteLine(uniqueFileName);
                    // Save the file to the server
                    if (UserFromCookie.Avatar != null)
                    {
                        File.Delete(Server.MapPath("~/") + UserFromCookie.Avatar);
                    }
                    uploadAvatar.SaveAs(Path.Combine(uploadDirectory, uniqueFileName));
                    Debug.WriteLine(Path.Combine(uploadDirectory, uniqueFileName));
                    Debug.WriteLine(Path.Combine("/Images/Avatar/Uploads", uniqueFileName));
                    UserFromCookie.Avatar = Path.Combine("/Images/Avatar/Uploads", uniqueFileName);
                    // Display a success message or perform further processing
                    // ...
                }

                UserFromCookie.Email = tblEmail.Text;
                UserFromCookie.DisplayName = tblDisplayName.Text;

                UserFromCookie.Save();
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "my", "toggleModal()", true);

                AssignInfo();
            }
        }

        protected void btnChanges_Click(object sender, EventArgs e)
        {
            User user = new User();
            user.Id = UserFromCookie.Id;
            user.Password = tblNewPassword.Text;
            if (UserFromCookie.Password == tblOldPassword.Text)
            {
                UserManager.UpdateUser(user);
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "my", "toggleModal()", true);
            }
            else
            {
                ToastManager.WaringToast("Mật Khẩu cũ không đúng, vui lòng kiểm tra lại");
            }
        }
    }
}