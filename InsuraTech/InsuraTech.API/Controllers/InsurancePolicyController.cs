using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{
    [ApiController]
    public class InsurancePolicyController : BaseCRUDControllerAsync<InsurancePolicyDTO, InsurancePolicySearchObject, InsurancePolicyInsertRequest, InsurancePolicyUpdateRequest>
    {
        public InsurancePolicyController(IInsurancePolicyService service) : base(service)
        {
        }
        [HttpPost("checkExpiery")]
        public void CheckExpiery(DateTime currentDate)
        {
            (_service as IInsurancePolicyService).CheckExpiery(currentDate);
        }
    }
}
