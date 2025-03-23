using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class InsurancePackageClaim:BaseEntity
    {
        public int InsurancePackageClaimId { get; set; }
        public int InsurancePackageId { get; set; }
        [ForeignKey("InsurancePackageId")]
        public virtual InsurancePackage InsurancePackage { get; set; } = null!;
        public int ClaimRequestId { get; set; }
        [ForeignKey("ClaimRequestId")]
        public virtual ClaimRequest ClaimRequest { get; set; } = null!;
        public DateTime? ClaimDate { get; set; }
        public decimal? ClaimAmount { get; set; }

        }

}
