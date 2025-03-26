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
    public class RoleService : BaseCRUDServiceAsync<RoleDTO, RoleSearchObject, Role, RoleUpsertRequest, RoleUpsertRequest>, IroleService
    {
        public RoleService(InsuraTechContext context, IMapper mapper) : base(context, mapper)
        {

        }
        public override IQueryable<Role> AddFilter(RoleSearchObject search, IQueryable<Role> query)
        {

            if (!string.IsNullOrEmpty(search?.RoleNameGTE))
            {
                query = query.Where(x => x.RoleName.ToLower().StartsWith(search.RoleNameGTE));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
    }
}
