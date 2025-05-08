using Microsoft.EntityFrameworkCore;

namespace InsuraTech.Services.Database
{
    public class InsuraTechContext : DbContext
    {
        public InsuraTechContext(DbContextOptions<InsuraTechContext> options)
            : base(options)
        { }

        public DbSet<User> Users { get; set; }
        public DbSet<Role> Roles { get; set; }
        public DbSet<UserRole> UserRoles { get; set; }
        public DbSet<InsurancePackage> InsurancePackages { get; set; }
        public DbSet<InsurancePolicy> InsurancePolicies { get; set; }
        public DbSet<CustomerFeedback> CustomerFeedbacks { get; set; }
        public DbSet<UserFeedback> UserFeedbacks { get; set; }
        public DbSet<MessageLog> MessageLogs { get; set; }
        public DbSet<PaymentMethod> PaymentMethods { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Transaction> Transactions { get; set; }
        public DbSet<ClaimRequest> ClaimRequests { get; set; }
        public DbSet<Client> Clients { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            modelBuilder.Entity<Role>().HasData(
                new Role { RoleId = 1, RoleName = "Admin", Description = "Administrator with full access to settings, user permissions and platform operations.", IsDeleted = false },
                new Role { RoleId = 2, RoleName = "Agent", Description = "An Insurance Agent manages policies, processes claims, and assists customers with recommendations and approvals.", IsDeleted = false },
                new Role { RoleId = 3, RoleName = "Assistant", Description = "Supports insurance agents by handling administrative tasks, managing client inquiries, and processing policy updates", IsDeleted = false }
                );
            modelBuilder.Entity<User>().HasData(
                new User { UserId = 1, FirstName = "1", LastName = "1", Username = "1", Email = "1", PhoneNumber = "1", IsDeleted = false, PasswordSalt = "NHVv+8KhAiQqFlz7k1P53Q==", PasswordHash = "XVDI7NKoOCtMiSrKR1uSSGWvA7o=", IsActive = true },
                new User { UserId = 2, FirstName = "Admin", LastName = "Admin", Username = "admin", Email = "admin@mail.com", PhoneNumber = "000000000", IsDeleted = false, PasswordSalt = "sOQz4gFWKGh9SeOhqXpqyw==", PasswordHash = "+zHjeAMut/qVPctS7uaREf4lN1w=", IsActive = true },
                new User { UserId = 3, FirstName = "Agent", LastName = "Agent", Username = "agent", Email = "agent@mail.com", PhoneNumber = "000000001", IsDeleted = false, PasswordSalt = "2ICZgybWHKj+fYpTc6/19g==", PasswordHash = "9hkvRabWkVOkr+Hqr52lzoMKiKo=", IsActive = true },
                new User { UserId = 4, FirstName = "Assistant", LastName = "Assistant", Username = "assistant", Email = "assistant@mail.com", PhoneNumber = "000000002", IsDeleted = false, PasswordSalt = "Ct53DBogAC4vUxlb2WodgQ==", PasswordHash = "sfrZuf7hqepHmMV6gt83a/RaB9g=", IsActive = true }
                );
            modelBuilder.Entity<Client>().HasData(
                new Client { ClientId = 1, FirstName = "Client", LastName = "Client", Username = "client", Email = "client@mail.com", PhoneNumber = "000000003", ProfilePicture = null, RegistrationDate = new DateTime(2025, 4, 16, 22, 52, 03), IsDeleted = false, PasswordSalt = "mGr/PGoIDO5ILaJYl3MvJg==", PasswordHash = "8OB3D2RPgagepehex0hLz6HdM1Q=", IsActive = true },
                new Client { ClientId = 2, FirstName = "Client1", LastName = "Client1", Username = "client1", Email = "client1@mail.com", PhoneNumber = "000000004", ProfilePicture = null, RegistrationDate = new DateTime(2025, 4, 16, 22, 52, 03), IsDeleted = false, PasswordSalt = "mGr/PGoIDO5ILaJYl3MvJg==", PasswordHash = "8OB3D2RPgagepehex0hLz6HdM1Q=", IsActive = true },
                new Client { ClientId = 3, FirstName = "Client2", LastName = "Client2", Username = "client2", Email = "client2@mail.com", PhoneNumber = "000000005", ProfilePicture = null, RegistrationDate = new DateTime(2025, 4, 16, 22, 52, 03), IsDeleted = false, PasswordSalt = "mGr/PGoIDO5ILaJYl3MvJg==", PasswordHash = "8OB3D2RPgagepehex0hLz6HdM1Q=", IsActive = true }
                );
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { UserRoleId = 1, RoleId = 1, UserId = 1, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 2, RoleId = 1, UserId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 3, RoleId = 2, UserId = 3, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 4, RoleId = 3, UserId = 4, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false }
                );

            modelBuilder.Entity<InsurancePackage>().HasData(
                new InsurancePackage { InsurancePackageId = 1, Name = "Basic Car Insurance", Description = "Essential coverage for your vehicle, including third-party liability and collision coverage.", Price = 199.99m, Picture = null, StateMachine = "active" ,DurationDays = 365 },
                new InsurancePackage { InsurancePackageId = 2, Name = "Comprehensive Home Insurance", Description = "Extensive protection for your home covering fire, theft, natural disasters, and personal liability.", Price = 349.50m, Picture = null, StateMachine = "active",DurationDays = 90 },
                new InsurancePackage { InsurancePackageId = 3, Name = "Premium Health Insurance", Description = "Premium medical coverage offering extensive benefits including hospitalization, dental care, and vision care.", Price = 499.00m, Picture = null, StateMachine = "draft",DurationDays = 180 }
            );
            modelBuilder.Entity<InsurancePolicy>().HasData(
             new InsurancePolicy { InsurancePolicyId = 1, InsurancePackageId = 1, ClientId = 1, StartDate = new DateTime(2025, 1, 1), EndDate = new DateTime(2026, 1, 1), IsActive = true, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = false },
             new InsurancePolicy { InsurancePolicyId = 2, InsurancePackageId = 2, ClientId = 1, StartDate = new DateTime(2025, 2, 15), EndDate = new DateTime(2025, 5, 15), IsActive = true, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = false },
             new InsurancePolicy { InsurancePolicyId = 3, InsurancePackageId = 3, ClientId = 2, StartDate = new DateTime(2025, 3, 1), EndDate = new DateTime(2025, 8, 28), IsActive = true, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = false },
             new InsurancePolicy { InsurancePolicyId = 4, InsurancePackageId = 1, ClientId = 2, StartDate = new DateTime(2025, 4, 1), EndDate = new DateTime(2026, 4, 1), IsActive = false, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = false },
             new InsurancePolicy { InsurancePolicyId = 5, InsurancePackageId = 2, ClientId = 3, StartDate = new DateTime(2025, 5, 20), EndDate = new DateTime(2025, 8, 18), IsActive = true, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = false }
            );

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.User)
                .WithMany(u => u.UserRoles)
                .HasForeignKey(ur => ur.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            modelBuilder.Entity<UserRole>()
                .HasOne(ur => ur.Role)
                .WithMany(r => r.UserRoles)
                .HasForeignKey(ur => ur.RoleId)
                .OnDelete(DeleteBehavior.Cascade);
           
            modelBuilder.Entity<UserFeedback>()
                .HasOne(uf => uf.User)
                .WithMany()
                .HasForeignKey(uf => uf.UserId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<UserFeedback>()
                .HasOne(uf => uf.CustomerFeedback)
                .WithMany()
                .HasForeignKey(uf => uf.CustomerFeedbackId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<MessageLog>()
                .HasOne(m => m.User)
                .WithMany()
                .HasForeignKey(m => m.UserId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<Transaction>()
                .HasOne(t => t.User)
                .WithMany()
                .HasForeignKey(t => t.UserId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<Transaction>()
                .HasOne(t => t.paymentMethod)
                .WithMany()
                .HasForeignKey(t => t.PaymentMethodId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<InsurancePolicy>()
                .HasOne(i => i.InsurancePackage)
                .WithMany(x => x.Policies)
                .HasForeignKey(i => i.InsurancePackageId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Notification>()
                .HasOne(n => n.Client)
                .WithMany()
                .HasForeignKey(n => n.ClientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Notification>()
                .HasOne(n => n.InsurancePolicy)
                .WithMany()
                .HasForeignKey(n => n.InsurancePolicyId)
                .OnDelete(DeleteBehavior.Restrict);


        }
    }
}
