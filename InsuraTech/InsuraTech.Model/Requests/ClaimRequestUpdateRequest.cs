using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class ClaimRequestUpdateRequest
    {
        public string? Comment { get; set; }
        public decimal? EstimatedAmount { get; set; }
        public string? Status { get; set; }
    }
}
