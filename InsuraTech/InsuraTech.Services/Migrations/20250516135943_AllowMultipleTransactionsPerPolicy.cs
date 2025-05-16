using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace InsuraTech.Services.Migrations
{
    /// <inheritdoc />
    public partial class AllowMultipleTransactionsPerPolicy : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Transactions_InsurancePolicyId",
                table: "Transactions");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_InsurancePolicyId",
                table: "Transactions",
                column: "InsurancePolicyId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Transactions_InsurancePolicyId",
                table: "Transactions");

            migrationBuilder.CreateIndex(
                name: "IX_Transactions_InsurancePolicyId",
                table: "Transactions",
                column: "InsurancePolicyId",
                unique: true);
        }
    }
}
