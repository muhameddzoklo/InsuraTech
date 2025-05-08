using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class NotificationInsertRequest
    {
        public int ClientId { get; set; }
        public int InsurancePolicyId { get; set; }
    }
}
