using System;
using System.Collections.Generic;
using System.Text;
using InsuraTech.Model.DTOs;

namespace InsuraTech.Model.Requests
{
    public class ClaimRequestInsertRequest
    {
        public int InsurancePolicyId { get; set; }
        public string Description { get; set; }
        public decimal EstimatedAmount { get; set; }
    }
}
