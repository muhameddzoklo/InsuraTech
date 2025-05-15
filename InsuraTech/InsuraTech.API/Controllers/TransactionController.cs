using InsuraTech.API.Controllers.BaseControllers;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services;

namespace InsuraTech.API.Controllers
{
    public class TransactionController : BaseCRUDControllerAsync<TransactionDTO, TransactionSearchObject, TransactionInsertRequest, TransactionUpdateRequest>
    {
        public TransactionController(ITransactionService service) : base(service)
        {

        }
    }
}
