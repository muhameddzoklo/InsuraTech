import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_package.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/my_insurance_policies_screen.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:provider/provider.dart';

class CreateInsurancePolicyScreen extends StatelessWidget {
  final InsurancePackage package;
  final DateTime startDate;
  final DateTime endDate;
  final int clientId = AuthProvider.clientId!;

  CreateInsurancePolicyScreen({
    super.key,
    required this.package,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      appBarTitle: "Create Insurance Policy",
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Package:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(package.name ?? 'N/A', style: _valueStyle),
            ),
            const Divider(height: 30, thickness: 1.2),

            const Text("Price:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "\$${package.price?.toStringAsFixed(2) ?? 'N/A'}",
                style: _valueStyle,
              ),
            ),
            const Divider(height: 30, thickness: 1.2),

            const Text("Start Date:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(formatDate(startDate), style: _valueStyle),
            ),
            const Divider(height: 30, thickness: 1.2),

            const Text("End Date:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(formatDate(endDate), style: _valueStyle),
            ),
            const Divider(height: 30, thickness: 1.2),

            const Text("Duration:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "${package.durationDays.toString()} days",
                style: _valueStyle,
              ),
            ),
            const Divider(height: 30, thickness: 1.2),

            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text("Pay Now", style: TextStyle(fontSize: 16)),
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
                onPressed: () async {
                  var client_Id =
                      "AUioWKe4n7nFVCDOI-AC2lITkgg4AzSLhpk0FW0-97f146rI8LGznTUsVRuq3d-_usCms_CWK-zD8qFp";
                  var secret =
                      "EB4sDeZKe5ewKLO38ppQxHCv0jBl4u46mYLhG4xGFRCbmqhE70Ucg5YhloX8pcV1GYc9NoVsgh2VorWa";

                  if (client_Id == null || secret == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("PayPal credentials missing"),
                      ),
                    );
                    return;
                  }

                  final insurancePolicy = package;
                  final price = package.price?.toStringAsFixed(2) ?? "0.00";
                  print(
                    "clientid $client_Id, secret $secret, price ${package.price}, name ${package.name}",
                  );
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PaypalCheckoutView(
                            sandboxMode: true,
                            clientId: client_Id,
                            secretKey: secret,
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
                                      "name": insurancePolicy.name ?? "Policy",
                                      "quantity": "1",
                                      "price": price,
                                      "currency": "USD",
                                    },
                                  ],
                                },
                              },
                            ],

                            note: "Thank you for your payment",
                            onSuccess: (Map params) async {
                              try {
                                final insurancePolicyProvider =
                                    Provider.of<InsurancePolicyProvider>(
                                      context,
                                      listen: false,
                                    );

                                final request = {
                                  'insurancePackageId':
                                      package.insurancePackageId!,
                                  'clientId': clientId,
                                  'startDate': startDate.toIso8601String(),
                                  'endDate': endDate.toIso8601String(),
                                };

                                await insurancePolicyProvider.insert(request);

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => MasterScreen(
                                          appBarTitle: "My Policies",
                                          showBackButton: false,
                                          child: MyInsurancePoliciesScreen(),
                                        ),
                                  ),
                                );
                                showSuccessAlert(
                                  context,
                                  "Policy created successfully",
                                );
                              } catch (e) {
                                showErrorAlert(
                                  context,
                                  "Policy not created: ${e.toString()}",
                                );
                              }
                              Navigator.pop(context, true);
                              showSuccessAlert(context, "Payment successful");
                            },
                            onError: (error) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Payment error: $error"),
                                ),
                              );
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
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
