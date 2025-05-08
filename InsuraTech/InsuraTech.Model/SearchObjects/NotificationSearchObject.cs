using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class NotificationSearchObject:BaseSearchObject
    {
        public int? ClientId { get; set; }
        public bool? ShowUnread { get; set; } = false;
    }
}
