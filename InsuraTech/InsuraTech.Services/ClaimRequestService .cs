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
using Microsoft.EntityFrameworkCore;

namespace InsuraTech.Services
{
    public class ClaimRequestService : BaseCRUDServiceAsync<ClaimRequestDTO, ClaimRequestSearchObject, ClaimRequest, ClaimRequestInsertRequest, ClaimRequestUpdateRequest>, IClaimRequestService
    {
        
        public ClaimRequestService(InsuraTechContext context, IMapper mapper) : base(context, mapper)
        {
        
        }
        public override IQueryable<ClaimRequest> AddFilter(ClaimRequestSearchObject search, IQueryable<ClaimRequest> query)
        {
            if (!string.IsNullOrEmpty(search?.UsernameGTE))
            {
                query = query.Where(x => x.insurancePolicy.Client.Username.ToLower().StartsWith(search.UsernameGTE.ToLower()));
            }

            if (search?.StartDate.HasValue == true)
            {
                query = query.Where(x => x.SubmittedAt >= search.StartDate.Value);
            }

            if (search?.EndDate.HasValue == true)
            {
                query = query.Where(x => x.SubmittedAt <= search.EndDate.Value);
            }

            if (search?.InsurancePackageId > 0)
            {
                query = query.Where(x => x.insurancePolicy.InsurancePackageId == search.InsurancePackageId);
            }
            if (search?.Username != null)
            {
                query = query.Where(x => x.insurancePolicy.Client.Username == search.Username);
            }

            query = query
                    .Where(x => !x.IsDeleted)
                    .Include(x => x.insurancePolicy)
                        .ThenInclude(u => u.Client)
                    .Include(x => x.insurancePolicy)
                        .ThenInclude(p => p.InsurancePackage);
           
            return query;
        }

        public override async Task BeforeInsertAsync(ClaimRequestInsertRequest request, ClaimRequest entity, CancellationToken cancellationToken=default) 
        {
            entity.Status = "In progress";
            entity.SubmittedAt = DateTime.Now;
           
        }
        public override async Task AfterInsertAsync(ClaimRequestInsertRequest request, ClaimRequest entity, CancellationToken cancellationToken = default)
        {
            var policy = await Context.Set<InsurancePolicy>().FirstOrDefaultAsync(x=>x.InsurancePolicyId==request.InsurancePolicyId);
            if (policy != null)
            {
                policy.HasActiveClaimRequest = true;
                await Context.SaveChangesAsync();
            }
          
        }
        public override async Task AfterUpdateAsync(ClaimRequestUpdateRequest request, ClaimRequest entity, CancellationToken cancellationToken = default)
        {
            var policy = await Context.Set<InsurancePolicy>().FirstOrDefaultAsync(x => x.InsurancePolicyId == entity.InsurancePolicyId);
            if (policy != null)
            {
                policy.HasActiveClaimRequest = false;
                await Context.SaveChangesAsync();
            }

        }



    }
}
