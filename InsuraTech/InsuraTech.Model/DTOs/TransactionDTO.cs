using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class TransactionDTO
    {
        public int TransactionId { get; set; }
        public double Amount { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string? PaymentMethod { get; set; }
        public string? PaymentId { get; set; }
        public string? PayerId { get; set; }
        public int ClientId { get; set; }
        public virtual ClientDTO? Client { get; set; }
        public int InsurancePolicyId { get; set; }
        public virtual InsurancePolicyDTO? InsurancePolicy { get; set; }
    }
}
