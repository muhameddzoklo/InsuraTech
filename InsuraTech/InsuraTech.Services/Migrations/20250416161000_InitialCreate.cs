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
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InsurancePackages", x => x.InsurancePackageId);
                });

            migrationBuilder.CreateTable(
                name: "PaymentMethods",
                columns: table => new
                {
                    PaymentMethodId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    MethodName = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PaymentMethods", x => x.PaymentMethodId);
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
                    InsurancePackageId1 = table.Column<int>(type: "int", nullable: true),
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
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_InsurancePolicies_InsurancePackages_InsurancePackageId",
                        column: x => x.InsurancePackageId,
                        principalTable: "InsurancePackages",
                        principalColumn: "InsurancePackageId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_InsurancePolicies_InsurancePackages_InsurancePackageId1",
                        column: x => x.InsurancePackageId1,
                        principalTable: "InsurancePackages",
                        principalColumn: "InsurancePackageId");
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
                name: "Notifications",
                columns: table => new
                {
                    NotificationId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
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
                        name: "FK_Notifications_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "UserId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Transactions",
                columns: table => new
                {
                    TransactionId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Amount = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    PaymentMethodId = table.Column<int>(type: "int", nullable: false),
                    Timestamp = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Transactions", x => x.TransactionId);
                    table.ForeignKey(
                        name: "FK_Transactions_PaymentMethods_PaymentMethodId",
                        column: x => x.PaymentMethodId,
                        principalTable: "PaymentMethods",
                        principalColumn: "PaymentMethodId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_Transactions_Users_UserId",
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
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    EstimatedAmount = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    Status = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    SubmittedAt = table.Column<DateTime>(type: "datetime2", nullable: true),
                    InsurancePolicyId1 = table.Column<int>(type: "int", nullable: true),
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
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_ClaimRequests_InsurancePolicies_InsurancePolicyId1",
                        column: x => x.InsurancePolicyId1,
                        principalTable: "InsurancePolicies",
                        principalColumn: "InsurancePolicyId");
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

            migrationBuilder.CreateTable(
                name: "InsurancePackageClaims",
                columns: table => new
                {
                    InsurancePackageClaimId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    InsurancePackageId = table.Column<int>(type: "int", nullable: false),
                    ClaimRequestId = table.Column<int>(type: "int", nullable: false),
                    ClaimDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    ClaimAmount = table.Column<decimal>(type: "decimal(18,2)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_InsurancePackageClaims", x => x.InsurancePackageClaimId);
                    table.ForeignKey(
                        name: "FK_InsurancePackageClaims_ClaimRequests_ClaimRequestId",
                        column: x => x.ClaimRequestId,
                        principalTable: "ClaimRequests",
                        principalColumn: "ClaimRequestId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_InsurancePackageClaims_InsurancePackages_InsurancePackageId",
                        column: x => x.InsurancePackageId,
                        principalTable: "InsurancePackages",
                        principalColumn: "InsurancePackageId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.InsertData(
                table: "Clients",
                columns: new[] { "ClientId", "DeletionTime", "Email", "FirstName", "IsDeleted", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "ProfilePicture", "RegistrationDate", "Username" },
                values: new object[,]
                {
                    { 1, null, "client@mail.com", "Client", false, "Client", "uRq1YqSB0lg3cdpu9nd/KzSRItM=", "hJAv+NlOCMXaoDXa+MPk9A==", "000000003", null, new DateTime(2025, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified), "client" },
                    { 2, null, "client1@mail.com", "Client1", false, "Client1", "tLbv6EHzaanWRumREUrlGSf2XS0=", "oQ3qYpn5T8Z4n5nm5aGrvA==", "000000004", null, new DateTime(2025, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified), "client1" },
                    { 3, null, "client2@mail.com", "Client2", false, "Client2", "8OB3D2RPgagepehex0hLz6HdM1Q=", "mGr/PGoIDO5ILaJYl3MvJg==", "000000005", null, new DateTime(2025, 4, 16, 22, 52, 3, 0, DateTimeKind.Unspecified), "client2" }
                });

            migrationBuilder.InsertData(
                table: "InsurancePackages",
                columns: new[] { "InsurancePackageId", "DeletionTime", "Description", "IsDeleted", "Name", "Picture", "Price" },
                values: new object[,]
                {
                    { 1, null, "Essential coverage for your vehicle, including third-party liability and collision coverage.", false, "Basic Car Insurance", null, 199.99m },
                    { 2, null, "Extensive protection for your home covering fire, theft, natural disasters, and personal liability.", false, "Comprehensive Home Insurance", null, 349.50m },
                    { 3, null, "Premium medical coverage offering extensive benefits including hospitalization, dental care, and vision care.", false, "Premium Health Insurance", null, 499.00m }
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
                columns: new[] { "UserId", "DeletionTime", "Email", "FirstName", "IsDeleted", "LastName", "PasswordHash", "PasswordSalt", "PhoneNumber", "Username" },
                values: new object[,]
                {
                    { 1, null, "1", "1", false, "1", "XVDI7NKoOCtMiSrKR1uSSGWvA7o=", "NHVv+8KhAiQqFlz7k1P53Q==", "1", "1" },
                    { 2, null, "admin@mail.com", "Admin", false, "Admin", "+zHjeAMut/qVPctS7uaREf4lN1w=", "sOQz4gFWKGh9SeOhqXpqyw==", "000000000", "admin" },
                    { 3, null, "agent@mail.com", "Agent", false, "Agent", "9hkvRabWkVOkr+Hqr52lzoMKiKo=", "2ICZgybWHKj+fYpTc6/19g==", "000000001", "agent" },
                    { 4, null, "assistant@mail.com", "Assistant", false, "Assistant", "sfrZuf7hqepHmMV6gt83a/RaB9g=", "Ct53DBogAC4vUxlb2WodgQ==", "000000002", "assistant" }
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

            migrationBuilder.CreateIndex(
                name: "IX_ClaimRequests_InsurancePolicyId",
                table: "ClaimRequests",
                column: "InsurancePolicyId");

            migrationBuilder.CreateIndex(
                name: "IX_ClaimRequests_InsurancePolicyId1",
                table: "ClaimRequests",
                column: "InsurancePolicyId1");

            migrationBuilder.CreateIndex(
                name: "IX_CustomerFeedbacks_UserId",
                table: "CustomerFeedbacks",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePackageClaims_ClaimRequestId",
                table: "InsurancePackageClaims",
                column: "ClaimRequestId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePackageClaims_InsurancePackageId",
                table: "InsurancePackageClaims",
                column: "InsurancePackageId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePolicies_ClientId",
                table: "InsurancePolicies",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePolicies_InsurancePackageId",
                table: "InsurancePolicies",
                column: "InsurancePackageId");

            migrationBuilder.CreateIndex(
                name: "IX_InsurancePolicies_InsurancePackageId1",
                table: "InsurancePolicies",
                column: "InsurancePackageId1");

            migrationBuilder.CreateIndex(
                name: "IX_MessageLogs_UserId",
                table: "MessageLogs",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_PaymentMethodId",
                table: "Transactions",
                column: "PaymentMethodId");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_UserId",
                table: "Transactions",
                column: "UserId");

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
                name: "InsurancePackageClaims");

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
                name: "ClaimRequests");

            migrationBuilder.DropTable(
                name: "PaymentMethods");

            migrationBuilder.DropTable(
                name: "CustomerFeedbacks");

            migrationBuilder.DropTable(
                name: "Roles");

            migrationBuilder.DropTable(
                name: "InsurancePolicies");

            migrationBuilder.DropTable(
                name: "Users");

            migrationBuilder.DropTable(
                name: "Clients");

            migrationBuilder.DropTable(
                name: "InsurancePackages");
        }
    }
}
