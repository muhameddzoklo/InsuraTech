using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapsterMapper;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using InsuraTech.Services.Database;

namespace InsuraTech.Services
{
    public class InsurancePackageService:BaseCRUDServiceAsync<InsurancePackageDTO,InsurancePackageSearchObject,InsurancePackage,InsurancePackageInsertRequest,InsurancePackageUpdateRequest>,IInsurancePackageService
    {
        public InsurancePackageService(InsuraTechContext context, IMapper mapper):base(context,mapper)
        { 
        }
        public override IQueryable<InsurancePackage> AddFilter(InsurancePackageSearchObject search, IQueryable<InsurancePackage> query)
        {

            if (!string.IsNullOrEmpty(search?.InsurancePackageNameGTE))
            {
                query = query.Where(x => x.Name.ToLower().StartsWith(search.InsurancePackageNameGTE));
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
    }
}
