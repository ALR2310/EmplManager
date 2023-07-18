
using Microsoft.Owin;
using Owin;
using System;

using System.Web.Routing;
using SignalRChat.Hubs;
using Microsoft.AspNet.SignalR;

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
            //GlobalHost.HubPipeline.AddModule(new CustomAuthorizationModule());
            RouteTable.Routes.MapPageRoute("", "", "~/Message.aspx");


        }
    }
}