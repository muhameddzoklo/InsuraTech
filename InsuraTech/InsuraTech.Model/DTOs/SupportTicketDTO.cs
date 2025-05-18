using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class SupportTicketDTO
    {
        public int SupportTicketId { get; set; }
        public int ClientId { get; set; }
        public string Subject { get; set; } = null!;
        public string Message { get; set; } = null!;
        public string? Reply { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsAnswered { get; set; }
        public bool IsClosed { get; set; }
    }
}
