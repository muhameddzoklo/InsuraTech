﻿using System;
using System.Collections.Generic;
using System.Text;

namespace InsuraTech.Model.SearchObjects
{
    public class ClientSearchObject:BaseSearchObject
    {
        public string? FirstNameGTE { get; set; }

        public string? LastNameGTE { get; set; }

        public string? FirstLastNameGTE { get; set; }

        public string? EmailGTE { get; set; }

        public string? PhoneNumber { get; set; }

        public string? Username { get; set; }
    }
}
