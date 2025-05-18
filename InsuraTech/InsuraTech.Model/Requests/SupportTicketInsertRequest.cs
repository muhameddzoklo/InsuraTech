using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class SupportTicketInsertRequest
    {
        public int ClientId { get; set; }
        public string Subject { get; set; } = null!;
        public string Message { get; set; } = null!;
    }
}
