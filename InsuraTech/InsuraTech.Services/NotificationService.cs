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
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;

namespace InsuraTech.Services
{
    public class NotificationService : BaseCRUDServiceAsync<NotificationDTO, NotificationSearchObject, Notification, NotificationInsertRequest, NotificationUpdateRequest>, INotificationService
    {
        IInsurancePolicyService _policyService;

       // private readonly IHubContext<NotificationHub> _hubContext;
        public NotificationService(InsuraTechContext context, IMapper mapper, IInsurancePolicyService policyService ) : base(context, mapper)
        {
            _policyService = policyService;
        }
        public override IQueryable<Notification> AddFilter(NotificationSearchObject search, IQueryable<Notification> query)
        {
            if (search.ClientId > 0)
            {
                query=query.Where(x=>x.ClientId == search.ClientId);
            }
            if (search.ShowUnread == true)
            {
                query = query.Where(x => x.IsRead == false);
            }
            query = query.Where(x => !x.IsDeleted).Include(x=>x.InsurancePolicy).ThenInclude(x=>x.InsurancePackage);



            return query;
        }

        public override async Task BeforeInsertAsync(NotificationInsertRequest request, Notification entity, CancellationToken cancellationToken = default)
        {
            var policy = await Context.Set<InsurancePolicy>().FirstOrDefaultAsync(x => x.InsurancePolicyId == request.InsurancePolicyId);
            entity.IsRead = false;
            entity.SentAt = DateTime.Now;
            entity.Message = "Your policy is expiring on: " + policy.EndDate.ToString("dd.MM.yyyy");
        }
        public override async Task AfterInsertAsync(NotificationInsertRequest request, Notification entity, CancellationToken cancellationToken = default)
        {
            var policy = await Context.Set<InsurancePolicy>().FirstOrDefaultAsync(x => x.InsurancePolicyId == request.InsurancePolicyId);
            var policyUpdatRequest = new InsurancePolicyUpdateRequest
            {
                StartDate = policy.StartDate,
                EndDate = policy.EndDate,
                IsActive = policy.IsActive,
                HasClaimRequest = policy.HasActiveClaimRequest,
                IsNotificationSent = true
            };
           await _policyService.UpdateAsync(request.InsurancePolicyId, policyUpdatRequest, cancellationToken);
        }
        public override async Task BeforeUpdateAsync(NotificationUpdateRequest request, Notification entity, CancellationToken cancellationToken = default) 
        {
            entity.IsRead= true;
        }
    }
}
