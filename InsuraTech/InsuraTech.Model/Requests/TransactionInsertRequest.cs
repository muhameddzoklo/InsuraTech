using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class TransactionInsertRequest
    {
        public double Amount { get; set; }
        public string? PaymentMethod { get; set; }
        public string? PaymentId { get; set; }
        public string? PayerId { get; set; }
        public int ClientId { get; set; }
        public int InsurancePolicyId { get; set; }
    }
}
