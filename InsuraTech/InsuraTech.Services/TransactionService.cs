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
    public class TransactionService : BaseCRUDServiceAsync<TransactionDTO, TransactionSearchObject, Transaction, TransactionInsertRequest, TransactionUpdateRequest>, ITransactionService
    {
        public TransactionService(InsuraTechContext context, IMapper mapper) : base(context, mapper)
        {

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


    }
}
