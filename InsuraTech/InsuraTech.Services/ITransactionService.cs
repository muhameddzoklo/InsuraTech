using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;

namespace InsuraTech.Services
{
    public interface ITransactionService : ICRUDServiceAsync<TransactionDTO, TransactionSearchObject, TransactionInsertRequest, TransactionUpdateRequest>
    {
    }
}
