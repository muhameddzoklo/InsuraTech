using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class Client : BaseEntity
    {
        [Key]
        public int ClientId { get; set; }
        [MaxLength(100)]
        public string Username { get; set; } = null!;
        [MaxLength(100)]
        public string FirstName { get; set; } = null!;
        [MaxLength(100)]
        public string LastName { get; set; } = null!;
        [EmailAddress]
        public string Email { get; set; } = null!;
        public string? PhoneNumber { get; set; }
        public string PasswordHash { get; set; } = null!;
        public string PasswordSalt { get; set; } = null!;
        public byte[]? ProfilePicture { get; set; }
        public DateTime RegistrationDate { get; set; }
        public bool IsActive { get; set; }
        public ICollection<SupportTicket> SupportTickets { get; set; } = new List<SupportTicket>();
        public ICollection<ClientFeedback> ClientFeedbacks { get; set; } = new List<ClientFeedback>();
    }
}
