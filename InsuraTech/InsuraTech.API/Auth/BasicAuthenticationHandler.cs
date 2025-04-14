using Azure.Core;
using InsuraTech.Services;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Encodings.Web;
using System.Text;

namespace InsuraTech.API.Auth
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IUserService _userService;
        private readonly IClientService _clientService;

        public BasicAuthenticationHandler(IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            ISystemClock clock,
            IUserService userService
            ,IClientService clientService) : base(options, logger, encoder, clock)
        {
            _userService = userService;
            this._clientService = clientService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
            {
                return AuthenticateResult.Fail("Missing header");
            }

            var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
            var credentialBytes = Convert.FromBase64String(authHeader.Parameter);
            var credentials = Encoding.UTF8.GetString(credentialBytes).Split(':');

            var username = credentials[0];
            var password = credentials[1];

            var user = _userService.Login(username, password);

            if (user == null)
            {
                
                var client = _clientService.Login(username, password);

                if (client == null)
                {
                    return AuthenticateResult.Fail("Auth failed");
                }
                else
                {
                    var claims = new List<Claim>()
                    {
                    new Claim(ClaimTypes.Name, client.FirstName),
                    new Claim(ClaimTypes.NameIdentifier, client.Username)
                    };

                    claims.Add(new Claim(ClaimTypes.Role, "Client"));

                    var identity = new ClaimsIdentity(claims, Scheme.Name);

                    var principal = new ClaimsPrincipal(identity);

                    var ticket = new AuthenticationTicket(principal, Scheme.Name);
                    return AuthenticateResult.Success(ticket);
                }
            }
            else
            {
                var claims = new List<Claim>()
                {
                    new Claim(ClaimTypes.Role, user.FirstName),
                    new Claim(ClaimTypes.NameIdentifier, user.Username)
                };

                foreach (var role in user.UserRoles)
                {
                    claims.Add(new Claim(ClaimTypes.Role, role.Role.RoleName));
                }

                var identity = new ClaimsIdentity(claims, Scheme.Name);

                var principal = new ClaimsPrincipal(identity);

                var ticket = new AuthenticationTicket(principal, Scheme.Name);
                return AuthenticateResult.Success(ticket);
            }
        }
    }
}
