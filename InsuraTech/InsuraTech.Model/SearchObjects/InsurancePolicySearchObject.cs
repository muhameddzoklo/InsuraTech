using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class InsurancePolicySearchObject:BaseSearchObject
    {
        public DateTime? StartDateGTE { get; set; }

        public DateTime? EndDateLTE { get; set; }
        public string? ClientUsernameGTE { get; set; }
        public int InsurancePackageId { get; set; } 
    }
}
