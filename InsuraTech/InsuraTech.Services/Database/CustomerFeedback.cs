using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Database
{
    public partial class CustomerFeedback:BaseEntity
    {
        public int CustomerFeedbackId { get; set; }
        public int UserId { get; set; }
        [ForeignKey("UserId")]
        public virtual User User { get; set; } = null!;
        [Range(1, 5)]
        public int? Rating { get; set; }
        public DateTime? SubmittedAt { get; set; }
        }

}
