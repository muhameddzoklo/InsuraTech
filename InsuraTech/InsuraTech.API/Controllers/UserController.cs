using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using InsuraTech.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{

    [ApiController]
    public class UserController : BaseCRUDControllerAsync<UserDTO, UserSearchObject, UserInsertRequest, UserUpdateRequest>
    {
        public UserController(IUserService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public UserDTO Login(string username, string password)
        {
            return (_service as IUserService).Login(username, password);
        }
    }
}
