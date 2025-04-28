using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class ClaimRequestDTO
    {
        public int ClaimRequestId { get; set; }
        public int InsurancePolicyId { get; set; }
        public InsurancePolicyDTO insurancePolicy { get; set; }
        public string Description { get; set; } = null!;
        public string? Comment { get; set; }
        public decimal EstimatedAmount { get; set; }
        public string Status { get; set; } = null!;
        public DateTime? SubmittedAt { get; set; }
    }
}
