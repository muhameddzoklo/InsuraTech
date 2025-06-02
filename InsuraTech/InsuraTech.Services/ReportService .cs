using InsuraTech.Model.DTOs;
using InsuraTech.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InsuraTech.Services
{
    public class ReportService : IReportService
    {
        private readonly InsuraTechContext _context;

        public ReportService(InsuraTechContext context)
        {
            _context = context;
        }

        public async Task<ReportDTO> GetReportAsync(CancellationToken cancellationToken = default)
        {
            // --- POLICIES ---
            var policies = await _context.InsurancePolicies.ToListAsync(cancellationToken);
            var totalPolicies = policies.Count;
            var activePolicies = policies.Count(p => p.EndDate > DateTime.Now && p.IsPaid);
            var expiredPolicies = policies.Count(p => p.EndDate <= DateTime.Now && p.IsPaid);
            var paidPolicies = policies.Count(p => p.IsPaid);

            // --- CLAIM REQUESTS ---
            var claims = await _context.ClaimRequests.ToListAsync(cancellationToken);
            var totalClaimRequests = claims.Count;
            var acceptedClaims = claims.Count(c => c.Status == "Accepted");
            var declinedClaims = claims.Count(c => c.Status == "Declined");
            var pendingClaims = claims.Count(c => c.Status == "In progress");

            // --- REVENUE / PROFIT ---
            var totalProfit = await _context.Transactions
                .SumAsync(t => (decimal?)t.Amount, cancellationToken) ?? 0;

            // Profit po mjesecima (zadnjih 12)
            var profitPerMonth = (await _context.Transactions
                .Where(t => t.TransactionDate != null)
                .GroupBy(t => new { t.TransactionDate.Value.Year, t.TransactionDate.Value.Month })
                .Select(g => new
                {
                    Year = g.Key.Year,
                    Month = g.Key.Month,
                    Profit = g.Sum(x => x.Amount)
                })
                .OrderBy(x => x.Year)
                .ThenBy(x => x.Month)
                .ToListAsync(cancellationToken))
                .Select(x => new RevenuePerMonthDTO
                {
                    Month = $"{x.Year}-{x.Month:00}", // ovo je sad na C# strani!
                    Profit = (decimal)x.Profit
                })
                .ToList();


            // --- TOP PACKAGES BY SALES ---
            var topPackagesBySales = await _context.InsurancePolicies
                .Where(p => p.IsPaid)
                .GroupBy(p => new { p.InsurancePackageId, p.InsurancePackage.Name })
                .OrderByDescending(g => g.Count())
                .Select(g => new TopPackageDTO
                {
                    InsurancePackageId = g.Key.InsurancePackageId,
                    Name = g.Key.Name,
                    SoldPolicies = g.Count(),
                    // AverageRating se puni dole
                    AverageRating = 0
                })
                .Take(5)
                .ToListAsync(cancellationToken);

            // --- FEEDBACK (REVIEWS) ---
            var allFeedbacks = await _context.ClientFeedbacks
                .Where(f => !f.IsDeleted)
                .ToListAsync(cancellationToken);

            var totalReviews = allFeedbacks.Count;
            var averagePackageRating = allFeedbacks.Any() ? allFeedbacks.Average(f => f.Rating) : 0;

            // --- POPUNI RATING ZA TOP PACKAGES ---
            foreach (var pkg in topPackagesBySales)
            {
                var ratings = allFeedbacks.Where(f => f.InsurancePackageId == pkg.InsurancePackageId).ToList();
                pkg.AverageRating = ratings.Any() ? Math.Round(ratings.Average(f => f.Rating), 2) : (double?)null;
            }

            // FINAL RETURN
            return new ReportDTO
            {
                // Policies
                TotalPolicies = totalPolicies,
                ActivePolicies = activePolicies,
                ExpiredPolicies = expiredPolicies,
                PaidPolicies = paidPolicies,

                // Claim Requests
                TotalClaimRequests = totalClaimRequests,
                AcceptedClaims = acceptedClaims,
                DeclinedClaims = declinedClaims,
                PendingClaims = pendingClaims,

                // Revenue
                TotalProfit = totalProfit,
                ProfitPerMonth = profitPerMonth,

                // Top Packages
                TopPackagesBySales = topPackagesBySales,

                // Feedback
                TotalReviews = totalReviews,
                AveragePackageRating = Math.Round(averagePackageRating, 2)
            };
        }
    }
}
