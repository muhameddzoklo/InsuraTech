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
using InsuraTech.Services.Enums;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;

namespace InsuraTech.Services
{
    public class TransactionService : BaseCRUDServiceAsync<TransactionDTO, TransactionSearchObject, Transaction, TransactionInsertRequest, TransactionUpdateRequest>, ITransactionService
    {
        private readonly ILoyaltyProgramService _loyaltyProgramService;
        public TransactionService(InsuraTechContext context, IMapper mapper, ILoyaltyProgramService loyaltyProgramService) : base(context, mapper)
        {
            _loyaltyProgramService = loyaltyProgramService;
        }
        public override IQueryable<Transaction> AddFilter(TransactionSearchObject search, IQueryable<Transaction> query)
        {
            if (search.ClientId.HasValue && search.ClientId > 0)
            {
                query = query.Where(x => x.ClientId == search.ClientId);
            }

            if (search.DateFrom.HasValue)
            {
                query = query.Where(x => x.TransactionDate >= search.DateFrom.Value);
            }

            if (search.DateTo.HasValue)
            {
                query = query.Where(x => x.TransactionDate <= search.DateTo.Value);
            }
            if (!string.IsNullOrWhiteSpace(search?.ClientName))
            {
                query = query.Where(x => x.Client.FirstName.StartsWith(search.ClientName));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        public override IQueryable<Transaction> AddInclude(IQueryable<Transaction> query)
        {
            return query
                .Include(x => x.Client)
                .Include(x => x.InsurancePolicy)
                    .ThenInclude(a => a.InsurancePackage)
                .Include(x => x.InsurancePolicy)
                    .ThenInclude(a => a.Client);
        }

        public override async Task BeforeInsertAsync(TransactionInsertRequest request, Transaction entity, CancellationToken cancellationToken = default)
        {
            entity.TransactionDate = DateTime.Now;
        }
        public override async Task AfterInsertAsync(TransactionInsertRequest request, Transaction entity, CancellationToken cancellationToken = default)
        {
            var loyaltyProgram = await Context.LoyaltyPrograms
                .FirstOrDefaultAsync(a => a.ClientId == entity.ClientId, cancellationToken);

            if (loyaltyProgram == null)
                return;

            int calcPoints = (int)Math.Round(request.Amount / 20);
            int newTotalPoints = loyaltyProgram.Points + calcPoints;


            LoyaltyTier newTier = Helpers.Helper.GetTierFromPoints(newTotalPoints);


            var updateRequest = new LoyaltyProgramUpdateRequest
            {
                Points = newTotalPoints,
                Tier = newTier > loyaltyProgram.Tier ? newTier : loyaltyProgram.Tier

            };


            await _loyaltyProgramService.UpdateAsync(loyaltyProgram.LoyaltyProgramId, updateRequest, cancellationToken);
        }




    }
}
