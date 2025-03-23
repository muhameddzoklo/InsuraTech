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
        public DbSet<InsurancePackage> InsurancePackages { get; set; }
        public DbSet<InsurancePolicy> InsurancePolicies { get; set; }
        public DbSet<CustomerFeedback> CustomerFeedbacks { get; set; }
        public DbSet<UserFeedback> UserFeedbacks { get; set; }
        public DbSet<MessageLog> MessageLogs { get; set; }
        public DbSet<PaymentMethod> PaymentMethods { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Transaction> Transactions { get; set; }
        public DbSet<ClaimRequest> ClaimRequests { get; set; }
        public DbSet<InsurancePackageClaim> InsurancePackageClaims { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

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
