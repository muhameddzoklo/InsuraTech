using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using InsuraTech.Services.Database;

namespace InsuraTech.Services
{
    public interface ISupportTicketService : ICRUDServiceAsync<SupportTicketDTO, SupportTicketSearchObject, SupportTicketInsertRequest, SupportTicketUpdateRequest>
    {
        Task<bool> CloseTicketAsync(int id, CancellationToken cancellationToken = default);
    }


}
