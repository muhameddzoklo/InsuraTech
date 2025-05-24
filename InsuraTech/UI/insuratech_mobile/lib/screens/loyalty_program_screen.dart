import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/loyalty_program.dart';
import 'package:insuratech_mobile/providers/utils.dart';

class LoyaltyProgramScreen extends StatelessWidget {
  final LoyaltyProgram loyaltyProgram;

  const LoyaltyProgramScreen({super.key, required this.loyaltyProgram});

  String getTierRequirements(int? tier) {
    switch (tier) {
      case 1:
        return "0 - 100 points";
      case 2:
        return "101 - 250 points";
      case 3:
        return "251 - 500 points";
      case 4:
        return "501+ points";
      default:
        return "-";
    }
  }

  String getDiscount(int? tier) {
    switch (tier) {
      case 1:
        return "1%";
      case 2:
        return "5%";
      case 3:
        return "10%";
      case 4:
        return "15%";
      default:
        return "0%";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      appBarTitle: "Loyalty Program",
      child: Container(
        color: const Color(0xFFE4E0C8),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: const Color.fromARGB(255, 238, 235, 233),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getLoyaltyTierColor(loyaltyProgram.tier),
                    child: const Icon(Icons.star, color: Colors.white),
                  ),
                  title: Text(
                    "Your Tier: ${getLoyaltyTierName(loyaltyProgram.tier)}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: getLoyaltyTierColor(loyaltyProgram.tier),
                    ),
                  ),
                  subtitle: Text(
                    "Points: ${loyaltyProgram.points ?? 0}\nLast Updated: ${formatDateString(loyaltyProgram.lastUpdated)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Tier Requirements & Discounts",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 10),
              _buildTierInfo(
                "Bronze",
                "0 - 100 points",
                "1%",
                const Color(0xFFCD7F32),
              ),
              _buildTierInfo(
                "Silver",
                "101 - 250 points",
                "5%",
                const Color(0xFFC0C0C0),
              ),
              _buildTierInfo(
                "Gold",
                "251 - 500 points",
                "10%",
                const Color(0xFFFFD700),
              ),
              _buildTierInfo(
                "Platinum",
                "501+ points",
                "15%",
                const Color(0xFF2196F3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierInfo(
    String name,
    String range,
    String discount,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.star, color: Colors.white),
        ),
        title: Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        subtitle: Text("Points: $range\nDiscount: $discount"),
      ),
    );
  }
}
