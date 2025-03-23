using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class InsurancePackageUpsertRequest
    {
        public string Name { get; set; } = null!;
        public decimal? Price { get; set; }
    }
}
