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
    public class DraftInsurancePackageState : BaseInsurancePackageState
    {
        public DraftInsurancePackageState(InsuraTechContext context, IMapper mapper, IServiceProvider serviceProvider) : base(context, mapper, serviceProvider)
        {
        }

        public override InsurancePackageDTO Update(int id, InsurancePackageUpdateRequest request)
        {
            var set = Context.Set<InsurancePackage>();

            var entity = set.Find(id);

            Mapper.Map(request, entity);

            Context.SaveChanges();

            return Mapper.Map<InsurancePackageDTO>(entity);
        }
        public override void Delete(int id)
        {
            var set = Context.Set<InsurancePackage>();

            var entity = set.Find(id);
            entity.IsDeleted = true;

            Context.SaveChanges();
        }

        public override InsurancePackageDTO Activate(int id)
        {
            var set = Context.Set<InsurancePackage>();

            var entity = set.Find(id);

            entity.StateMachine = "active";

            Context.SaveChanges();

            var mappedEntity = Mapper.Map<InsurancePackageDTO>(entity);

            return mappedEntity;

        }

        public override InsurancePackageDTO Hide(int id)
        {
            var set = Context.Set<InsurancePackage>();

            var entity = set.Find(id);

            entity.StateMachine = "hidden";

            Context.SaveChanges();

            return Mapper.Map<InsurancePackageDTO>(entity);
        }

        public override List<string> AllowedActions(InsurancePackage entity)
        {
            return new List<string>() { nameof(Activate), nameof(Update), nameof(Hide), nameof(Delete) };
        }
    }
}