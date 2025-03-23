using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class UserFeedback
    {
        public int UserFeedbackId { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        
        public int CustomerFeedbackId { get; set; }
        [ForeignKey ("CustomerFeedbackId")]

        public virtual User User { get; set; } = null!;
        public virtual CustomerFeedback CustomerFeedback { get; set; } = null!;
    }

}
