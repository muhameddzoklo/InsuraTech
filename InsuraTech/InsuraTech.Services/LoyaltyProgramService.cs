using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using InsuraTech.Services.Database;
using InsuraTech.Services.Enums;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services
{
    public class LoyaltyProgramService : BaseCRUDServiceAsync<LoyaltyProgramDTO, LoyaltyProgramSearchObject, LoyaltyProgram, LoyaltyProgramInsertRequest, LoyaltyProgramUpdateRequest>, ILoyaltyProgramService
    {
        public LoyaltyProgramService(InsuraTechContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<LoyaltyProgram> AddFilter(LoyaltyProgramSearchObject search, IQueryable<LoyaltyProgram> query)
        {

            if (!string.IsNullOrWhiteSpace(search.ClientNameGTE))
                query = query.Where(r =>
                    (r.Client.FirstName + " " + r.Client.LastName).ToLower().Contains(search.ClientNameGTE.ToLower())
                );
            if (search.Status.HasValue)
            {
                query = query.Where(x => x.Tier == search.Status.Value);
            }
            if (search.ClientId != null && search.ClientId > 0)
            {
                query = query.Where(x => x.ClientId == search.ClientId);
            }
            query = query.Where(x => !x.IsDeleted);
            return query.Include(x=>x.Client);
        }
        public override async Task BeforeInsertAsync(LoyaltyProgramInsertRequest request, LoyaltyProgram entity, CancellationToken cancellationToken = default) 
        {
            entity.ClientId = request.ClientId;
            entity.Points = 0;
            entity.Tier=LoyaltyTier.Bronze;
            entity.LastUpdated = DateTime.Now;
        }
        public override async Task BeforeUpdateAsync(LoyaltyProgramUpdateRequest request, LoyaltyProgram entity, CancellationToken cancellationToken = default) 
        { 
            entity.LastUpdated= DateTime.Now;
        }
    }

}
