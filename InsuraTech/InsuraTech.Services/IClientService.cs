
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services
{
    public interface IClientService : ICRUDServiceAsync<ClientDTO, ClientSearchObject, ClientInsertRequest, ClientUpdateRequest>
    {
        ClientDTO Login(string username, string password);
    }
}