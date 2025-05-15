import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/my_insurance_policies_screen.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:provider/provider.dart';

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
                            backgroundColor: Colors.orange.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(12),
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
                            backgroundColor: Colors.orange.shade800,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                              borderRadius: BorderRadius.circular(12),
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
      setState(() {
        _renewDate = picked;
        _validationMessage = null;
      });
    }
  }

  void _proceedToRenewal() async {
    if (_renewDate == null) {
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

    try {
      final provider = Provider.of<InsurancePolicyProvider>(
        context,
        listen: false,
      );
      final request = {
        "startDate": newStart.toIso8601String(),
        "endDate": newEnd.toIso8601String(),
        "isActive": true,
        "isPaid": true,
        "edit": true,
      };

      await provider.update(widget.policy.insurancePolicyId!, request);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => const MasterScreen(
                appBarTitle: "My Policies",
                showBackButton: false,
                child: MyInsurancePoliciesScreen(),
              ),
        ),
      );

      showSuccessAlert(context, "Policy renewed successfully.");
    } catch (e) {
      showErrorAlert(context, "Error renewing policy: ${e.toString()}");
    }
  }

  void _proceedToPayment() async {
    final price =
        widget.policy.insurancePackage!.price?.toStringAsFixed(2) ?? "0.00";

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PaypalCheckoutView(
              sandboxMode: true,
              clientId:
                  "AUioWKe4n7nFVCDOI-AC2lITkgg4AzSLhpk0FW0-97f146rI8LGznTUsVRuq3d-_usCms_CWK-zD8qFp",
              secretKey:
                  "EB4sDeZKe5ewKLO38ppQxHCv0jBl4u46mYLhG4xGFRCbmqhE70Ucg5YhloX8pcV1GYc9NoVsgh2VorWa",
              transactions: [
                {
                  "amount": {
                    "total": price,
                    "currency": "USD",
                    "details": {
                      "subtotal": price,
                      "shipping": "0",
                      "shipping_discount": 0,
                    },
                  },
                  "description": "Insurance policy payment",
                  "item_list": {
                    "items": [
                      {
                        "name":
                            widget.policy.insurancePackage!.name ?? "Policy",
                        "quantity": "1",
                        "price": price,
                        "currency": "USD",
                      },
                    ],
                  },
                },
              ],
              note: "Thank you for your payment",
              onSuccess: (params) async {
                final data = params['data'];
                final transaction = {
                  "amount": double.parse(
                    data['transactions'][0]['amount']['total'],
                  ),
                  "paymentMethod": data['payer']['payment_method'],
                  "paymentId": data['id'],
                  "payerId": data['payer']['payer_info']['payer_id'],
                  "clientId": AuthProvider.clientId,
                  "insurancePolicyId": widget.policy.insurancePolicyId,
                };

                try {
                  final provider = Provider.of<InsurancePolicyProvider>(
                    context,
                    listen: false,
                  );
                  final request = {
                    'startDate': widget.policy.startDate,
                    'endDate': widget.policy.endDate,
                    "isActive": true,
                    "transactionInsert": transaction,
                  };

                  await provider.update(
                    widget.policy.insurancePolicyId!,
                    request,
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder:
                          (_) => const MasterScreen(
                            appBarTitle: "My Policies",
                            showBackButton: false,
                            child: MyInsurancePoliciesScreen(),
                          ),
                    ),
                  );
                  showSuccessAlert(context, "Payment successful.");
                } catch (e) {
                  showErrorAlert(
                    context,
                    "Error saving transaction: ${e.toString()}",
                  );
                }
              },
              onError: (error) {
                Navigator.pop(context);
                showErrorAlert(context, "Payment failed: $error");
              },
              onCancel: () {
                Navigator.pop(context);
              },
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
