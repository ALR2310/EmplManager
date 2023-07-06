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
            var currentPage = HttpContext.Current.Handler as Page;
            ScriptManager.RegisterClientScriptBlock(currentPage, typeof(ToastManager), "myToast", "showSuccessToast(' " + message + " ')", true);
        }

        public static void InfoToast(string message)
        {
            var currentPage = HttpContext.Current.Handler as Page;
            ScriptManager.RegisterClientScriptBlock(currentPage, typeof(ToastManager), "myToast", "showInfoToast('" + message + "')", true);
        }

        public static void WaringToast(string message)
        {
            var currentPage = HttpContext.Current.Handler as Page;
            ScriptManager.RegisterClientScriptBlock(currentPage, typeof(ToastManager), "myToast", "showWarningToast('" + message + "')", true);
        }

        public static void ErrorToast(string message)
        {
            var currentPage = HttpContext.Current.Handler as Page;
            ScriptManager.RegisterClientScriptBlock(currentPage, typeof(ToastManager), "myToast", "showErrorToast('" + message + "')", true);
        }
    }

}
