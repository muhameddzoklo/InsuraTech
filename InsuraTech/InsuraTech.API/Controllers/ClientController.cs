using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;
using InsuraTech.Services.BaseServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace InsuraTech.API.Controllers
{

    public class ClientController : BaseCRUDControllerAsync<ClientDTO, ClientSearchObject, ClientInsertRequest, ClientUpdateRequest>
    {
        public ClientController(IClientService service) : base(service)
        {
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public ClientDTO Login(string username, string password)
        {
            return (_service as IClientService).Login(username, password);
        }
        [AllowAnonymous]
        [HttpPost("register")]
        public async Task<ClientDTO> InsertAsync(ClientInsertRequest request, CancellationToken cancellationToken)
        {
            return await (_service as IClientService).InsertAsync(request, cancellationToken);
        }
    }
}
