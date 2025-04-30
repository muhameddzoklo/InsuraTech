import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/screens/my_insurance_policies_screen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../providers/utils.dart';

class RenewInsurancePolicyScreen extends StatefulWidget {
  final InsurancePolicy policy;

  const RenewInsurancePolicyScreen({super.key, required this.policy});

  @override
  State<RenewInsurancePolicyScreen> createState() =>
      _RenewInsurancePolicyScreenState();
}

class _RenewInsurancePolicyScreenState
    extends State<RenewInsurancePolicyScreen> {
  DateTime? _selectedStartDate;
  late DateTime _calculatedEndDate;
  bool _isRenewing = false;

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      appBarTitle: "Renew Insurance Policy",
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Package:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                widget.policy.insurancePackage?.name ?? 'N/A',
                style: _valueStyle,
              ),
            ),
            const Divider(height: 30, thickness: 1.2),
            const Text("Price:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(
                "\$${widget.policy.insurancePackage?.price?.toStringAsFixed(2) ?? 'N/A'}",
                style: _valueStyle,
              ),
            ),
            const Divider(height: 30, thickness: 1.2),
            const Text("Select New Start Date:", style: _labelStyle),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: ElevatedButton(
                onPressed: _pickStartDate,
                child: const Text("Choose Start Date"),
              ),
            ),
            if (_selectedStartDate != null) ...[
              const Divider(height: 30, thickness: 1.2),
              Text(
                "Start Date: ${formatDate(_selectedStartDate!)}",
                style: _infoStyle,
              ),
              Text(
                "End Date: ${formatDate(_calculatedEndDate)}",
                style: _infoStyle,
              ),
            ],
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon:
                    _isRenewing
                        ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Icon(Icons.refresh),
                label:
                    _isRenewing
                        ? const Text(
                          "Renewing...",
                          style: TextStyle(fontSize: 16),
                        )
                        : const Text(
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    _selectedStartDate == null || _isRenewing
                        ? null
                        : _renewPolicy,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedStartDate = pickedDate;
        _calculatedEndDate = pickedDate.add(
          Duration(days: widget.policy.insurancePackage!.durationDays!),
        );
      });
    }
  }

  Future<void> _renewPolicy() async {
    try {
      final insurancePolicyProvider = Provider.of<InsurancePolicyProvider>(
        context,
        listen: false,
      );

      final request = {
        "startDate": _selectedStartDate!.toIso8601String(),
        "endDate": _calculatedEndDate.toIso8601String(),
        "isActive": true,
      };

      await insurancePolicyProvider.update(
        widget.policy.insurancePolicyId!,
        request,
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => const MasterScreen(
                appBarTitle: "My Policies",
                showBackButton: false,
                child: MyInsurancePoliciesScreen(),
              ),
        ),

        (route) => false,
      );
      showSuccessAlert(context, "Policy renewed successfully");
    } catch (e) {
      showErrorAlert(context, e.toString());
    }
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

  static const TextStyle _infoStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
}
