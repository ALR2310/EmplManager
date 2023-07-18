using BUS;
using DAL;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Diagnostics;
using System.Linq;

public class CustomAuthorizationModule : HubPipelineModule
{
    protected override bool OnBeforeIncoming(IHubIncomingInvokerContext context)
    {
        var hubDescriptor = context.MethodDescriptor.Hub;

        Debug.WriteLine("Checking authorization");
        if (hubDescriptor.HubType.GetCustomAttributes(typeof(AuthorizeAttribute), inherit: true).Any())
        {
            var request = context.Hub.Context.Request;


            string authToken = request.Cookies["authToken"].Value;
            if (authToken == null || authToken.Length == 0)
            {
                throw new HubException("Unauthorized");
            }
            int? userId = UserManager.getTokenUserId(authToken);
            if (userId != null)
            {

                return base.OnBeforeIncoming(context);
            }

            throw new HubException("Unauthorized");

        }

        // Continue processing for non-authorized hubs
        return base.OnBeforeIncoming(context);
    }
}
