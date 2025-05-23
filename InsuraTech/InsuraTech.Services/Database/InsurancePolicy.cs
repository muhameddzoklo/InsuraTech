﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class InsurancePolicy:BaseEntity
    {
        public int InsurancePolicyId { get; set; }

        public int InsurancePackageId { get; set; }
        [ForeignKey("InsurancePackageId")]
        public virtual InsurancePackage InsurancePackage { get; set; } = null!;

        public int ClientId { get; set; }
        [ForeignKey("ClientId")]
        public virtual Client Client { get; set; } = null!;

        public DateTime StartDate { get; set; }

        public DateTime EndDate { get; set; }

        public bool IsActive { get; set; }
        public bool HasActiveClaimRequest { get; set; }
        public bool IsNotificationSent { get; set; }
        public bool IsPaid { get; set; }
        public ICollection<ClaimRequest> ClaimRequests { get; set; } = new List<ClaimRequest>();
        public ICollection<Transaction> Transactions { get; set; } = new List<Transaction>();
    }

}
