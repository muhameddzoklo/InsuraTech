using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class SupportTicketSearchObject:BaseSearchObject
    {
        public int? ClientId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public bool? IsAnswered { get; set; }
        public bool? IsClosed { get; set; }

    }
}
