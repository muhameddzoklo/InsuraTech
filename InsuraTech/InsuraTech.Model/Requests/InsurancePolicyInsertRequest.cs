using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class InsurancePolicyInsertRequest
    {
        
        public int InsurancePackageId { get; set; } 
        public int ClientId { get; set; }
        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }
    }
}
