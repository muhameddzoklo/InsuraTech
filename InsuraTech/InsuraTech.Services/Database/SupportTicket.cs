using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlTypes;

namespace InsuraTech.Services.Database
{
    public partial class SupportTicket : BaseEntity
    {
        [Key]
        public int SupportTicketId { get; set; }
        public int ClientId { get; set; }
        [ForeignKey("ClientId")]
        public virtual Client Client { get; set; } = null!;
        public string Subject { get; set; } = null!;
        public string Message { get; set; } = null!;
        public string? Reply { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsAnswered { get; set; }
        public bool IsClosed { get; set; }
    }

}
