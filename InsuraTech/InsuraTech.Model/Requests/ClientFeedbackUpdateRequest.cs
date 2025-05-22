using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.Requests
{
    public class ClientFeedbackUpdateRequest
    {
        public int Rating { get; set; }
        public string? Comment { get; set; }
    }
}
