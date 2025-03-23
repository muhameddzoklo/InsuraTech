using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Authorization;

namespace InsuraTech.API.Controllers
{
    [AllowAnonymous]
    public class InsurancePackageController:BaseCRUDControllerAsync<InsurancePackageDTO,InsurancePackageSearchObject,InsurancePackageUpsertRequest,InsurancePackageUpsertRequest>
    {
        
        public InsurancePackageController(IInsurancePackageService service) : base(service)
        {
            
        }


    }
}
