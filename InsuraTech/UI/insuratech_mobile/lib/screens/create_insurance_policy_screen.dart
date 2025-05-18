import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
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

  @override
  Widget build(BuildContext context) {
    final policy = widget.policy;
    final bool isPaid = policy.isPaid ?? false;

    return MasterScreen(
      appBarTitle: isPaid ? "Renew Policy" : "Pay for Policy",
      child: Padding(
        padding: const EdgeInsets.all(24),
        child:
            !isPaid
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Package:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        policy.insurancePackage!.name ?? 'N/A',
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    const Text("Price:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        "\$${policy.insurancePackage!.price?.toStringAsFixed(2) ?? 'N/A'}",
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    const Text("Start Date:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        formatDateString(policy.startDate),
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    const Text("End Date:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        formatDateString(policy.endDate),
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    const Text("Duration:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        "${policy.insurancePackage!.durationDays.toString()} days",
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    if (isPaid) ...[
                      const Text(
                        "Policy has expired.",
                        style: TextStyle(
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
                      const Spacer(),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            "Renew Policy",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _proceedToRenewal,
                        ),
                      ),
                    ] else ...[
                      const Spacer(),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text(
                            "Pay Now",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _proceedToPayment,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Package:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        policy.insurancePackage!.name ?? 'N/A',
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    const Text("Price:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        "\$${policy.insurancePackage!.price?.toStringAsFixed(2) ?? 'N/A'}",
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    const Text("Duration:", style: _labelStyle),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        "${policy.insurancePackage!.durationDays.toString()} days",
                        style: _valueStyle,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1.2),

                    if (isPaid) ...[
                      Text(
                        "Policy has expired on: ${formatDateString(policy.endDate)}",
                        style: TextStyle(
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
                      const Spacer(),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            "Renew Policy",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _proceedToRenewal,
                        ),
                      ),
                    ] else ...[
                      const Spacer(),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text(
                            "Pay Now",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _proceedToPayment,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
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
      if (!mounted) return;
      setState(() {
        _renewDate = picked;
        _validationMessage = null;
      });
    }
  }

  void _proceedToRenewal() async {
    if (_renewDate == null) {
      if (!mounted) return;
      setState(() {
        _validationMessage =
            "Please select a valid start date before continuing.";
      });
      return;
    }

    final newStart = _renewDate!;
    final newEnd = newStart.add(
      Duration(days: widget.policy.insurancePackage!.durationDays!),
    );

    final price =
        widget.policy.insurancePackage!.price?.toStringAsFixed(2) ?? "0.00";

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaypalScreen(
              policy: widget.policy,
              price: price,
              overrideStartDate: newStart,
              overrideEndDate: newEnd,
            ),
      ),
    );
  }

  void _proceedToPayment() async {
    final price =
        widget.policy.insurancePackage!.price?.toStringAsFixed(2) ?? "0.00";
    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaypalScreen(policy: widget.policy, price: price),
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
