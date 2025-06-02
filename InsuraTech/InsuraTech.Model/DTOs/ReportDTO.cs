using System;
using System.Collections.Generic;

namespace InsuraTech.Model.DTOs
{
    public class ReportDTO
    {
        // Policies
        public int TotalPolicies { get; set; }
        public int ActivePolicies { get; set; }
        public int ExpiredPolicies { get; set; }
        public int PaidPolicies { get; set; }

        // Claim Requests
        public int TotalClaimRequests { get; set; }
        public int AcceptedClaims { get; set; }
        public int DeclinedClaims { get; set; }
        public int PendingClaims { get; set; }

        // Revenue
        public decimal TotalProfit { get; set; }
        public List<RevenuePerMonthDTO> ProfitPerMonth { get; set; } = new List<RevenuePerMonthDTO>();


        // Top Packages
        public List<TopPackageDTO> TopPackagesBySales { get; set; } = new List<TopPackageDTO>();


        // Feedback
        public int TotalReviews { get; set; }
        public double AveragePackageRating { get; set; }
    }

    public class RevenuePerMonthDTO
    {
        public string Month { get; set; } = string.Empty; // "2024-05"
        public decimal Profit { get; set; }
    }

    public class TopPackageDTO
    {
        public int InsurancePackageId { get; set; }
        public string Name { get; set; } = string.Empty;
        public int SoldPolicies { get; set; }
        public double? AverageRating { get; set; }
    }
}
