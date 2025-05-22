using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;

namespace InsuraTech.API.Controllers
{

    public class ClientFeedbackController : BaseCRUDControllerAsync<ClientFeedbackDTO, ClientFeedbackSearchObject, ClientFeedbackInsertRequest, ClientFeedbackUpdateRequest>
    {
        public ClientFeedbackController(IClientFeedbackService service) : base(service)
        {

        }
    }

}
