using InsuraTech.Model.DTOs;
using InsuraTech.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{
    [Authorize]
    [ApiController]
    [Route("api/[controller]")]
    public class ReportsController : ControllerBase
    {
        private readonly IReportService _reportService;

        public ReportsController(IReportService reportService)
        {
            _reportService = reportService;
        }


        [HttpGet]
        public async Task<ActionResult<ReportDTO>> GetReport(CancellationToken cancellationToken)
        {
            var report = await _reportService.GetReportAsync(cancellationToken);
            return Ok(report);
        }
    }
}
