using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{
    [ApiController]
    public class RoleController : BaseCRUDControllerAsync<RoleDTO, RoleSearchObject, RoleUpsertRequest, RoleUpsertRequest>
    {
        public RoleController(IroleService service) : base(service)
        {

        }
    }
}
