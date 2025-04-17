using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Services.Database;
using MapsterMapper;

namespace InsuraTech.Services.InsurancePackageStateMachine
{
    public class InitialInsurancePackageState : BaseInsurancePackageState
    {
        public InitialInsurancePackageState(InsuraTechContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override InsurancePackageDTO Insert(InsurancePackageInsertRequest request)
        {
            var set = Context.Set<InsurancePackage>();
            var entity = Mapper.Map<InsurancePackage>(request);
            entity.StateMachine = "draft";
            set.Add(entity);
            Context.SaveChanges();

            return Mapper.Map<InsurancePackageDTO>(entity);
        }

        public override List<string> AllowedActions(InsurancePackage entity)
        {
            return new List<string>() { nameof(Insert) };
        }


    }
}