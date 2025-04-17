using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{

    public class InsurancePackageController:BaseCRUDController<InsurancePackageDTO,InsurancePackageSearchObject,InsurancePackageInsertRequest,InsurancePackageUpdateRequest>
    {
        
        public InsurancePackageController(IInsurancePackageService service) : base(service)
        {
            
        }
        [HttpPut("{id}/activate")]
        public InsurancePackageDTO Activate(int id)
        {
            return (_service as IInsurancePackageService).Activate(id);
        }

        [HttpPut("{id}/edit")]
        public InsurancePackageDTO Edit(int id)
        {
            return (_service as IInsurancePackageService).Edit(id);
        }

        [HttpPut("{id}/hide")]
        public InsurancePackageDTO Hide(int id)
        {
            return (_service as IInsurancePackageService).Hide(id);
        }

        [HttpGet("{id}/allowedActions")]
        public List<string> AllowedActions(int id)
        {
            return (_service as IInsurancePackageService).AllowedActions(id);
        }


    }
}