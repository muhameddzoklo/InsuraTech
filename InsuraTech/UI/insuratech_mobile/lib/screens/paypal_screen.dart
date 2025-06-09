import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/my_insurance_policies_screen.dart';
import 'package:provider/provider.dart';

class PaypalScreen extends StatelessWidget {
  final InsurancePolicy policy;
  final String price;
  final DateTime? overrideStartDate;
  final DateTime? overrideEndDate;

  const PaypalScreen({
    super.key,
    required this.policy,
    required this.price,
    this.overrideStartDate,
    this.overrideEndDate,
  });
  DateTime parseDate(dynamic value) {
    return value is DateTime ? value : DateTime.parse(value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final DateTime startDate = overrideStartDate ?? parseDate(policy.startDate);
    final DateTime endDate = overrideEndDate ?? parseDate(policy.endDate);
    return PaypalCheckoutView(
      sandboxMode: true,
      clientId:
          dotenv.env['PAYPAL_CLIENT_ID'] ??
          "AUioWKe4n7nFVCDOI-AC2lITkgg4AzSLhpk0FW0-97f146rI8LGznTUsVRuq3d-_usCms_CWK-zD8qFp",
      secretKey:
          dotenv.env['PAYPAL_SECRET'] ??
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
                "name": policy.insurancePackage!.name ?? "Policy",
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
          "amount": double.parse(data['transactions'][0]['amount']['total']),
          "paymentMethod": data['payer']['payment_method'],
          "paymentId": data['id'],
          "payerId": data['payer']['payer_info']['payer_id'],
          "clientId": AuthProvider.clientId,
          "insurancePolicyId": policy.insurancePolicyId,
        };

        final provider = Provider.of<InsurancePolicyProvider>(
          context,
          listen: false,
        );

        final request = {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          "isActive": true,
          "transactionInsert": transaction,
        };

        await provider.update(policy.insurancePolicyId!, request);

        if (context.mounted) {
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
        }
      },
      onError: (error) {
        if (context.mounted) {
          Navigator.pop(context);
          showErrorAlert(context, "Payment failed: $error");
        }
      },
      onCancel: () {
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}
