using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class PaymentMethod:BaseEntity
    {
        public int PaymentMethodId { get; set; }
        public string? MethodName { get; set; }
    }

}
