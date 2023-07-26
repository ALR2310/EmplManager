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

namespace GUI
{
    public partial class Empolyee : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEmpolyee();

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
        public static string GetUserIdByJS(string UserId)
        {
            EmpolyeeInfor empolyee = EmpolyeeManager.GetEmpolyeeById(Convert.ToInt32(UserId));
            JavaScriptSerializer serializer = new JavaScriptSerializer();

            return serializer.Serialize(empolyee);
        }

    }
}