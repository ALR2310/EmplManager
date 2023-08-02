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
            return JsonSerializer.Serialize(empolyee);
        }

        [WebMethod]
        public static bool ChangeStatusUser(string StatusId, string UserId)
        {
            int statusId = Convert.ToInt32(StatusId);
            int userId = Convert.ToInt32(UserId);
            EmpolyeeManager.ChangeStatusUer(statusId, userId);
            if (statusId == 1)
            {
                return true;
            }
            return false;
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
        //protected void DrpFilterSelect_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    List<EmpolyeeInfor> empolyees;
        //    switch (DrpFilterSelect.SelectedIndex)
        //    {
        //        case 0:
        //            empolyees = EmpolyeeManager.GetAllEmpolyee();
        //            Repeater1.DataSource = empolyees;
        //            Repeater1.DataBind();
        //            break;
        //        case 1:
        //            empolyees = EmpolyeeManager.FilterEmpolyeeForStatus(1);
        //            Repeater1.DataSource = empolyees;
        //            Repeater1.DataBind();
        //            break;
        //        case 2:
        //            empolyees = EmpolyeeManager.FilterEmpolyeeForStatus(0);
        //            Repeater1.DataSource = empolyees;
        //            Repeater1.DataBind();
        //            break;
        //        case 3:
        //            empolyees = EmpolyeeManager.FilterEmpolyeeForStatus(2);
        //            Repeater1.DataSource = empolyees;
        //            Repeater1.DataBind();
        //            break;
        //        default:
        //            empolyees = EmpolyeeManager.GetAllEmpolyee();
        //            Repeater1.DataSource = empolyees;
        //            Repeater1.DataBind();
        //            break;
        //    }
        //}
    }
}