using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MapsterMapper;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Model.SearchObjects;
using InsuraTech.Services.BaseServices;
using InsuraTech.Services.Database;
using Microsoft.Extensions.Logging;
using InsuraTech.Services.InsurancePackageStateMachine;
using InsuraTech.Services.Recommender;

namespace InsuraTech.Services
{
    public class InsurancePackageService : BaseCRUDService<InsurancePackageDTO, InsurancePackageSearchObject, InsurancePackage, InsurancePackageInsertRequest, InsurancePackageUpdateRequest>, IInsurancePackageService
    {
        ILogger<InsurancePackageService> _logger;
        public BaseInsurancePackageState BaseInsurancePackageState { get; set; }
        private readonly IRecommenderService _recommenderService;
        public InsurancePackageService(InsuraTechContext context, IMapper mapper, BaseInsurancePackageState baseInsurancePackageState, ILogger<InsurancePackageService> logger, IRecommenderService recommenderService)
        : base(context, mapper)
        {
            BaseInsurancePackageState = baseInsurancePackageState;
            _logger = logger;
            _recommenderService = recommenderService;
        }

        public override IQueryable<InsurancePackage> AddFilter(InsurancePackageSearchObject search, IQueryable<InsurancePackage> query)
        {
            var filteredQuery = base.AddFilter(search, query);

            if (!string.IsNullOrWhiteSpace(search?.InsurancePackageNameGTE))
            {
                filteredQuery = filteredQuery.Where(x => x.Name.Contains(search.InsurancePackageNameGTE));
            }
            if (search?.RetrieveAll==true)
            {
                filteredQuery = filteredQuery.Where(x => !x.IsDeleted);
                return filteredQuery;
            }
            filteredQuery = filteredQuery.Where(x => !x.IsDeleted).Where(x=>x.StateMachine=="active");

            return filteredQuery;
        }

        public override InsurancePackageDTO Insert(InsurancePackageInsertRequest request)
        {
            var state = BaseInsurancePackageState.CreateState("initial");
            return state.Insert(request);
        }

        public override InsurancePackageDTO Update(int id, InsurancePackageUpdateRequest request)
        {
            var entity = GetById(id);
            var state = BaseInsurancePackageState.CreateState(entity.StateMachine);
            return state.Update(id, request);

        }
        public override void Delete(int id)
        {
            var entity = GetById(id);
            var state = BaseInsurancePackageState.CreateState(entity.StateMachine);
            state.Delete(id);
        }

        public InsurancePackageDTO Activate(int id)
        {
            var entity = GetById(id);
            var state = BaseInsurancePackageState.CreateState(entity.StateMachine);
            return state.Activate(id);
        }

        public InsurancePackageDTO Edit(int id)
        {
            var entity = GetById(id);
            var state = BaseInsurancePackageState.CreateState(entity.StateMachine);
            return state.Edit(id);
        }

        public InsurancePackageDTO Hide(int id)
        {
            var entity = GetById(id);
            var state = BaseInsurancePackageState.CreateState(entity.StateMachine);
            return state.Hide(id);
        }

        public List<string> AllowedActions(int id)
        {
            _logger.LogInformation($"Allowed actions called for: {id}");

            if (id <= 0)
            {
                var state = BaseInsurancePackageState.CreateState("initial");
                return state.AllowedActions(null);
            }
            else
            {
                var entity = Context.InsurancePackages.Find(id);
                var state = BaseInsurancePackageState.CreateState(entity.StateMachine);
                return state.AllowedActions(entity);
            }
        }
        public async Task<List<InsurancePackageDTO>> Recommend(int clientId)
        {
            var recommend = await _recommenderService.Recommend(clientId);
            return recommend.Where(d => d.StateMachine == "active").ToList();
        }

        public void TrainData()
        {
            _recommenderService.TrainModel();
        }
    }

}
