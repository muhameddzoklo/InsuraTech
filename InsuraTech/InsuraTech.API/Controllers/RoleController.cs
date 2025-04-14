using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Authorization;

namespace InsuraTech.API.Controllers
{
   
    public class RoleController : BaseCRUDControllerAsync<RoleDTO, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
        public RoleController(IroleService service) : base(service)
        {

        }
    }
}
