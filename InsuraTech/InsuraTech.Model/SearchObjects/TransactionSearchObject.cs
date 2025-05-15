using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class TransactionSearchObject : BaseSearchObject
    {
        public int? ClientId { get; set; }
        public string? ClientName { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}
