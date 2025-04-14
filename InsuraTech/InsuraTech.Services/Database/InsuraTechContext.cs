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
        public DbSet<InsurancePackageClaim> InsurancePackageClaims { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
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

            modelBuilder.Entity<Role>().HasData(
                new Role { RoleId = 1, RoleName = "Admin", Description = "Administrator with full access to settings, user permissions and platform operations.", IsDeleted = false },
                new Role { RoleId = 2, RoleName = "Agent", Description = "An Insurance Agent manages policies, processes claims, and assists customers with recommendations and approvals.", IsDeleted = false },
                new Role { RoleId = 3, RoleName = "Assistant", Description = "Supports insurance agents by handling administrative tasks, managing client inquiries, and processing policy updates", IsDeleted = false }
                );
            modelBuilder.Entity<User>().HasData(
                new User { UserId = 1, FirstName = "1", LastName = "1", Username = "1", Email = "1", PhoneNumber = "1", IsDeleted = false, PasswordSalt = "NHVv+8KhAiQqFlz7k1P53Q==", PasswordHash = "XVDI7NKoOCtMiSrKR1uSSGWvA7o=" },
                new User { UserId = 2, FirstName = "Admin", LastName = "Admin", Username = "admin", Email = "admin@mail.com", PhoneNumber = "000000000", IsDeleted = false, PasswordSalt = "BAbir1GLAnT8mlkl48K82Q==", PasswordHash = "vjxFUddajZn+mD4TXhrpKJFpwCk=" },
                new User { UserId = 3, FirstName = "Agent", LastName = "Agent", Username = "agent", Email = "agent@mail.com", PhoneNumber = "000000001", IsDeleted = false, PasswordSalt = "g8L0JtbZi8CyIwALz6lEjw==", PasswordHash = "2tC+kGkSwtfK1s76++lFQfVkMBA=" },
                new User { UserId = 4, FirstName = "Assistant", LastName = "Assistant", Username = "assistant", Email = "assistant@mail.com", PhoneNumber = "000000002", IsDeleted = false, PasswordSalt = "fQs/0a4aqARNG/avZ7mRlg==", PasswordHash = "1bwUDDXJ0XBRKYVYycBm+yVzUlQ=" }
                );
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { UserRoleId = 1, RoleId = 1, UserId = 1, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 2, RoleId = 1, UserId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 3, RoleId = 2, UserId = 3, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 4, RoleId = 3, UserId = 4, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false }
                );


            // Disable cascading delete for all relationships that may cause cycles
            modelBuilder.Entity<InsurancePackageClaim>()
                .HasOne(i => i.InsurancePackage)
                .WithMany()
                .HasForeignKey(i => i.InsurancePackageId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<InsurancePackageClaim>()
                .HasOne(i => i.ClaimRequest)
                .WithMany()
                .HasForeignKey(i => i.ClaimRequestId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<ClaimRequest>()
                .HasOne(c => c.insurancePolicy)
                .WithMany()
                .HasForeignKey(c => c.InsurancePolicyId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

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

            modelBuilder.Entity<Notification>()
                .HasOne(n => n.User)
                .WithMany()
                .HasForeignKey(n => n.UserId)
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
                .WithMany()
                .HasForeignKey(i => i.InsurancePackageId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete

            modelBuilder.Entity<InsurancePolicy>()
                .HasOne(i => i.User)
                .WithMany()
                .HasForeignKey(i => i.UserId)
                .OnDelete(DeleteBehavior.Restrict); // No action on delete
        }
    }
}
