using InsuraTech.Model.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services
{
    public interface IReportService
    {
        Task<ReportDTO> GetReportAsync(CancellationToken cancellationToken = default);
    }
}
