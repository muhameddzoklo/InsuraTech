using InsuraTech.Services.Enums;
using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class LoyaltyProgramUpdateRequest
    {
        public int? Points { get; set; }
        public LoyaltyTier? Tier { get; set; }

    }
}
