using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class InsurancePolicy:BaseEntity
    {
        public int InsurancePolicyId { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
        public int InsurancePackageId { get; set; }
        [ForeignKey("InsurancePackageId")]
        public virtual InsurancePackage InsurancePackage { get; set; } = null!;
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public decimal? PremiumAmount { get; set; }
    }

}
