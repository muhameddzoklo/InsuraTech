using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class ClaimRequestSearchObject:BaseSearchObject
    {
        public string? Username { get; set; }
        public string? UsernameGTE { get; set; }
        public int? InsurancePackageId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string? Status { get; set; }
    }
}
