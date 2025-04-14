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
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace InsuraTech.Services
{
    public class ClientService : BaseCRUDServiceAsync<ClientDTO, ClientSearchObject, Client, ClientInsertRequest, ClientUpdateRequest>, IClientService
    {
        ILogger<ClientService> _logger;
        public ClientService(InsuraTechContext context, IMapper mapper, ILogger<ClientService> logger) : base(context, mapper)
        {
            _logger = logger;
        }
        public override IQueryable<Client> AddFilter(ClientSearchObject searchObject, IQueryable<Client> query)
        {
            query = base.AddFilter(searchObject, query);
            if (!string.IsNullOrWhiteSpace(searchObject?.FirstNameGTE))
            {
                query = query.Where(x => x.FirstName.StartsWith(searchObject.FirstNameGTE));
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.LastNameGTE))
            {
                query = query.Where(x => x.LastName.StartsWith(searchObject.LastNameGTE));
            }
            if (!string.IsNullOrEmpty(searchObject?.FirstLastNameGTE) &&
    (string.IsNullOrEmpty(searchObject?.FirstNameGTE) && string.IsNullOrEmpty(searchObject?.LastNameGTE)))
            {
                query = query.Where(x => (x.FirstName + " " + x.LastName).ToLower().StartsWith(searchObject.FirstLastNameGTE.ToLower()));
            }
            if (!string.IsNullOrEmpty(searchObject?.PhoneNumber))
            {
                query = query.Where(x => x.PhoneNumber == searchObject.PhoneNumber);
            }
            if (!string.IsNullOrWhiteSpace(searchObject?.EmailGTE))
            {
                query = query.Where(x => x.Email == searchObject.EmailGTE);
            }

            if (!string.IsNullOrWhiteSpace(searchObject?.Username))
            {
                query = query.Where(x => x.Username == searchObject.Username);
            }
            query = query.Where(x => !x.IsDeleted);
            return query;
        }
        public override async Task BeforeInsertAsync(ClientInsertRequest request, Client entity, CancellationToken cancellationToken = default)
        {
            _logger.LogInformation($"Adding client: {entity.Username}");
            var client = await Context.Clients.FirstOrDefaultAsync(x => x.Username == request.Username);
            if (client != null)
            {
                throw new Exception("Username already exists!");
            }
            var newuser = await Context.Clients.FirstOrDefaultAsync(x => x.Email == request.Email);
            if (newuser != null)
            {
                throw new Exception("Email already exists!");
            }
            if (string.IsNullOrEmpty(request.Password) || string.IsNullOrEmpty(request.PasswordConfirmation))
            {
                throw new Exception("Password and password confirmation required!");
            }
            if (request.Password != request.PasswordConfirmation)
            {
                throw new Exception("Password and password confirmation must match!");
            }
            if (request.ProfilePicture == null)
            {
                entity.ProfilePicture = null;
            }
            entity.RegistrationDate = DateTime.Now;
            entity.PasswordSalt = Helpers.Helper.GenerateSalt();
            entity.PasswordHash = Helpers.Helper.GenerateHash(entity.PasswordSalt, request.Password);

            //await rabbitMqService.SendAnEmail(new EmailDTO
            //{
            //    EmailTo = entity.Email,
            //    Message = $"Poštovani<br>" +
            //  $"Korisnicko ime: {entity.KorisnickoIme}<br>" +
            //  $"Lozinka: {lozinka}<br><br>" +
            //  $"Srdačan pozdrav",
            //    ReceiverName = entity.Ime + " " + entity.Prezime,
            //    Subject = "Registracija"
            //});
        }
        public override async Task BeforeUpdateAsync(ClientUpdateRequest request, Client entity, CancellationToken cancellationToken = default)
        {
            if (request.Password != null && request.PasswordConfirmation != null && request.CurrentPassword != null)
            {
                var currentPw = Helpers.Helper.GenerateHash(entity.PasswordSalt, request.CurrentPassword);

                if (currentPw != entity.PasswordHash)
                {
                    throw new Exception("Invalid current password");
                }
                if (request.Password != request.PasswordConfirmation)
                {
                    throw new Exception("Password and password confirmation must match!");
                }
                entity.PasswordSalt = Helpers.Helper.GenerateSalt();
                entity.PasswordHash = Helpers.Helper.GenerateHash(entity.PasswordSalt, request.Password);
            }
        }
        public override async Task<ClientDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await base.GetByIdAsync(id, cancellationToken);
        }
        public ClientDTO Login(string username, string password)
        {
            var entity = Context.Clients.Where(u => u.Username == username).FirstOrDefault();


            if (entity == null)
            {
                return null;
            }

            var hash = Helpers.Helper.GenerateHash(entity.PasswordSalt, password);

            if (hash != entity.PasswordHash)
            {
                return null;
            }

            return this.Mapper.Map<ClientDTO>(entity);
        }
    }
}
