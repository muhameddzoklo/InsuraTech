using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace InsuraTech.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Clients",
                columns: table => new
                {
                    ClientId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Username = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FirstName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ProfilePicture = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    RegistrationDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Clients", x => x.ClientId);
                });

            migrationBuilder.CreateTable(
                name: "InsurancePackages",
                columns: table => new
                {
                    InsurancePackageId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Price = table.Column<decimal>(type: "decimal(10,2)", precision: 10, scale: 2, nullable: false),
                    Picture = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    StateMachine = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DurationDays = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InsurancePackages", x => x.InsurancePackageId);
                });

            migrationBuilder.CreateTable(
                name: "Roles",
                columns: table => new
                {
                    RoleId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RoleName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Roles", x => x.RoleId);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FirstName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Username = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LastName = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PhoneNumber = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PasswordHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    PasswordSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ProfilePicture = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.UserId);
                });

            migrationBuilder.CreateTable(
                name: "LoyaltyPrograms",
                columns: table => new
                {
                    LoyaltyProgramId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    Points = table.Column<int>(type: "int", nullable: false),
                    Tier = table.Column<int>(type: "int", nullable: false),
                    LastUpdated = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_LoyaltyPrograms", x => x.LoyaltyProgramId);
                    table.ForeignKey(
                        name: "FK_LoyaltyPrograms_Clients_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Clients",
                        principalColumn: "ClientId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "InsurancePolicies",
                columns: table => new
                {
                    InsurancePolicyId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    InsurancePackageId = table.Column<int>(type: "int", nullable: false),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsActive = table.Column<bool>(type: "bit", nullable: false),
                    HasActiveClaimRequest = table.Column<bool>(type: "bit", nullable: false),
                    IsNotificationSent = table.Column<bool>(type: "bit", nullable: false),
                    IsPaid = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InsurancePolicies", x => x.InsurancePolicyId);
                    table.ForeignKey(
                        name: "FK_InsurancePolicies_Clients_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Clients",
                        principalColumn: "ClientId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_InsurancePolicies_InsurancePackages_InsurancePackageId",
                        column: x => x.InsurancePackageId,
                        principalTable: "InsurancePackages",
                        principalColumn: "InsurancePackageId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "SupportTickets",
                columns: table => new
                {
                    SupportTicketId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: true),
                    Subject = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Reply = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsAnswered = table.Column<bool>(type: "bit", nullable: false),
                    IsClosed = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SupportTickets", x => x.SupportTicketId);
                    table.ForeignKey(
                        name: "FK_SupportTickets_Clients_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Clients",
                        principalColumn: "ClientId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_SupportTickets_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "UserRoles",
                columns: table => new
                {
                    UserRoleId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    RoleId = table.Column<int>(type: "int", nullable: false),
                    ChangeDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserRoles", x => x.UserRoleId);
                    table.ForeignKey(
                        name: "FK_UserRoles_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "RoleId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_UserRoles_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ClaimRequests",
                columns: table => new
                {
                    ClaimRequestId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    InsurancePolicyId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EstimatedAmount = table.Column<decimal>(type: "decimal(10,2)", precision: 10, scale: 2, nullable: false),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    SubmittedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ClaimRequests", x => x.ClaimRequestId);
                    table.ForeignKey(
                        name: "FK_ClaimRequests_InsurancePolicies_InsurancePolicyId",
                        column: x => x.InsurancePolicyId,
                        principalTable: "InsurancePolicies",
                        principalColumn: "InsurancePolicyId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ClaimRequests_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "ClientFeedbacks",
                columns: table => new
                {
                    ClientFeedbackId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    InsurancePackageId = table.Column<int>(type: "int", nullable: false),
                    InsurancePolicyId = table.Column<int>(type: "int", nullable: false),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ClientFeedbacks", x => x.ClientFeedbackId);
                    table.ForeignKey(
                        name: "FK_ClientFeedbacks_Clients_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Clients",
                        principalColumn: "ClientId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ClientFeedbacks_InsurancePackages_InsurancePackageId",
                        column: x => x.InsurancePackageId,
                        principalTable: "InsurancePackages",
                        principalColumn: "InsurancePackageId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ClientFeedbacks_InsurancePolicies_InsurancePolicyId",
                        column: x => x.InsurancePolicyId,
                        principalTable: "InsurancePolicies",
                        principalColumn: "InsurancePolicyId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    NotificationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: true),
                    InsurancePolicyId = table.Column<int>(type: "int", nullable: false),
                    Message = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SentAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsRead = table.Column<bool>(type: "bit", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.NotificationId);
                    table.ForeignKey(
                        name: "FK_Notifications_Clients_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Clients",
                        principalColumn: "ClientId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Notifications_InsurancePolicies_InsurancePolicyId",
                        column: x => x.InsurancePolicyId,
                        principalTable: "InsurancePolicies",
                        principalColumn: "InsurancePolicyId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Notifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId");
                });

            migrationBuilder.CreateTable(
                name: "Transactions",
                columns: table => new
                {
                    TransactionId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Amount = table.Column<double>(type: "float", nullable: false),
                    TransactionDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    PaymentMethod = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PaymentId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    PayerId = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ClientId = table.Column<int>(type: "int", nullable: false),
                    InsurancePolicyId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transactions", x => x.TransactionId);
                    table.ForeignKey(
                        name: "FK_Transactions_Clients_ClientId",
                        column: x => x.ClientId,
                        principalTable: "Clients",
                        principalColumn: "ClientId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Transactions_InsurancePolicies_InsurancePolicyId",
                        column: x => x.InsurancePolicyId,
                        principalTable: "InsurancePolicies",
                        principalColumn: "InsurancePolicyId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "Clients",
                columns: new[] { "ClientId", "DeletionTime", "Email", "FirstName", "IsActive", "IsDeleted", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ProfilePicture", "RegistrationDate", "Username" },
                values: new object[,]
                {
                    { 1, null, "john.doe@example.com", "John", true, false, "Doe", "8OB3D2RPgagepehex0hLz6HdM1Q=", "mGr/PGoIDO5ILaJYl3MvJg==", "068225599", null, new DateTime(2024, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified), "mobile" },
                    { 2, null, "clara.wong@example.com", "Clara", true, false, "Wong", "8OB3D2RPgagepehex0hLz6HdM1Q=", "mGr/PGoIDO5ILaJYl3MvJg==", "068113399", null, new DateTime(2024, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified), "claraW" },
                    { 3, null, "martin.taylor@example.com", "Martin", true, false, "Taylor", "8OB3D2RPgagepehex0hLz6HdM1Q=", "mGr/PGoIDO5ILaJYl3MvJg==", "068224400", null, new DateTime(2024, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified), "martinT" }
                });

            migrationBuilder.InsertData(
                table: "InsurancePackages",
                columns: new[] { "InsurancePackageId", "DeletionTime", "Description", "DurationDays", "IsDeleted", "Name", "Picture", "Price", "StateMachine" },
                values: new object[,]
                {
                    { 1, null, "Essential coverage for your vehicle, including third-party liability and collision coverage.", 365, false, "Basic Car Insurance", null, 199.99m, "active" },
                    { 2, null, "Extensive protection for your home covering fire, theft, natural disasters, and personal liability.", 90, false, "Comprehensive Home Insurance", null, 349.50m, "active" },
                    { 3, null, "Premium medical coverage offering extensive benefits including hospitalization, dental care, and vision care.", 180, false, "Premium Health Insurance", null, 499.00m, "active" },
                    { 4, null, "Travel safely with your family across Europe. Coverage for medical emergencies, trip cancellations, and lost luggage for up to 4 persons.", 7, false, "Travel Insurance Europe Family", null, 179.99m, "active" },
                    { 5, null, "Protect your furry friends with coverage for vet bills, surgeries, and medications.", 180, false, "Pet Insurance", null, 89.99m, "active" },
                    { 6, null, "Specialized coverage for motorcycle riders including collision and liability protection.", 270, false, "Motorcycle Insurance", null, 149.99m, "active" },
                    { 7, null, "Affordable health insurance tailored for students with coverage for regular checkups and emergencies.", 180, false, "Student Health Plan", null, 179.99m, "draft" },
                    { 8, null, "Comprehensive casco coverage for vehicles, including theft, vandalism, and natural disasters.", 365, false, "Casco Car Insurance", null, 349.00m, "active" },
                    { 9, null, "Ultimate car protection: covers basic, casco, and additional roadside assistance and legal support.", 365, false, "Full Car Insurance", null, 599.99m, "active" },
                    { 10, null, "Coverage for single travelers exploring Europe, including medical emergencies and trip interruptions.", 7, false, "Travel Insurance Europe Single", null, 49.99m, "active" },
                    { 11, null, "Global coverage for individual travelers: medical, lost luggage, trip delay, and emergency evacuation.", 14, false, "Travel Insurance World Single", null, 99.99m, "active" },
                    { 12, null, "Complete travel insurance for your family worldwide. Includes 4 persons: medical, trip cancellation, and lost luggage.", 14, false, "Travel Insurance World Family", null, 189.99m, "active" },
                    { 13, null, "Protect your property from the financial consequences of flooding. Covers damage repair and replacement.", 180, false, "Flood Insurance", null, 119.99m, "active" },
                    { 14, null, "Coverage against losses or damages caused by fire, including structural repairs and contents replacement.", 180, false, "Fire Insurance", null, 109.99m, "active" },
                    { 15, null, "Financial protection for your home and belongings in case of burglary or forced entry.", 180, false, "Burglary Insurance", null, 99.99m, "active" },
                    { 16, null, "Complete package covering fire, flood, and burglary for total home security and peace of mind.", 180, false, "Full Home Insurance", null, 399.99m, "active" },
                    { 17, null, "Short-term coverage for essential home appliances such as refrigerators, washing machines, and ovens. Covers repair or replacement costs due to mechanical breakdowns.", 30, false, "Appliance Breakdown Insurance", null, 39.99m, "active" },
                    { 18, null, "Protect your bicycle against theft and accidental damage with this affordable 30-day plan. Suitable for daily commuters and recreational cyclists.", 30, false, "Bicycle Theft & Damage Insurance", null, 24.99m, "active" }
                });

            migrationBuilder.InsertData(
                table: "Roles",
                columns: new[] { "RoleId", "DeletionTime", "Description", "IsDeleted", "RoleName" },
                values: new object[,]
                {
                    { 1, null, "Administrator with full access to settings, user permissions and platform operations.", false, "Admin" },
                    { 2, null, "An Insurance Agent manages policies, processes claims, and assists customers with recommendations and approvals.", false, "Agent" },
                    { 3, null, "Supports insurance agents by handling administrative tasks, managing client inquiries, and processing policy updates", false, "Assistant" }
                });

            migrationBuilder.InsertData(
                table: "Users",
                columns: new[] { "UserId", "DeletionTime", "Email", "FirstName", "IsActive", "IsDeleted", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ProfilePicture", "Username" },
                values: new object[,]
                {
                    { 1, null, "admin@example.com", "Liam", true, false, "Schneider", "+zHjeAMut/qVPctS7uaREf4lN1w=", "sOQz4gFWKGh9SeOhqXpqyw==", "069000111", null, "desktop" },
                    { 2, null, "agent@example.com", "Emily", true, false, "Carter", "9hkvRabWkVOkr+Hqr52lzoMKiKo=", "2ICZgybWHKj+fYpTc6/19g==", "069000222", null, "agent" },
                    { 3, null, "assistant@example.com", "Sofia", true, false, "Alvarez", "sfrZuf7hqepHmMV6gt83a/RaB9g=", "Ct53DBogAC4vUxlb2WodgQ==", "069000333", null, "assistant" }
                });

            migrationBuilder.InsertData(
                table: "InsurancePolicies",
                columns: new[] { "InsurancePolicyId", "ClientId", "DeletionTime", "EndDate", "HasActiveClaimRequest", "InsurancePackageId", "IsActive", "IsDeleted", "IsNotificationSent", "IsPaid", "StartDate" },
                values: new object[,]
                {
                    { 1, 1, null, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, 1, true, false, true, true, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 1, null, new DateTime(2025, 8, 13, 0, 0, 0, 0, DateTimeKind.Unspecified), false, 2, true, false, true, true, new DateTime(2025, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, 2, null, new DateTime(2025, 8, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), false, 3, true, false, true, true, new DateTime(2025, 3, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 4, 2, null, new DateTime(2026, 4, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, 1, true, false, false, true, new DateTime(2025, 4, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 5, 3, null, new DateTime(2025, 8, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), true, 2, true, false, true, true, new DateTime(2025, 5, 20, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 6, 1, null, new DateTime(2025, 3, 30, 0, 0, 0, 0, DateTimeKind.Unspecified), false, 3, false, false, false, false, new DateTime(2024, 10, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 7, 1, null, new DateTime(2025, 7, 19, 0, 0, 0, 0, DateTimeKind.Unspecified), false, 4, true, false, false, true, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "LoyaltyPrograms",
                columns: new[] { "LoyaltyProgramId", "ClientId", "DeletionTime", "IsDeleted", "LastUpdated", "Points", "Tier" },
                values: new object[,]
                {
                    { 1, 1, null, false, new DateTime(2025, 6, 2, 12, 32, 3, 0, DateTimeKind.Unspecified), 34, 1 },
                    { 2, 2, null, false, new DateTime(2025, 4, 1, 10, 52, 7, 0, DateTimeKind.Unspecified), 29, 0 },
                    { 3, 3, null, false, new DateTime(2024, 5, 20, 10, 14, 1, 0, DateTimeKind.Unspecified), 17, 0 }
                });

            migrationBuilder.InsertData(
                table: "SupportTickets",
                columns: new[] { "SupportTicketId", "ClientId", "CreatedAt", "DeletionTime", "IsAnswered", "IsClosed", "IsDeleted", "Message", "Reply", "Subject", "UserId" },
                values: new object[,]
                {
                    { 1, 1, new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, true, false, "Can you explain what is covered in my policy?", "Your policy covers vehicle damage, theft, and third-party liability.", "Policy Coverage Details", 1 },
                    { 2, 1, new DateTime(2025, 5, 8, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, true, false, "I’m facing issues while making payment through Stripe.", null, "Unable to make payment", null },
                    { 3, 1, new DateTime(2025, 5, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, true, false, "What is the current status of my claim request?", "Your claim request is being processed and will be resolved within 3 business days.", "Claim Status", 1 },
                    { 4, 2, new DateTime(2025, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, true, false, "How can I change my registered email address?", "Please navigate to the profile section to update your contact details.", "Update contact information", 1 },
                    { 5, 3, new DateTime(2025, 5, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), null, false, false, false, "Why did I not receive an alert before my policy expired?", null, "Policy expiration alert", null }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "UserRoleId", "ChangeDate", "DeletionTime", "IsDeleted", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 1, 1 },
                    { 2, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 2, 2 },
                    { 3, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 3, 3 }
                });

            migrationBuilder.InsertData(
                table: "ClaimRequests",
                columns: new[] { "ClaimRequestId", "Comment", "DeletionTime", "Description", "EstimatedAmount", "InsurancePolicyId", "IsDeleted", "Status", "SubmittedAt", "UserId" },
                values: new object[,]
                {
                    { 1, null, null, "Windshield damage due to hail.", 350.00m, 1, false, "In progress", new DateTime(2025, 5, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null },
                    { 2, "To high ammount requested.", null, "Theft of insured vehicle.", 5000.00m, 2, false, "Declined", new DateTime(2025, 5, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), 1 },
                    { 3, "Assessment required.", null, "Fire damage in kitchen.", 220.00m, 3, false, "Accepted", new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 1 },
                    { 4, null, null, "Roof collapsed during storm.", 4000.00m, 4, false, "In progress", new DateTime(2025, 5, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), null },
                    { 5, null, null, "Broken window caused by vandalism.", 120.00m, 5, false, "In progress", new DateTime(2025, 5, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), null }
                });

            migrationBuilder.InsertData(
                table: "ClientFeedbacks",
                columns: new[] { "ClientFeedbackId", "ClientId", "Comment", "CreatedAt", "DeletionTime", "InsurancePackageId", "InsurancePolicyId", "IsDeleted", "Rating" },
                values: new object[,]
                {
                    { 1, 1, "Great experience!", new DateTime(2025, 1, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 1, 1, false, 5 },
                    { 2, 1, "Good service.", new DateTime(2025, 5, 16, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 2, 2, false, 4 },
                    { 3, 2, "Average coverage.", new DateTime(2025, 3, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, 3, true, 3 },
                    { 4, 2, "Family policy was useful.", new DateTime(2025, 4, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 4, 4, false, 4 },
                    { 5, 3, "Quick claim approval.", new DateTime(2025, 5, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 6, 6, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 5, true, 5 },
                    { 6, 1, "Travel insurance was perfect!", new DateTime(2025, 6, 3, 0, 0, 0, 0, DateTimeKind.Unspecified), null, 4, 7, false, 5 }
                });

            migrationBuilder.InsertData(
                table: "Notifications",
                columns: new[] { "NotificationId", "ClientId", "DeletionTime", "InsurancePolicyId", "IsDeleted", "IsRead", "Message", "SentAt", "UserId" },
                values: new object[,]
                {
                    { 1, 1, null, 2, false, false, "Your policy is expiring on: 13.8.2025.", new DateTime(2025, 5, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 1 },
                    { 2, 2, null, 3, false, false, "Your policy is expiring on: 28.8.2025", new DateTime(2025, 5, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 1 },
                    { 3, 3, null, 5, false, false, "Your policy is expiring on: 18.8.2025.", new DateTime(2025, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 1 },
                    { 4, 1, null, 1, false, false, "Your policy is expiring on: 1.1.2026.", new DateTime(2025, 6, 2, 0, 0, 0, 0, DateTimeKind.Unspecified), 1 }
                });

            migrationBuilder.InsertData(
                table: "Transactions",
                columns: new[] { "TransactionId", "Amount", "ClientId", "DeletionTime", "InsurancePolicyId", "IsDeleted", "PayerId", "PaymentId", "PaymentMethod", "TransactionDate" },
                values: new object[,]
                {
                    { 1, 197.99000000000001, 1, null, 1, false, "transactiontest", "transactiontest", "paypal", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 346.0, 1, null, 2, false, "transactiontest", "transactiontest", "paypal", new DateTime(2025, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, 494.0, 2, null, 3, false, "transactiontest", "transactiontest", "paypal", new DateTime(2025, 3, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 4, 197.0, 2, null, 4, false, "transactiontest", "transactiontest", "paypal", new DateTime(2025, 4, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 5, 346.0, 3, null, 5, false, "transactiontest", "transactiontest", "paypal", new DateTime(2025, 5, 20, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 6, 170.99000000000001, 1, null, 7, false, "transactiontest", "transactiontest", "paypal", new DateTime(2025, 6, 2, 0, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.CreateIndex(
                name: "IX_ClaimRequests_InsurancePolicyId",
                table: "ClaimRequests",
                column: "InsurancePolicyId");

            migrationBuilder.CreateIndex(
                name: "IX_ClaimRequests_UserId",
                table: "ClaimRequests",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_ClientFeedbacks_ClientId",
                table: "ClientFeedbacks",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_ClientFeedbacks_InsurancePackageId",
                table: "ClientFeedbacks",
                column: "InsurancePackageId");

            migrationBuilder.CreateIndex(
                name: "IX_ClientFeedbacks_InsurancePolicyId",
                table: "ClientFeedbacks",
                column: "InsurancePolicyId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePolicies_ClientId",
                table: "InsurancePolicies",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePolicies_InsurancePackageId",
                table: "InsurancePolicies",
                column: "InsurancePackageId");

            migrationBuilder.CreateIndex(
                name: "IX_LoyaltyPrograms_ClientId",
                table: "LoyaltyPrograms",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_ClientId",
                table: "Notifications",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_InsurancePolicyId",
                table: "Notifications",
                column: "InsurancePolicyId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_SupportTickets_ClientId",
                table: "SupportTickets",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_SupportTickets_UserId",
                table: "SupportTickets",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_ClientId",
                table: "Transactions",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_InsurancePolicyId",
                table: "Transactions",
                column: "InsurancePolicyId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_RoleId",
                table: "UserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_UserRoles_UserId",
                table: "UserRoles",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ClaimRequests");

            migrationBuilder.DropTable(
                name: "ClientFeedbacks");

            migrationBuilder.DropTable(
                name: "LoyaltyPrograms");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "SupportTickets");

            migrationBuilder.DropTable(
                name: "Transactions");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "InsurancePolicies");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Clients");

            migrationBuilder.DropTable(
                name: "InsurancePackages");
        }
    }
}
