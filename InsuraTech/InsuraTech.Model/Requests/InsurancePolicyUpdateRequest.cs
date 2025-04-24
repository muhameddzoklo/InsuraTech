using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class InsurancePolicyUpdateRequest
    {

        public DateTime StartDate { get; set; }
        public bool IsActive { get; set; }
        public DateTime EndDate { get; set; }
    }
}
