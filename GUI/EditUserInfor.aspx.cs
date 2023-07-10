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
        private User UserFromCookie;

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

            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (UserFromCookie.Id == UserManager.getTokenUser(Request.Cookies["AuthToken"].Value).Id)
            {
                ToastManager.SuccessToast("Lưu thay đổi thành công!");
            }
            return;
        }
    }
}