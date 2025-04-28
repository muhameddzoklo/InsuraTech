using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{
    [ApiController]
    public class ClaimRequestController : BaseCRUDControllerAsync<ClaimRequestDTO, ClaimRequestSearchObject, ClaimRequestInsertRequest, ClaimRequestUpdateRequest>
    {
        public ClaimRequestController(IClaimRequestService service) : base(service)
        {
        }

    }
}
