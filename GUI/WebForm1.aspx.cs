using BUS;
using DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GUI
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Message item = new Message();
            // item.Content n
            MessageManager.InsertMessage(item);


            List<Message> lstMessage = MessageManager.GetListMessage();


        }
    }
}