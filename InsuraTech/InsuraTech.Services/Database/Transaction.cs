﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class Transaction:BaseEntity
    {
        [Key]
        public int TransactionId { get; set; }
        public double Amount { get; set; }
        public DateTime? TransactionDate { get; set; }
        public string? PaymentMethod { get; set; }
        public string? PaymentId { get; set; }
        public string? PayerId { get; set; }
        public int ClientId { get; set; }
        [ForeignKey("ClientId")]
        public virtual Client Client { get; set; } = null!;
        public int InsurancePolicyId { get; set; }
        [ForeignKey("InsurancePolicyId")]
        public virtual InsurancePolicy InsurancePolicy { get; set; } = null!;

    }

}
