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

        private void AssignInfo()
        {
            tblEmail.Text = UserFromCookie.Email;
            tblDisplayName.Text = UserFromCookie.DisplayName;
            tblUserName.Text = UserFromCookie.UserName;
            ImageAvatar.ImageUrl = UserFromCookie.Avatar;
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserFromCookie = MyLayout.UserFromCookie;
                AssignInfo();
                Debug.WriteLine("Assigned User");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                User CheckingValidUser = UserManager.getTokenUser(Request.Cookies["AuthToken"].Value);
                if (CheckingValidUser == null) { return; }

                Debug.WriteLine(UserFromCookie.Id);
                Debug.WriteLine(CheckingValidUser.Id);
                if (UserFromCookie.Id == CheckingValidUser.Id)
                {
                    if (uploadAvatar.HasFile)
                    {
                        // Get the file name and extension
                        string fileName = $"U_{CheckingValidUser.Id}";
                        string extension = Path.GetExtension(fileName);

                        // Specify the directory to save the file
                        string uploadDirectory = Server.MapPath("~/Images/Avatar/Uploads");

                        // Generate a unique file name
                        string uniqueFileName = fileName + extension;

                        // Save the file to the server
                        uploadAvatar.SaveAs(Path.Combine(uploadDirectory, uniqueFileName));
                        UserFromCookie.Avatar = Path.Combine(uploadDirectory, uniqueFileName);
                        // Display a success message or perform further processing
                        // ...
                    }

                    UserFromCookie.Email = tblEmail.Text;
                    UserFromCookie.DisplayName = tblDisplayName.Text;
                    UserFromCookie.UserName = tblUserName.Text;

          
                    UserFromCookie.Save(); 
                    Debug.WriteLine("Lưu thàng công");
                    
                }
                
            }
        }
    }
}