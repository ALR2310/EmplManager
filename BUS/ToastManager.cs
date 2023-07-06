using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;

namespace BUS
{
    public class ToastManager
    {
        public static void SuccessToast(string message)
        {
            //ScriptManager.RegisterClientScriptBlock(this, GetType(), "myToast", "showSuccessToast(' " + message + " ')", true);
        }
    }
}
