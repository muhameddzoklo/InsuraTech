using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using InsuraTech.Services.Database;

namespace InsuraTech.Services
{
    public interface IInsurancePackageService:ICRUDService<InsurancePackageDTO,InsurancePackageSearchObject,InsurancePackageInsertRequest,InsurancePackageUpdateRequest>
    {
        public InsurancePackageDTO Activate(int id);

        public InsurancePackageDTO Edit(int id);
        public InsurancePackageDTO Hide(int id);

        public List<string> AllowedActions(int id);
        Task<List<InsurancePackageDTO>> Recommend(int id);
        void TrainData();
    }                            
}
