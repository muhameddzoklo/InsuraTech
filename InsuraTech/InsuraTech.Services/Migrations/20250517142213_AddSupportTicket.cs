using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace InsuraTech.Services.Migrations
{
    /// <inheritdoc />
    public partial class AddSupportTicket : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "MessageLogs");

            migrationBuilder.DropTable(
                name: "UserFeedbacks");

            migrationBuilder.CreateTable(
                name: "SupportTickets",
                columns: table => new
                {
                    SupportTicketId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ClientId = table.Column<int>(type: "int", nullable: false),
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
                });

            migrationBuilder.CreateIndex(
                name: "IX_SupportTickets_ClientId",
                table: "SupportTickets",
                column: "ClientId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SupportTickets");

            migrationBuilder.CreateTable(
                name: "MessageLogs",
                columns: table => new
                {
                    MessageLogId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<int>(type: "int", nullable: false),
                    Content = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    DeletionTime = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    SentAt = table.Column<DateTime>(type: "datetime2", nullable: true)
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
                name: "UserFeedbacks",
                columns: table => new
                {
                    UserFeedbackId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CustomerFeedbackId = table.Column<int>(type: "int", nullable: false),
                    UserId = table.Column<int>(type: "int", nullable: false),
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

            migrationBuilder.CreateIndex(
                name: "IX_MessageLogs_UserId",
                table: "MessageLogs",
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
        }
    }
}
