using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class ClientFeedback : BaseEntity
    {
        [Key]
        public int ClientFeedbackId { get; set; }
        public int InsurancePackageId { get; set; }
        [ForeignKey("InsurancePackageId")]
        public virtual InsurancePackage InsurancePackage { get; set; } = null!;
        public int InsurancePolicyId { get; set; }
        [ForeignKey("InsurancePolicyId")]
        public virtual InsurancePolicy InsurancePolicy { get; set; } = null!;
        public int ClientId { get; set; }
        [ForeignKey("ClientId")]
        public virtual Client Client { get; set; } = null!;

        [Range(1, 5)]
        public int Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
    }


}
