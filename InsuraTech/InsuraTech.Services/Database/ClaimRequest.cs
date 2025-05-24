using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class ClaimRequest:BaseEntity
    {
        public int ClaimRequestId { get; set; }
        public int InsurancePolicyId { get; set; }
        [ForeignKey("InsurancePolicyId")]
        public virtual InsurancePolicy insurancePolicy { get; set; } = null!;
        public int? UserId { get; set; }
        [ForeignKey("UserId")]
        public virtual User? User { get; set; }
        public string Description { get; set; } =null!;
        public string? Comment { get; set; }
        [Required]
        public decimal EstimatedAmount { get; set; }
        public string Status { get; set; } = null!;
        public DateTime? SubmittedAt { get; set; }
        }

}
