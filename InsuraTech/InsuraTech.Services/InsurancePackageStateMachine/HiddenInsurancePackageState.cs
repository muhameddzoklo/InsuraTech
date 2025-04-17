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
    public class HiddenInsurancePackageState : BaseInsurancePackageState
    {
        public HiddenInsurancePackageState(InsuraTechContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override InsurancePackageDTO Edit(int id)
        {
            var set = Context.Set<InsurancePackage>();

            var entity = set.Find(id);

            entity.StateMachine = "draft";

            Context.SaveChanges();

            return Mapper.Map<InsurancePackageDTO>(entity);
        }


        public override List<string> AllowedActions(InsurancePackage entity)
        {
            return new List<string>() { nameof(Edit) };
        }

    }
}