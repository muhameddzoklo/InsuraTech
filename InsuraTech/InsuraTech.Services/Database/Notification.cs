using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class Notification : BaseEntity
    {
        public int NotificationId { get; set; }

        public int ClientId { get; set; }
        public virtual Client Client { get; set; } = null!;
        public int? UserId { get; set; }
        [ForeignKey("UserId")]
        public virtual User? User { get; set; }

        public int InsurancePolicyId { get; set; }
        public virtual InsurancePolicy InsurancePolicy { get; set; } = null!;
        public string? Message { get; set; }
        public DateTime? SentAt { get; set; }
        public bool? IsRead { get; set; }
    }

}
