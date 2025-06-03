using InsuraTech.Services.Enums;
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
        public DbSet<ClientFeedback> ClientFeedbacks { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<Transaction> Transactions { get; set; }
        public DbSet<ClaimRequest> ClaimRequests { get; set; }
        public DbSet<SupportTicket> SupportTickets { get; set; }
        public DbSet<Client> Clients { get; set; }
        public DbSet<LoyaltyProgram> LoyaltyPrograms { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            modelBuilder.Entity<Role>().HasData(
                new Role { RoleId = 1, RoleName = "Admin", Description = "Administrator with full access to settings, user permissions and platform operations.", IsDeleted = false },
                new Role { RoleId = 2, RoleName = "Agent", Description = "An Insurance Agent manages policies, processes claims, and assists customers with recommendations and approvals.", IsDeleted = false },
                new Role { RoleId = 3, RoleName = "Assistant", Description = "Supports insurance agents by handling administrative tasks, managing client inquiries, and processing policy updates", IsDeleted = false }
                );
            modelBuilder.Entity<User>().HasData(
                new User { UserId = 1, FirstName = "Liam", LastName = "Schneider", Username = "desktop", Email = "admin@example.com", PhoneNumber = "069000111", IsDeleted = false, PasswordSalt = "sOQz4gFWKGh9SeOhqXpqyw==", PasswordHash = "+zHjeAMut/qVPctS7uaREf4lN1w=", IsActive = true, ProfilePicture = null },
                new User { UserId = 2, FirstName = "Emily", LastName = "Carter", Username = "agent", Email = "agent@example.com", PhoneNumber = "069000222", IsDeleted = false, PasswordSalt = "2ICZgybWHKj+fYpTc6/19g==", PasswordHash = "9hkvRabWkVOkr+Hqr52lzoMKiKo=", IsActive = true, ProfilePicture = null },
                new User { UserId = 3, FirstName = "Sofia", LastName = "Alvarez", Username = "assistant", Email = "assistant@example.com", PhoneNumber = "069000333", IsDeleted = false, PasswordSalt = "Ct53DBogAC4vUxlb2WodgQ==", PasswordHash = "sfrZuf7hqepHmMV6gt83a/RaB9g=", IsActive = true, ProfilePicture = null }
                );
            modelBuilder.Entity<Client>().HasData(
                new Client { ClientId = 1, FirstName = "John", LastName = "Doe", Username = "mobile", Email = "john.doe@example.com", PhoneNumber = "068225599", ProfilePicture = null, RegistrationDate = new DateTime(2024, 4, 16, 22, 52, 03), IsDeleted = false, PasswordSalt = "mGr/PGoIDO5ILaJYl3MvJg==", PasswordHash = "8OB3D2RPgagepehex0hLz6HdM1Q=", IsActive = true },
                new Client { ClientId = 2, FirstName = "Clara", LastName = "Wong", Username = "claraW", Email = "clara.wong@example.com", PhoneNumber = "068113399", ProfilePicture = null, RegistrationDate = new DateTime(2024, 4, 16, 22, 52, 03), IsDeleted = false, PasswordSalt = "mGr/PGoIDO5ILaJYl3MvJg==", PasswordHash = "8OB3D2RPgagepehex0hLz6HdM1Q=", IsActive = true },
                new Client { ClientId = 3, FirstName = "Martin", LastName = "Taylor", Username = "martinT", Email = "martin.taylor@example.com", PhoneNumber = "068224400", ProfilePicture = null, RegistrationDate = new DateTime(2024, 4, 16, 22, 52, 03), IsDeleted = false, PasswordSalt = "mGr/PGoIDO5ILaJYl3MvJg==", PasswordHash = "8OB3D2RPgagepehex0hLz6HdM1Q=", IsActive = true }
                );
            modelBuilder.Entity<UserRole>().HasData(
                new UserRole { UserRoleId = 1, RoleId = 1, UserId = 1, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 2, RoleId = 2, UserId = 2, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false },
                new UserRole { UserRoleId = 3, RoleId = 3, UserId = 3, ChangeDate = new DateTime(2025, 3, 23, 22, 48, 41), IsDeleted = false }
                );
            modelBuilder.Entity<LoyaltyProgram>().HasData(
                new LoyaltyProgram { LoyaltyProgramId = 1, ClientId = 1, Points = 34, Tier = LoyaltyTier.Silver, LastUpdated = new DateTime(2025, 6, 2, 12, 32, 03) },
                new LoyaltyProgram { LoyaltyProgramId = 2, ClientId = 2, Points = 29, Tier = LoyaltyTier.Bronze, LastUpdated = new DateTime(2025, 4, 1, 10, 52, 07) },
                new LoyaltyProgram { LoyaltyProgramId = 3, ClientId = 3, Points = 17, Tier = LoyaltyTier.Bronze, LastUpdated = new DateTime(2024, 5, 20, 10, 14, 01) }
            );

            modelBuilder.Entity<InsurancePackage>().HasData(
                new InsurancePackage { InsurancePackageId = 1, Name = "Basic Car Insurance", Description = "Essential coverage for your vehicle, including third-party liability and collision coverage.", Price = 199.99m, Picture = null, StateMachine = "active", DurationDays = 365 },
                new InsurancePackage { InsurancePackageId = 2, Name = "Comprehensive Home Insurance", Description = "Extensive protection for your home covering fire, theft, natural disasters, and personal liability.", Price = 349.50m, Picture = null, StateMachine = "active", DurationDays = 90 },
                new InsurancePackage { InsurancePackageId = 3, Name = "Premium Health Insurance", Description = "Premium medical coverage offering extensive benefits including hospitalization, dental care, and vision care.", Price = 499.00m, Picture = null, StateMachine = "active", DurationDays = 180 },
                new InsurancePackage { InsurancePackageId = 4, Name = "Travel Insurance Europe Family", Description = "Travel safely with your family across Europe. Coverage for medical emergencies, trip cancellations, and lost luggage for up to 4 persons.", Price = 179.99m, Picture = null, StateMachine = "active", DurationDays = 7 },
                new InsurancePackage { InsurancePackageId = 5, Name = "Pet Insurance", Description = "Protect your furry friends with coverage for vet bills, surgeries, and medications.", Price = 89.99m, Picture = null, StateMachine = "active", DurationDays = 180 },
                new InsurancePackage { InsurancePackageId = 6, Name = "Motorcycle Insurance", Description = "Specialized coverage for motorcycle riders including collision and liability protection.", Price = 149.99m, Picture = null, StateMachine = "active", DurationDays = 270 },
                new InsurancePackage { InsurancePackageId = 7, Name = "Student Health Plan", Description = "Affordable health insurance tailored for students with coverage for regular checkups and emergencies.", Price = 179.99m, Picture = null, StateMachine = "draft", DurationDays = 180 },
                new InsurancePackage { InsurancePackageId = 8, Name = "Casco Car Insurance", Description = "Comprehensive casco coverage for vehicles, including theft, vandalism, and natural disasters.", Price = 349.00m, Picture = null, StateMachine = "active", DurationDays = 365 },
                new InsurancePackage { InsurancePackageId = 9, Name = "Full Car Insurance", Description = "Ultimate car protection: covers basic, casco, and additional roadside assistance and legal support.", Price = 599.99m, Picture = null, StateMachine = "active", DurationDays = 365 },
                new InsurancePackage { InsurancePackageId = 10, Name = "Travel Insurance Europe Single", Description = "Coverage for single travelers exploring Europe, including medical emergencies and trip interruptions.", Price = 49.99m, Picture = null, StateMachine = "active", DurationDays = 7 },
                new InsurancePackage { InsurancePackageId = 11, Name = "Travel Insurance World Single", Description = "Global coverage for individual travelers: medical, lost luggage, trip delay, and emergency evacuation.", Price = 99.99m, Picture = null, StateMachine = "active", DurationDays = 14 },
                new InsurancePackage { InsurancePackageId = 12, Name = "Travel Insurance World Family", Description = "Complete travel insurance for your family worldwide. Includes 4 persons: medical, trip cancellation, and lost luggage.", Price = 189.99m, Picture = null, StateMachine = "active", DurationDays = 14 },
                new InsurancePackage { InsurancePackageId = 13, Name = "Flood Insurance", Description = "Protect your property from the financial consequences of flooding. Covers damage repair and replacement.", Price = 119.99m, Picture = null, StateMachine = "active", DurationDays = 180 },
                new InsurancePackage { InsurancePackageId = 14, Name = "Fire Insurance", Description = "Coverage against losses or damages caused by fire, including structural repairs and contents replacement.", Price = 109.99m, Picture = null, StateMachine = "active", DurationDays = 180 },
                new InsurancePackage { InsurancePackageId = 15, Name = "Burglary Insurance", Description = "Financial protection for your home and belongings in case of burglary or forced entry.", Price = 99.99m, Picture = null, StateMachine = "active", DurationDays = 180 },
                new InsurancePackage { InsurancePackageId = 16, Name = "Full Home Insurance", Description = "Complete package covering fire, flood, and burglary for total home security and peace of mind.", Price = 399.99m, Picture = null, StateMachine = "active", DurationDays = 180 },
                new InsurancePackage { InsurancePackageId = 17, Name = "Appliance Breakdown Insurance", Description = "Short-term coverage for essential home appliances such as refrigerators, washing machines, and ovens. Covers repair or replacement costs due to mechanical breakdowns.", Price = 39.99m, Picture = null, StateMachine = "active", DurationDays = 30 },
                new InsurancePackage { InsurancePackageId = 18, Name = "Bicycle Theft & Damage Insurance", Description = "Protect your bicycle against theft and accidental damage with this affordable 30-day plan. Suitable for daily commuters and recreational cyclists.", Price = 24.99m, Picture = null, StateMachine = "active", DurationDays = 30 }
            );

            modelBuilder.Entity<InsurancePolicy>().HasData(
                new InsurancePolicy { InsurancePolicyId = 1, InsurancePackageId = 1, ClientId = 1, StartDate = new DateTime(2025, 1, 1), EndDate = new DateTime(2026, 1, 1), IsActive = true, IsDeleted = false, HasActiveClaimRequest = true, IsNotificationSent = true, IsPaid = true },
                new InsurancePolicy { InsurancePolicyId = 2, InsurancePackageId = 2, ClientId = 1, StartDate = new DateTime(2025, 5, 15), EndDate = new DateTime(2025, 8, 13), IsActive = true, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = true, IsPaid = true },
                new InsurancePolicy { InsurancePolicyId = 3, InsurancePackageId = 3, ClientId = 2, StartDate = new DateTime(2025, 3, 1), EndDate = new DateTime(2025, 8, 28), IsActive = true, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = true, IsPaid = true },
                new InsurancePolicy { InsurancePolicyId = 4, InsurancePackageId = 1, ClientId = 2, StartDate = new DateTime(2025, 4, 1), EndDate = new DateTime(2026, 4, 1), IsActive = true, IsDeleted = false, HasActiveClaimRequest = true, IsNotificationSent = false, IsPaid = true },
                new InsurancePolicy { InsurancePolicyId = 5, InsurancePackageId = 2, ClientId = 3, StartDate = new DateTime(2025, 5, 20), EndDate = new DateTime(2025, 8, 18), IsActive = true, IsDeleted = false, HasActiveClaimRequest = true, IsNotificationSent = true, IsPaid = true },
                new InsurancePolicy { InsurancePolicyId = 6, InsurancePackageId = 3, ClientId = 1, StartDate = new DateTime(2024, 10, 1), EndDate = new DateTime(2025, 3, 30), IsActive = false, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = false, IsPaid = false },
                new InsurancePolicy { InsurancePolicyId = 7, InsurancePackageId = 4, ClientId = 1, StartDate = new DateTime(2025, 7, 5), EndDate = new DateTime(2025, 7, 19), IsActive = true, IsDeleted = false, HasActiveClaimRequest = false, IsNotificationSent = false, IsPaid = true }
            );

            modelBuilder.Entity<ClaimRequest>().HasData(
                new ClaimRequest { ClaimRequestId = 1, InsurancePolicyId = 1, Description = "Windshield damage due to hail.", EstimatedAmount = 350.00m, Status = "In progress", SubmittedAt = new DateTime(2025, 5, 1), UserId = null, Comment = null },
                new ClaimRequest { ClaimRequestId = 2, InsurancePolicyId = 2, Description = "Theft of insured vehicle.", Comment = "To high ammount requested.", EstimatedAmount = 5000.00m, Status = "Declined", SubmittedAt = new DateTime(2025, 5, 18), UserId = 1 },
                new ClaimRequest { ClaimRequestId = 3, InsurancePolicyId = 3, Description = "Fire damage in kitchen.", Comment = "Assessment required.", EstimatedAmount = 220.00m, Status = "Accepted", SubmittedAt = new DateTime(2025, 5, 5), UserId = 1 },
                new ClaimRequest { ClaimRequestId = 4, InsurancePolicyId = 4, Description = "Roof collapsed during storm.", EstimatedAmount = 4000.00m, Status = "In progress", SubmittedAt = new DateTime(2025, 5, 6), UserId = null, Comment = null },
                new ClaimRequest { ClaimRequestId = 5, InsurancePolicyId = 5, Description = "Broken window caused by vandalism.", EstimatedAmount = 120.00m, Status = "In progress", SubmittedAt = new DateTime(2025, 5, 28), UserId = null, Comment = null }
            );
            modelBuilder.Entity<Transaction>().HasData(
                new Transaction { TransactionId = 1, Amount = 197.99, TransactionDate = new DateTime(2025, 1, 1), PaymentMethod = "paypal", PaymentId = "transactiontest", PayerId = "transactiontest", ClientId = 1, InsurancePolicyId = 1 },
                new Transaction { TransactionId = 2, Amount = 346.00, TransactionDate = new DateTime(2025, 5, 15), PaymentMethod = "paypal", PaymentId = "transactiontest", PayerId = "transactiontest", ClientId = 1, InsurancePolicyId = 2 },
                new Transaction { TransactionId = 3, Amount = 494.00, TransactionDate = new DateTime(2025, 3, 1), PaymentMethod = "paypal", PaymentId = "transactiontest", PayerId = "transactiontest", ClientId = 2, InsurancePolicyId = 3 },
                new Transaction { TransactionId = 4, Amount = 197.00, TransactionDate = new DateTime(2025, 4, 1), PaymentMethod = "paypal", PaymentId = "transactiontest", PayerId = "transactiontest", ClientId = 2, InsurancePolicyId = 4 },
                new Transaction { TransactionId = 5, Amount = 346.00, TransactionDate = new DateTime(2025, 5, 20), PaymentMethod = "paypal", PaymentId = "transactiontest", PayerId = "transactiontest", ClientId = 3, InsurancePolicyId = 5 },
                new Transaction { TransactionId = 6, Amount = 170.99, TransactionDate = new DateTime(2025, 6, 2), PaymentMethod = "paypal", PaymentId = "transactiontest", PayerId = "transactiontest", ClientId = 1, InsurancePolicyId = 7 }
            );

            modelBuilder.Entity<ClientFeedback>().HasData(
                new ClientFeedback { ClientFeedbackId = 1, InsurancePackageId = 1, InsurancePolicyId = 1, ClientId = 1, Rating = 5, Comment = "Great experience!", CreatedAt = new DateTime(2025, 1, 2) },
                new ClientFeedback { ClientFeedbackId = 2, InsurancePackageId = 2, InsurancePolicyId = 2, ClientId = 1, Rating = 4, Comment = "Good service.", CreatedAt = new DateTime(2025, 5, 16) },
                new ClientFeedback { ClientFeedbackId = 3, InsurancePackageId = 3, InsurancePolicyId = 3, ClientId = 2, Rating = 3, Comment = "Average coverage.", CreatedAt = new DateTime(2025, 3, 2), IsDeleted = true, DeletionTime = new DateTime(2025, 6, 6) },
                new ClientFeedback { ClientFeedbackId = 4, InsurancePackageId = 4, InsurancePolicyId = 4, ClientId = 2, Rating = 4, Comment = "Family policy was useful.", CreatedAt = new DateTime(2025, 4, 2) },
                new ClientFeedback { ClientFeedbackId = 5, InsurancePackageId = 2, InsurancePolicyId = 5, ClientId = 3, Rating = 5, Comment = "Quick claim approval.", CreatedAt = new DateTime(2025, 5, 21), IsDeleted = true, DeletionTime = new DateTime(2025, 6, 6) },
                new ClientFeedback { ClientFeedbackId = 6, InsurancePackageId = 4, InsurancePolicyId = 7, ClientId = 1, Rating = 5, Comment = "Travel insurance was perfect!", CreatedAt = new DateTime(2025, 6, 3) }
            );
            modelBuilder.Entity<Notification>().HasData(
                new Notification { NotificationId = 1, ClientId = 1, UserId = 1, InsurancePolicyId = 2, Message = "Your policy is expiring on: 13.8.2025.", SentAt = new DateTime(2025, 5, 10), IsRead = false },
                new Notification { NotificationId = 2, ClientId = 2, UserId = 1, InsurancePolicyId = 3, Message = "Your policy is expiring on: 28.8.2025", SentAt = new DateTime(2025, 5, 12), IsRead = false },
                new Notification { NotificationId = 3, ClientId = 3, UserId = 1, InsurancePolicyId = 5, Message = "Your policy is expiring on: 18.8.2025.", SentAt = new DateTime(2025, 5, 15), IsRead = false },
                new Notification { NotificationId = 4, ClientId = 1, UserId = 1, InsurancePolicyId = 1, Message = "Your policy is expiring on: 1.1.2026.", SentAt = new DateTime(2025, 6, 2), IsRead = false }
            );
            modelBuilder.Entity<SupportTicket>().HasData(
                new SupportTicket { SupportTicketId = 1, ClientId = 1, UserId = 1, Subject = "Policy Coverage Details", Message = "Can you explain what is covered in my policy?", Reply = "Your policy covers vehicle damage, theft, and third-party liability.", CreatedAt = new DateTime(2025, 5, 5), IsAnswered = true, IsClosed = true },
                new SupportTicket { SupportTicketId = 2, ClientId = 1, UserId = null, Subject = "Unable to make payment", Message = "I’m facing issues while making payment through Stripe.", Reply = null, CreatedAt = new DateTime(2025, 5, 8), IsAnswered = false, IsClosed = true },
                new SupportTicket { SupportTicketId = 3, ClientId = 1, UserId = 1, Subject = "Claim Status", Message = "What is the current status of my claim request?", Reply = "Your claim request is being processed and will be resolved within 3 business days.", CreatedAt = new DateTime(2025, 5, 12), IsAnswered = true, IsClosed = true },
                new SupportTicket { SupportTicketId = 4, ClientId = 2, UserId = 1, Subject = "Update contact information", Message = "How can I change my registered email address?", Reply = "Please navigate to the profile section to update your contact details.", CreatedAt = new DateTime(2025, 5, 15), IsAnswered = true, IsClosed = true },
                new SupportTicket { SupportTicketId = 5, ClientId = 3, UserId = null, Subject = "Policy expiration alert", Message = "Why did I not receive an alert before my policy expired?", Reply = null, CreatedAt = new DateTime(2025, 5, 20), IsAnswered = false, IsClosed = false }
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

            modelBuilder.Entity<Transaction>()
                .HasOne(t => t.Client)
                .WithMany()
                .HasForeignKey(t => t.ClientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Transaction>()
                .HasOne(t => t.InsurancePolicy)
                .WithMany(p => p.Transactions) 
                .HasForeignKey(t => t.InsurancePolicyId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<SupportTicket>()
                .HasOne(t => t.Client)
                .WithMany(p => p.SupportTickets)
                .HasForeignKey(t => t.ClientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<ClientFeedback>()
                .HasOne(x => x.InsurancePolicy)
                .WithMany()
                .HasForeignKey(x => x.InsurancePolicyId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<LoyaltyProgram>()
                .HasOne(x => x.Client)
                .WithMany()
                .HasForeignKey(x => x.ClientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<InsurancePackage>()
                .Property(x => x.Price)
                .HasPrecision(10, 2);

            modelBuilder.Entity<ClaimRequest>()
                .Property(x => x.EstimatedAmount)
                .HasPrecision(10, 2);



        }
    }
}
