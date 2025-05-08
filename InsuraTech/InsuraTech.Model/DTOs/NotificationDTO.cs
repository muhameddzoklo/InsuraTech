using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class NotificationDTO
    {
        public int NotificationId { get; set; }

        public int ClientId { get; set; }
        public ClientDTO Client { get; set; } = null!;
        public int InsurancePolicyId { get; set; }
        public InsurancePolicyDTO InsurancePolicy { get; set; } = null!;
        public string? Message { get; set; }
        public DateTime? SentAt { get; set; }
        public bool? IsRead { get; set; }
    }
}
