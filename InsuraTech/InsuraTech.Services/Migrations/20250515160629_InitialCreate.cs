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
                    Price = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
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
                name: "CustomerFeedbacks",
                columns: table => new
                {
                    CustomerFeedbackId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Rating = table.Column<int>(type: "int", nullable: true),
                    SubmittedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CustomerFeedbacks", x => x.CustomerFeedbackId);
                    table.ForeignKey(
                        name: "FK_CustomerFeedbacks_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "MessageLogs",
                columns: table => new
                {
                    MessageLogId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SentAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_MessageLogs", x => x.MessageLogId);
                    table.ForeignKey(
                        name: "FK_MessageLogs_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
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
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Comment = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EstimatedAmount = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
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
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    NotificationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClientId = table.Column<int>(type: "int", nullable: false),
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

            migrationBuilder.CreateTable(
                name: "UserFeedbacks",
                columns: table => new
                {
                    UserFeedbackId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    CustomerFeedbackId = table.Column<int>(type: "int", nullable: false),
                    CustomerFeedbackId1 = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_UserFeedbacks", x => x.UserFeedbackId);
                    table.ForeignKey(
                        name: "FK_UserFeedbacks_CustomerFeedbacks_CustomerFeedbackId",
                        column: x => x.CustomerFeedbackId,
                        principalTable: "CustomerFeedbacks",
                        principalColumn: "CustomerFeedbackId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_UserFeedbacks_CustomerFeedbacks_CustomerFeedbackId1",
                        column: x => x.CustomerFeedbackId1,
                        principalTable: "CustomerFeedbacks",
                        principalColumn: "CustomerFeedbackId");
                    table.ForeignKey(
                        name: "FK_UserFeedbacks_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
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
                    { 4, null, "Covers medical emergencies, trip cancellations, and lost luggage during travel abroad.", 30, false, "Travel Insurance", null, 129.99m, "active" },
                    { 5, null, "Protect your furry friends with coverage for vet bills, surgeries, and medications.", 180, false, "Pet Insurance", null, 89.99m, "active" },
                    { 6, null, "Coverage for accidental damage, theft, and repairs for your electronic devices.", 365, false, "Electronics Protection Plan", null, 59.99m, "active" },
                    { 7, null, "Specialized coverage for motorcycle riders including collision and liability protection.", 270, false, "Motorcycle Insurance", null, 149.99m, "active" },
                    { 8, null, "Affordable health insurance tailored for students with coverage for regular checkups and emergencies.", 180, false, "Student Health Plan", null, 179.99m, "draft" }
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
                    { 1, null, "1", "1", true, false, "1", "XVDI7NKoOCtMiSrKR1uSSGWvA7o=", "NHVv+8KhAiQqFlz7k1P53Q==", "1", null, "1" },
                    { 2, null, "admin@mail.com", "Admin", true, false, "Admin", "+zHjeAMut/qVPctS7uaREf4lN1w=", "sOQz4gFWKGh9SeOhqXpqyw==", "000000000", null, "admin" },
                    { 3, null, "agent@mail.com", "Agent", true, false, "Agent", "9hkvRabWkVOkr+Hqr52lzoMKiKo=", "2ICZgybWHKj+fYpTc6/19g==", "000000001", null, "agent" },
                    { 4, null, "assistant@mail.com", "Assistant", true, false, "Assistant", "sfrZuf7hqepHmMV6gt83a/RaB9g=", "Ct53DBogAC4vUxlb2WodgQ==", "000000002", null, "assistant" }
                });

            migrationBuilder.InsertData(
                table: "InsurancePolicies",
                columns: new[] { "InsurancePolicyId", "ClientId", "DeletionTime", "EndDate", "HasActiveClaimRequest", "InsurancePackageId", "IsActive", "IsDeleted", "IsNotificationSent", "IsPaid", "StartDate" },
                values: new object[,]
                {
                    { 1, 1, null, new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, 1, true, false, false, true, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, 1, null, new DateTime(2025, 8, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), false, 2, true, false, false, true, new DateTime(2025, 5, 15, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, 2, null, new DateTime(2025, 8, 28, 0, 0, 0, 0, DateTimeKind.Unspecified), false, 3, true, false, false, true, new DateTime(2025, 3, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 4, 2, null, new DateTime(2026, 4, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), true, 1, true, false, false, true, new DateTime(2025, 4, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 5, 3, null, new DateTime(2025, 8, 18, 0, 0, 0, 0, DateTimeKind.Unspecified), true, 2, true, false, false, true, new DateTime(2025, 5, 20, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 6, 1, null, new DateTime(2025, 3, 29, 0, 0, 0, 0, DateTimeKind.Unspecified), false, 3, false, false, false, false, new DateTime(2024, 10, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.InsertData(
                table: "UserRoles",
                columns: new[] { "UserRoleId", "ChangeDate", "DeletionTime", "IsDeleted", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 1, 1 },
                    { 2, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 1, 2 },
                    { 3, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 2, 3 },
                    { 4, new DateTime(2025, 3, 23, 22, 48, 41, 0, DateTimeKind.Unspecified), null, false, 3, 4 }
                });

            migrationBuilder.InsertData(
                table: "ClaimRequests",
                columns: new[] { "ClaimRequestId", "Comment", "DeletionTime", "Description", "EstimatedAmount", "InsurancePolicyId", "IsDeleted", "Status", "SubmittedAt" },
                values: new object[,]
                {
                    { 1, null, null, "Windshield damage due to hail.", 350.00m, 1, false, "In progress", new DateTime(2025, 5, 1, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 2, "To high ammount requested.", null, "Theft of insured vehicle.", 5000.00m, 2, false, "Declined", new DateTime(2025, 5, 18, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 3, "Assessment required.", null, "Fire damage in kitchen.", 220.00m, 3, false, "Accepted", new DateTime(2025, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 4, null, null, "Roof collapsed during storm.", 4000.00m, 4, false, "In progress", new DateTime(2025, 5, 6, 0, 0, 0, 0, DateTimeKind.Unspecified) },
                    { 5, null, null, "Broken window caused by vandalism.", 120.00m, 5, false, "In progress", new DateTime(2025, 5, 28, 0, 0, 0, 0, DateTimeKind.Unspecified) }
                });

            migrationBuilder.CreateIndex(
                name: "IX_ClaimRequests_InsurancePolicyId",
                table: "ClaimRequests",
                column: "InsurancePolicyId");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerFeedbacks_UserId",
                table: "CustomerFeedbacks",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePolicies_ClientId",
                table: "InsurancePolicies",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePolicies_InsurancePackageId",
                table: "InsurancePolicies",
                column: "InsurancePackageId");

            migrationBuilder.CreateIndex(
                name: "IX_MessageLogs_UserId",
                table: "MessageLogs",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_ClientId",
                table: "Notifications",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_InsurancePolicyId",
                table: "Notifications",
                column: "InsurancePolicyId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_ClientId",
                table: "Transactions",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_InsurancePolicyId",
                table: "Transactions",
                column: "InsurancePolicyId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserFeedbacks_CustomerFeedbackId",
                table: "UserFeedbacks",
                column: "CustomerFeedbackId");

            migrationBuilder.CreateIndex(
                name: "IX_UserFeedbacks_CustomerFeedbackId1",
                table: "UserFeedbacks",
                column: "CustomerFeedbackId1");

            migrationBuilder.CreateIndex(
                name: "IX_UserFeedbacks_UserId",
                table: "UserFeedbacks",
                column: "UserId");

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
                name: "MessageLogs");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "Transactions");

            migrationBuilder.DropTable(
                name: "UserFeedbacks");

            migrationBuilder.DropTable(
                name: "UserRoles");

            migrationBuilder.DropTable(
                name: "InsurancePolicies");

            migrationBuilder.DropTable(
                name: "CustomerFeedbacks");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "Clients");

            migrationBuilder.DropTable(
                name: "InsurancePackages");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
