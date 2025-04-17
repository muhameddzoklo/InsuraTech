using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Exceptions;
using InsuraTech.Model.Requests;
using InsuraTech.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;

namespace InsuraTech.Services.InsurancePackageStateMachine
{
    public class BaseInsurancePackageState
    {
        public InsuraTechContext Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BaseInsurancePackageState(InsuraTechContext context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }
        public virtual InsurancePackageDTO Insert(InsurancePackageInsertRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual InsurancePackageDTO Update(int id, InsurancePackageUpdateRequest request)
        {
            throw new UserException("Method not allowed");
        }

        public virtual InsurancePackageDTO Activate(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual InsurancePackageDTO Hide(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual InsurancePackageDTO Edit(int id)
        {
            throw new UserException("Method not allowed");
        }
        public virtual void Delete(int id)
        {
            throw new UserException("Method not allowed");
        }

        public virtual List<string> AllowedActions(InsurancePackage entity)
        {
            throw new UserException("Method not allowed");
        }


        public BaseInsurancePackageState CreateState(string stateName)
        {
            switch (stateName)
            {
                case "initial":
                    return ServiceProvider.GetService<InitialInsurancePackageState>();
                case "draft":
                    return ServiceProvider.GetService<DraftInsurancePackageState>();
                case "active":
                    return ServiceProvider.GetService<ActiveInsurancePackageState>();
                case "hidden":
                    return ServiceProvider.GetService<HiddenInsurancePackageState>();
                default: throw new Exception("State not recognized");
            }
        }
    }
}