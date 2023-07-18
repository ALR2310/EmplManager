
using Microsoft.Owin;
using Owin;
using System;

using System.Web.Routing;
using SignalRChat.Hubs;
[assembly: OwinStartup(typeof(GUI.Startup))]

namespace GUI
{

    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // Enable SignalR

            app.MapSignalR();
            

        }


    }

    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
         
            RouteTable.Routes.MapPageRoute("", "", "~/Message.aspx");


        }
    }
}