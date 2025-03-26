using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class UserUpdateRequest
    {
        public string? FirstName { get; set; }

        public string? LastName { get; set; }

        public string? PhoneNumber { get; set; }

        public string? CurrentPassword { get; set; }

        public string? Password { get; set; }

        public string? PasswordConfirmation { get; set; }
    }
}
