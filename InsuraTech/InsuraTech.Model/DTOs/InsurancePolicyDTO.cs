using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public  class InsurancePolicyDTO 
    {
        public int InsurancePolicyId { get; set; }
        public int InsurancePackageId { get; set; }
        public int ClientId { get; set; }
        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public bool IsActive { get; set; }
        public bool HasActiveClaimRequest { get; set; }
        public bool IsNotificationSent { get; set; }
        public bool IsPaid { get; set; }
        public InsurancePackageDTO InsurancePackage { get; set; }
        public ClientDTO Client { get; set; }
       // public ICollection<ClaimRequestDTO> ClaimRequests { get; set; } = new List<ClaimRequestDTO>();
    }
}
