using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;
using InsuraTech.Model.DTOs;
using InsuraTech.Model.Requests;
using InsuraTech.Services.Database;
using Mapster;

namespace InsuraTech.Services.Helpers
{
    public static class MappingConfig
    {
        public static void RegisterMappings()
        {
            var config = TypeAdapterConfig.GlobalSettings;

            config.Default.IgnoreNullValues(true);



            config.NewConfig<Transaction, TransactionDTO>()
                .Map(dest => dest.Client, src => src.Client)
                .Map(dest => dest.InsurancePolicy, src => src.InsurancePolicy);


            config.NewConfig<TransactionInsertRequest, Transaction>()
                .Map(dest => dest.InsurancePolicyId, src => src.InsurancePolicyId)
                .Map(dest => dest.ClientId, src => src.ClientId)
                .Map(dest => dest.Amount, src => src.Amount)
                .Map(dest => dest.PaymentMethod, src => src.PaymentMethod)
                .Map(dest => dest.PaymentId, src => src.PaymentId)
                .Map(dest => dest.PayerId, src => src.PayerId)
                .Ignore(dest => dest.InsurancePolicy)
                .Ignore(dest => dest.Client);

            config.NewConfig<ClientFeedback, ClientFeedbackDTO>()
    .Map(dest => dest.PackageName,
        src => src.InsurancePackage != null
            ? src.InsurancePackage.Name
            : "")
    .Map(dest => dest.ClientName,
        src => src.Client != null
            ? (
                (src.Client.FirstName ?? "") + " " +
                (src.Client.LastName ?? "")
              ).Trim()
            : "")
    .Map(dest => dest.ClientProfilePicture,
        src => src.Client != null && src.Client.ProfilePicture != null
            ? Convert.ToBase64String(src.Client.ProfilePicture)
            : null)
    .IgnoreNullValues(true);
        

        }

    }
}