using BUS;
using DAL.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
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

        protected void ShowModalInfor_ServerClick(object sender, EventArgs e)
        {
            HtmlAnchor link = (HtmlAnchor)sender;
            string commandArgument = link.Attributes["commandargument"];
            int userId = Convert.ToInt32(commandArgument);

            EmpolyeeInfor empolyeeInfor = EmpolyeeManager.GetEmpolyeeById(userId);

            AvatarImg.ImageUrl = empolyeeInfor.Avatar;
            lblDisplayName.Text = empolyeeInfor.DisplayName;
            lblDisplayName1.Text = empolyeeInfor.DisplayName;
            lblJob.Text = empolyeeInfor.Job;
            lblJob1.Text = empolyeeInfor.Job;
            lblPhoneNumber.Text = empolyeeInfor.PhoneNumber;
            lblEmail.Text = empolyeeInfor.Email;
            lblDateJoin.Text = empolyeeInfor.AtCreate.ToString("dd/MM/yyyy");
            lblDepartment.Text = empolyeeInfor.Department;
            lblGender.Text = empolyeeInfor.Gender;
            lblDateOfBirth.Text = empolyeeInfor.DateOfBirth.ToString("dd/MM/yyyy");


            switch (empolyeeInfor.Status)
            {
                case 0:
                    lblStatus.Text = "Disable";
                    lblStatus.Style.Add("color", "red");
                    break;
                case 1:
                    lblStatus.Text = "Active";
                    lblStatus.Style.Add("color", "green");
                    break;
                case 2:
                    lblStatus.Text = "Not Actived";
                    lblStatus.Style.Clear();
                    break;
            }

            switch (empolyeeInfor.UserType)
            {
                case 0:
                    lblUserType.Text = "Quản Trị Viên";
                    break;
                case 1:
                    lblUserType.Text = "Nhân Viên";
                    break;
            }
        }

        protected void ShowModalInfor_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "showinfor", "showModal()", true);

            LinkButton linkButton = (LinkButton)sender;
            int userId = Convert.ToInt32(linkButton.CommandArgument);

            //Button button = (Button)sender;
            //int userId = Convert.ToInt32(button.CommandArgument);

            EmpolyeeInfor empolyeeInfor = EmpolyeeManager.GetEmpolyeeById(userId);

            AvatarImg.ImageUrl = empolyeeInfor.Avatar;
            lblDisplayName.Text = empolyeeInfor.DisplayName;
            lblDisplayName1.Text = empolyeeInfor.DisplayName;
            lblJob.Text = empolyeeInfor.Job;
            lblJob1.Text = empolyeeInfor.Job;
            lblPhoneNumber.Text = empolyeeInfor.PhoneNumber;
            lblEmail.Text = empolyeeInfor.Email;
            lblDateJoin.Text = empolyeeInfor.AtCreate.ToString("dd/MM/yyyy");
            lblDepartment.Text = empolyeeInfor.Department;
            lblGender.Text = empolyeeInfor.Gender;
            lblDateOfBirth.Text = empolyeeInfor.DateOfBirth.ToString("dd/MM/yyyy");


            switch (empolyeeInfor.Status)
            {
                case 0:
                    lblStatus.Text = "Disable";
                    lblStatus.Style.Add("color", "red");
                    break;
                case 1:
                    lblStatus.Text = "Active";
                    lblStatus.Style.Add("color", "green");
                    break;
                case 2:
                    lblStatus.Text = "Not Actived";
                    lblStatus.Style.Clear();
                    break;
            }

            switch (empolyeeInfor.UserType)
            {
                case 0:
                    lblUserType.Text = "Quản Trị Viên";
                    break;
                case 1:
                    lblUserType.Text = "Nhân Viên";
                    break;
            }
        }
    }
}