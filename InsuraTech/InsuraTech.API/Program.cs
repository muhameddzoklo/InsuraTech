using InsuraTech.API.Auth;
using InsuraTech.Services;
using InsuraTech.Services.Database;
using InsuraTech.Services.Helpers;
using InsuraTech.Services.InsurancePackageStateMachine;
using Mapster;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;


var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddTransient<IInsurancePackageService, InsurancePackageService>();
builder.Services.AddTransient<IroleService, RoleService>();
builder.Services.AddTransient<IUserService, UserService>();
builder.Services.AddTransient<IClientService, ClientService>();
builder.Services.AddTransient<IInsurancePolicyService, InsurancePolicyService>();
builder.Services.AddTransient<IClaimRequestService, ClaimRequestService>();
builder.Services.AddTransient<INotificationService, NotificationService>();
builder.Services.AddTransient<ITransactionService, TransactionService>();
builder.Services.AddTransient<ISupportTicketService, SupportTicketService>();
builder.Services.AddTransient<IClientFeedbackService, ClientFeedbackService>();

builder.Services.AddTransient<BaseInsurancePackageState>();
builder.Services.AddTransient<InitialInsurancePackageState>();
builder.Services.AddTransient<DraftInsurancePackageState>();
builder.Services.AddTransient<ActiveInsurancePackageState>();
builder.Services.AddTransient<HiddenInsurancePackageState>();


MappingConfig.RegisterMappings();


builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});
DotNetEnv.Env.Load("../.env");

var connectionString = Environment.GetEnvironmentVariable("CONNECTION_STRING");
builder.Services.AddDbContext<InsuraTechContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddMapster();

builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
builder.Services.AddHttpContextAccessor();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<InsuraTechContext>();
    dataContext.Database.Migrate();
}
app.Run();