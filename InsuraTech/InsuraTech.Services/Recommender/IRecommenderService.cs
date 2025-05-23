using InsuraTech.Model.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services.Recommender
{
    public interface IRecommenderService
    {
        Task<List<InsurancePackageDTO>> Recommend(int id);
        void TrainModel();
    }
}
