using InsuraTech.Services.Enums;
using System;
using System.Collections.Generic;
using System.Text;


namespace InsuraTech.Model.DTOs
{
    public class LoyaltyProgramDTO
    {
        public int LoyaltyProgramId { get; set; }
        public int ClientId { get; set; }
        public virtual ClientDTO Client { get; set; } = null!;
        public int Points { get; set; } = 0;
        public LoyaltyTier Tier { get; set; } = LoyaltyTier.Bronze;

        public DateTime LastUpdated { get; set; } = DateTime.Now;
    }
}
