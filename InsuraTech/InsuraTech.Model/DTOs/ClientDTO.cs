using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class ClientDTO
    {
        public int ClientId { get; set; }
        public string Username { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string? PhoneNumber { get; set; }
        public bool IsActive { get; set; }
        public byte[]? ProfilePicture { get; set; }
        public DateTime RegistrationDate { get; set; }
        public bool IsDeleted { get; set; }
    }
}
