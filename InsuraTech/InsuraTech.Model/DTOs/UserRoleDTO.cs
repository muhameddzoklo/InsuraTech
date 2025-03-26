using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.DTOs
{
    public class UserRoleDTO
    {
        public int UserRoleId { get; set; }

        public int UserId { get; set; }

        public int RoleId { get; set; }

        public DateTime ChangeDate { get; set; }

        public virtual RoleDTO Role { get; set; } = null!;
    }
}
