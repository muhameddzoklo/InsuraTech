using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services
{
    public interface ILoyaltyProgramService : ICRUDServiceAsync<LoyaltyProgramDTO, LoyaltyProgramSearchObject, LoyaltyProgramInsertRequest, LoyaltyProgramUpdateRequest>
    {

    }

}
