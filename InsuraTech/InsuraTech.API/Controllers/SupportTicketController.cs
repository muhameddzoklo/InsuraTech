using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{
    public class SupportTicketController : BaseCRUDControllerAsync<SupportTicketDTO, SupportTicketSearchObject, SupportTicketInsertRequest, SupportTicketUpdateRequest>
    {
        public SupportTicketController(ISupportTicketService service) : base(service)
        {

        }
        [HttpPatch("{id}/close")]
        public async Task<IActionResult> CloseTicket(int id)
        {
            try
            {
                var result = await (_service as ISupportTicketService).CloseTicketAsync(id);
                return result
                    ? Ok("Ticket closed successfully.")
                    : BadRequest("Ticket is already closed.");
            }
            catch (Exception ex)
            {
                return NotFound(ex.Message);
            }
        }
    }

}
