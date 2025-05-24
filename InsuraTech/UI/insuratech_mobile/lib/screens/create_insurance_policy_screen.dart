import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:insuratech_mobile/models/loyalty_program.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/loyalty_program_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/paypal_screen.dart';

class CreateInsurancePolicyScreen extends StatefulWidget {
  final InsurancePolicy policy;

  const CreateInsurancePolicyScreen({super.key, required this.policy});

  @override
  State<CreateInsurancePolicyScreen> createState() =>
      _CreateInsurancePolicyScreenState();
}

class _CreateInsurancePolicyScreenState
    extends State<CreateInsurancePolicyScreen> {
  DateTime? _renewDate;
  String? _validationMessage;
  LoyaltyProgram? _loyaltyProgram;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLoyaltyProgram();
  }

  Future<void> _loadLoyaltyProgram() async {
    try {
      final loyaltyProvider = LoyaltyProgramProvider();
      final result = await loyaltyProvider.get(
        filter: {"ClientId": AuthProvider.clientId},
      );

      if (!mounted) return;
      setState(() {
        _loyaltyProgram =
            result.resultList.isNotEmpty ? result.resultList.first : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      showErrorAlert(context, "Error loading loyalty data: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final policy = widget.policy;
    final bool isPaid = policy.isPaid ?? false;
    final double originalPrice = policy.insurancePackage?.price ?? 0.0;
    final double discount = getDiscountForTier(_loyaltyProgram?.tier);
    final double finalPrice = originalPrice * (1 - discount);

    return MasterScreen(
      appBarTitle: isPaid ? "Renew Policy" : "Pay for Policy",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      "Package:",
                      policy.insurancePackage?.name ?? 'N/A',
                    ),
                    const Divider(height: 30, thickness: 1.2),
                    if (discount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child: Row(
                          children: [
                            Text(
                              "Loyalty Tier: ",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            Text(
                              "${getLoyaltyTierName(_loyaltyProgram?.tier)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: getLoyaltyTierColor(
                                  _loyaltyProgram?.tier,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    _buildPriceRow(originalPrice, finalPrice),

                    const Divider(height: 30, thickness: 1.2),

                    if (!isPaid) ...[
                      _buildInfoRow(
                        "Start Date:",
                        formatDateString(policy.startDate),
                      ),
                      const Divider(height: 30, thickness: 1.2),
                      _buildInfoRow(
                        "End Date:",
                        formatDateString(policy.endDate),
                      ),
                      const Divider(height: 30, thickness: 1.2),
                      _buildInfoRow(
                        "Duration:",
                        "${policy.insurancePackage?.durationDays ?? 0} days",
                      ),
                    ] else ...[
                      _buildInfoRow(
                        "Duration:",
                        "${policy.insurancePackage?.durationDays ?? 0} days",
                      ),
                      const Divider(height: 30, thickness: 1.2),
                      Text(
                        "Policy has expired on: ${formatDateString(policy.endDate)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _pickRenewDate,
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          _renewDate != null
                              ? "Renew from: ${formatDate(_renewDate!)}"
                              : "Select new start date",
                        ),
                      ),
                      if (_validationMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _validationMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                    const Spacer(),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(isPaid ? Icons.refresh : Icons.payment),
                        label: Text(
                          isPaid ? "Renew Policy" : "Pay Now",
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed:
                            isPaid
                                ? () => _proceedToRenewal(finalPrice)
                                : () => _proceedToPayment(finalPrice),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle),
          Text(value, style: _valueStyle),
        ],
      ),
    );
  }

  Widget _buildPriceRow(double originalPrice, double finalPrice) {
    return Padding(
      padding: const EdgeInsets.only(left: 1.0),
      child: Row(
        children: [
          if (originalPrice != finalPrice)
            Text(
              "\$${originalPrice.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.red,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            "\$${finalPrice.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickRenewDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _renewDate = picked;
        _validationMessage = null;
      });
    }
  }

  void _proceedToPayment(double price) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaypalScreen(
              policy: widget.policy,
              price: price.toStringAsFixed(2),
            ),
      ),
    );
  }

  void _proceedToRenewal(double price) async {
    if (_renewDate == null) {
      setState(
        () =>
            _validationMessage =
                "Please select a valid start date before continuing.",
      );
      return;
    }

    final newStart = _renewDate!;
    final newEnd = newStart.add(
      Duration(days: widget.policy.insurancePackage?.durationDays ?? 0),
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaypalScreen(
              policy: widget.policy,
              price: price.toStringAsFixed(2),
              overrideStartDate: newStart,
              overrideEndDate: newEnd,
            ),
      ),
    );
  }

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.brown,
  );

  static const TextStyle _valueStyle = TextStyle(
    fontSize: 18,
    color: Colors.black87,
  );
}
