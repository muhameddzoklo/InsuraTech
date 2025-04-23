using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public  class InsurancePackageInsertRequest
    {
        public string Name { get; set; } = null!;

        public string Description { get; set; } = null!;

        public decimal Price { get; set; } = 0.00m;

        public byte[]? Picture { get; set; }
        public int DurationDays { get; set; }
    }
}
