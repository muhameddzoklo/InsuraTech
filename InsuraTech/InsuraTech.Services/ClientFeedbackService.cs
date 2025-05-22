using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Exceptions;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using InsuraTech.Services.Database;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace InsuraTech.Services
{
    public class ClientFeedbackService : BaseCRUDServiceAsync<ClientFeedbackDTO, ClientFeedbackSearchObject, ClientFeedback, ClientFeedbackInsertRequest, ClientFeedbackUpdateRequest>, IClientFeedbackService
    {
        public ClientFeedbackService(InsuraTechContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<ClientFeedback> AddFilter(ClientFeedbackSearchObject search, IQueryable<ClientFeedback> query)
        {

            if (search.InsurancePackageId.HasValue)
                query = query.Where(r => r.InsurancePackageId == search.InsurancePackageId.Value);

            if (search.ClientId.HasValue)
                query = query.Where(r => r.ClientId == search.ClientId.Value);

            if (search.InsurancePolicyId.HasValue)
                query = query.Where(r => r.InsurancePolicyId == search.InsurancePolicyId.Value);

            if (search.Rating.HasValue)
                query = query.Where(r => r.Rating >= search.Rating.Value);

            if (!string.IsNullOrWhiteSpace(search.PackageNameGTE))
                query = query.Where(r =>
                    (r.InsurancePackage.Name).ToLower().Contains(search.PackageNameGTE.ToLower())
                );

            if (!string.IsNullOrWhiteSpace(search.ClientNameGTE))
                query = query.Where(r =>
                    (r.Client.FirstName + " " + r.Client.LastName).ToLower().Contains(search.ClientNameGTE.ToLower())
                );

            if (search.CreatedAfter.HasValue)
                query = query.Where(r => r.CreatedAt >= search.CreatedAfter.Value);

            if (search.CreatedBefore.HasValue)
                query = query.Where(r => r.CreatedAt <= search.CreatedBefore.Value);

            if (search.isDeleted == true)
            {
                return query.Include(r => r.InsurancePackage)
                        .Include(r => r.Client)
                        .Include(r => r.InsurancePolicy);
            }
            query = query.Where(r => !r.IsDeleted);

            return query.Include(r => r.InsurancePackage)
                         .Include(r => r.Client)
                         .Include(r => r.InsurancePolicy);
        }
       

        public override async Task BeforeInsertAsync(ClientFeedbackInsertRequest request, ClientFeedback entity, CancellationToken cancellationToken = default)
        {
            var policy = await Context.InsurancePolicies
                .AsNoTracking()
                .FirstOrDefaultAsync(a => a.InsurancePolicyId == request.InsurancePolicyId, cancellationToken);

            if (policy == null)
                throw new UserException("Policy not found.");

            if (!policy.IsPaid)
                throw new UserException("Feedback can only be left for paid policies.");

            var hasFeedback = await Context.ClientFeedbacks
                .AnyAsync(r => r.InsurancePolicyId == request.InsurancePolicyId, cancellationToken);

            if (hasFeedback)
                throw new UserException("Feedback for this policy already exists.");

            entity.InsurancePackageId = policy.InsurancePackageId;
            entity.ClientId = policy.ClientId;
            entity.InsurancePolicyId = policy.InsurancePolicyId;

            entity.CreatedAt = DateTime.Now;
        }

    }

}
