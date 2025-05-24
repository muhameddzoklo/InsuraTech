using InsuraTech.Services.Enums;
using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class LoyaltyProgramSearchObject:BaseSearchObject
    {
        public string? ClientNameGTE { get; set; }
        public int? ClientId { get; set; }
        public LoyaltyTier? Status { get; set; }
    }
}
