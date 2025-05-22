using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class ClientFeedbackDTO
    {
        public int ClientFeedbackId { get; set; }
        public int InsurancePackageId { get; set; }
        public int InsurancePolicyId { get; set; }
        public int ClientId { get; set; }

        public int Rating { get; set; }
        public string? Comment { get; set; }
        public DateTime CreatedAt { get; set; }
        public string? PackageName { get; set; }
        public string? ClientName { get; set; }
        public string? ClientProfilePicture { get; set; }
        public bool IsDeleted { get; set; }
    }
}
