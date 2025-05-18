import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as flutter_ui;

import 'package:flutter/material.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_package.dart';
import 'package:insuratech_mobile/screens/my_insurance_policies_screen.dart';
import 'package:provider/provider.dart';

class InsurancePackageDetailsScreen extends StatefulWidget {
  final InsurancePackage package;

  const InsurancePackageDetailsScreen({super.key, required this.package});

  @override
  State<InsurancePackageDetailsScreen> createState() =>
      _InsurancePackageDetailsScreenState();
}

class _InsurancePackageDetailsScreenState
    extends State<InsurancePackageDetailsScreen> {
  DateTime? _startDate;
  String? _validationMessage;

  Uint8List? get imageBytes {
    if (widget.package.picture != null && widget.package.picture!.isNotEmpty) {
      return base64Decode(widget.package.picture!);
    }
    return null;
  }

  DateTime? get _endDate {
    if (_startDate != null && widget.package.durationDays != null) {
      return _startDate!.add(Duration(days: widget.package.durationDays!));
    }
    return null;
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() {
        _startDate = picked;
        _validationMessage = null;
      });
    }
  }

  void _proceedToPayment() async {
    if (_startDate == null) {
      setState(() {
        _validationMessage =
            "Please select a valid start date before continuing.";
      });
      return;
    }
    try {
      final insurancePolicyProvider = Provider.of<InsurancePolicyProvider>(
        context,
        listen: false,
      );

      final request = {
        'insurancePackageId': widget.package.insurancePackageId,
        'clientId': AuthProvider.clientId,
        'startDate': _startDate!.toIso8601String(),
        'endDate': _endDate!.toIso8601String(),
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
      showSuccessAlert(context, "Policy created successfully");
    } catch (e) {
      showErrorAlert(context, "Policy not created: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      appBarTitle: "Package Details",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  imageBytes != null
                      ? Image.memory(
                        imageBytes!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 220,
                      )
                      : Image.asset(
                        "assets/images/placeholder.png",
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 220,
                      ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.package.name ?? 'Unnamed Package',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.package.description ?? 'No description provided.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              "Price: \$${widget.package.price?.toStringAsFixed(2) ?? 'N/A'} ",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
            if (widget.package.durationDays != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "Duration: ${widget.package.durationDays} days",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown,
                  ),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                foregroundColor: Colors.white,
                minimumSize: flutter_ui.Size.fromHeight(50),
              ),
              onPressed: _pickStartDate,
              icon: const Icon(Icons.date_range),
              label: const Text("Choose Start Date"),
            ),
            if (_startDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 12),
                child: Text(
                  "Policy valid: ${formatDate(_startDate!)} -> ${formatDate(_endDate!)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (_validationMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      size: 18,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        _validationMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 100),
            Center(
              child: ElevatedButton(
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
                child: const Text(
                  "Create policy",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
