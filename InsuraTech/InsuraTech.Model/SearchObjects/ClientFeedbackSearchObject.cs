using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class ClientFeedbackSearchObject:BaseSearchObject
    {
        public int? InsurancePackageId { get; set; }
        public int? ClientId { get; set; }
        public int? InsurancePolicyId { get; set; }
        public int? Rating { get; set; }
        public string? PackageNameGTE { get; set; }
        public string? ClientNameGTE { get; set; }
        public DateTime? CreatedAfter { get; set; }
        public DateTime? CreatedBefore { get; set; }
        public bool isDeleted { get; set; }
    }
}
