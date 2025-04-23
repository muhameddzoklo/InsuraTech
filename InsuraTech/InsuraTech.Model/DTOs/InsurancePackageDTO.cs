using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class InsurancePackageDTO
    {
        public int InsurancePackageId { get; set; }

        public string? Name { get; set; }

        public string? Description { get; set; }

        public decimal Price { get; set; }

        public byte[]? Picture { get; set; }

        public string? StateMachine { get; set; }
        public int DurationDays { get; set; }
    }
}
