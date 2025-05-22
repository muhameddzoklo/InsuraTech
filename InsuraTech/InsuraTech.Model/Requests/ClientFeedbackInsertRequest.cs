using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class ClientFeedbackInsertRequest
    {
        public int InsurancePolicyId { get; set; }
        public int Rating { get; set; }
        public string? Comment { get; set; }
    }
}
