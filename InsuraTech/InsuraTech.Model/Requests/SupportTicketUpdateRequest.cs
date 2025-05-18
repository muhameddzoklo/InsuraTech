using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class SupportTicketUpdateRequest
    {
        public string? Reply { get; set; }
        public bool IsAnswered { get; set; }
        public bool IsClosed { get; set; }
    }
}
