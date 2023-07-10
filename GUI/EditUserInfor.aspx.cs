using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using DAL;
using BUS;

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


                Debug.WriteLine(UserFromCookie.Id);
                Debug.WriteLine(CheckingValidUser.Id);
                if (UserFromCookie.Id == CheckingValidUser.Id)
                {
                    UserFromCookie.Email = tblEmail.Text;
                    UserFromCookie.DisplayName = tblDisplayName.Text;
                    UserFromCookie.UserName = tblUserName.Text;
                    UserFromCookie.Save();
                    ToastManager.SuccessToast("Cập Nhật Thành Công..");

                }
                
            }
        }
    }
}