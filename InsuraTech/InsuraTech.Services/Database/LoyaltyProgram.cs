using InsuraTech.Services.Enums;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class LoyaltyProgram:BaseEntity
    {
        [Key]
        public int LoyaltyProgramId { get; set; }
        public int ClientId { get; set; }
        [ForeignKey("ClientId")]
        public virtual Client Client { get; set; } = null!;
        public int Points { get; set; } = 0;

        [Required]
        public LoyaltyTier Tier { get; set; } = LoyaltyTier.Bronze;

        public DateTime LastUpdated { get; set; } = DateTime.Now;
    }
}
