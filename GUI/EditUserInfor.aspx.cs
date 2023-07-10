using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using DAL;
namespace GUI
{
    public partial class EditUserInfor : System.Web.UI.Page
    {
        private User UserFromCookie;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserFromCookie = MyLayout.UserFromCookie;

            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            Debug.WriteLine("A");
            return;
        }
    }
}