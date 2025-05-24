using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;

namespace InsuraTech.API.Controllers
{
    public class LoyaltyProgramController : BaseCRUDControllerAsync<LoyaltyProgramDTO, LoyaltyProgramSearchObject, LoyaltyProgramInsertRequest, LoyaltyProgramUpdateRequest>
    {
        public LoyaltyProgramController(ILoyaltyProgramService service) : base(service)
        {
        }

    }
}
