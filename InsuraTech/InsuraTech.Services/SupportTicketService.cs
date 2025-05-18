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
using MapsterMapper;

namespace InsuraTech.Services
{
    public class SupportTicketService : BaseCRUDServiceAsync<SupportTicketDTO, SupportTicketSearchObject, SupportTicket, SupportTicketInsertRequest, SupportTicketUpdateRequest>, ISupportTicketService
    {
        public SupportTicketService(InsuraTechContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<SupportTicket> AddFilter(SupportTicketSearchObject search, IQueryable<SupportTicket> query)
        {

            if (search?.ClientId != null && search?.ClientId>0)
            {
                query = query.Where(x => x.ClientId == search.ClientId);
            }
            if (search?.DateFrom != null)
            {
                query = query.Where(x => x.CreatedAt >= search.DateFrom);
            }
            if (search?.DateTo != null)
            {
                query = query.Where(x => x.CreatedAt <= search.DateTo);
            }
            if (search?.IsAnswered != null)
            {
                query = query.Where(x => x.IsAnswered == search.IsAnswered);
            }
            if (search?.IsClosed != null)
            {
                query = query.Where(x => x.IsClosed == search.IsClosed);
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        public override async Task BeforeInsertAsync(SupportTicketInsertRequest request, SupportTicket entity, CancellationToken cancellationToken = default)
        {
            entity.IsAnswered = false;
            entity.IsClosed = false;
            entity.CreatedAt = DateTime.Now;
        }
        public async Task<bool> CloseTicketAsync(int id, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<SupportTicket>();

            var ticket = await set.FindAsync(id, cancellationToken);
            if (ticket == null || ticket.IsDeleted)
                throw new Exception("Ticket not found.");

            if (ticket.IsClosed)
                return false;

            ticket.IsClosed = true;

            Context.SupportTickets.Update(ticket);
            await Context.SaveChangesAsync(cancellationToken);

            return true;
        }

    }

}
