using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class ClaimRequestUpdateRequest
    {
        public string? Comment { get; set; }
        public decimal? EstimatedAmount { get; set; }
        public bool? IsAccepted { get; set; }
        public int? UserId { get; set; }
    }
}
