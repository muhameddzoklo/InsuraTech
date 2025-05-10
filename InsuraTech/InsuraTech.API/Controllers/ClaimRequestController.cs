using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{
    public class ClaimRequestController : BaseCRUDControllerAsync<ClaimRequestDTO, ClaimRequestSearchObject, ClaimRequestInsertRequest, ClaimRequestUpdateRequest>
    {
        public ClaimRequestController(IClaimRequestService service) : base(service)
        {
        }
        [HttpGet("status-options")]
        public IActionResult GetStatusOptions()
        {
            var statusOptions = new List<string>
            {
                "In progress",
                "Accepted",
                "Declined"
            };

            return Ok(statusOptions);
        }

    }
}
