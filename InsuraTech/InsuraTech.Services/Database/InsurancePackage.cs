using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class InsurancePackage : BaseEntity
    {
        public int InsurancePackageId { get; set; }

        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public decimal Price { get; set; }

        public byte[]? Picture { get; set; }
        public string StateMachine { get; set; } = null!;
        [Required]
        public int DurationDays { get; set; }

        public ICollection<InsurancePolicy> Policies { get; set; } = new List<InsurancePolicy>();
        public ICollection<ClientFeedback> ClientFeedbacks { get; set; } = new List<ClientFeedback>();
    }

}
