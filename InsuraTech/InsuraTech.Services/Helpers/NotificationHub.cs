using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;

namespace InsuraTech.Services.Helpers
{
    public class NotificationHub:Hub
    {
        public override Task OnConnectedAsync()
        {
            var userId = Context.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;
            if (userId != null)
            {
                Groups.AddToGroupAsync(Context.ConnectionId, userId);
            }

            return base.OnConnectedAsync();
        }
    }
}
