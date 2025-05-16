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
    public class InsurancePolicyService : BaseCRUDServiceAsync<InsurancePolicyDTO, InsurancePolicySearchObject, InsurancePolicy, InsurancePolicyInsertRequest, InsurancePolicyUpdateRequest>, IInsurancePolicyService
    {
        private readonly ITransactionService _transactionService;
        public InsurancePolicyService(InsuraTechContext context, IMapper mapper, ITransactionService transactionService ) : base(context, mapper)
        {
            _transactionService = transactionService;
        }
        public override IQueryable<InsurancePolicy> AddFilter(InsurancePolicySearchObject search, IQueryable<InsurancePolicy> query)
        {
            if (!string.IsNullOrEmpty(search?.ClientUsernameGTE))
            {
                query = query.Where(x => x.Client.Username.ToLower().StartsWith(search.ClientUsernameGTE.ToLower()));
            }

            if (search?.StartDateGTE.HasValue == true)
            {
                query = query.Where(x => x.StartDate >= search.StartDateGTE.Value);
            }

            if (search?.EndDateLTE.HasValue == true)
            {
                query = query.Where(x => x.EndDate <= search.EndDateLTE.Value);
            }

            if (search?.InsurancePackageId > 0)
            {
                query = query.Where(x => x.InsurancePackageId == search.InsurancePackageId);
            }

            query = query.Where(x => !x.IsDeleted).Include(x=>x.Client).Include(x=>x.InsurancePackage);
            var expiredPolicies = Context.InsurancePolicies
                .Where(x => x.EndDate < DateTime.Now && x.IsActive)
                .ToList();

            foreach (var policy in expiredPolicies)
            {
                policy.IsActive = false;
            }

            if (expiredPolicies.Any())
            {
                Context.SaveChanges();
            }
            if (!string.IsNullOrEmpty(search?.ClientUsername))
            {
                query = query.Where(x => x.Client.Username == search.ClientUsername);
            }
            return query;
        }

        public override async Task BeforeInsertAsync(InsurancePolicyInsertRequest request, InsurancePolicy entity, CancellationToken cancellationToken = default) 
        {
            entity.IsActive = false;
            entity.IsPaid = false;
            entity.IsNotificationSent = false;
            
        }
        public override async Task BeforeUpdateAsync(InsurancePolicyUpdateRequest request, InsurancePolicy entity, CancellationToken cancellationToken = default) 
        {
            if (request.TransactionInsert != null)
            {
                entity.IsActive = true;
                entity.IsPaid = true;
                
                await _transactionService.InsertAsync(request.TransactionInsert, cancellationToken);
                
            }
        }

    }
}
