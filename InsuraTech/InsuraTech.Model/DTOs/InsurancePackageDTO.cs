using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class InsurancePackageDTO
    {
        public int InsurancePackageId { get; set; }

        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public decimal Price { get; set; }

        public byte[]? Picture { get; set; }

        //public ICollection<InsurancePolicy> Policies { get; set; } = new List<InsurancePolicy>();
    }
}
