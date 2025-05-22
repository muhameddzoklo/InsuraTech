import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as flutter_ui;

import 'package:flutter/material.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/client_feedback_provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_package.dart';
import 'package:insuratech_mobile/screens/comments_screen.dart';
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

  double? _averageRating;
  int _commentCount = 0;

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

  @override
  void initState() {
    super.initState();
    _loadFeedbackStats();
  }

  Future<void> _loadFeedbackStats() async {
    final feedbackProvider = Provider.of<ClientFeedbackProvider>(
      context,
      listen: false,
    );
    final result = await feedbackProvider.get(
      filter: {"InsurancePackageId": widget.package.insurancePackageId},
    );

    final feedbacks = result.resultList;
    if (feedbacks.isNotEmpty) {
      final ratings = feedbacks
          .where((f) => f.rating != null)
          .map((f) => f.rating!);
      final comments = feedbacks.where(
        (f) => f.comment != null && f.comment!.trim().isNotEmpty,
      );

      setState(() {
        _averageRating =
            ratings.isNotEmpty
                ? ratings.reduce((a, b) => a + b) / ratings.length
                : null;
        _commentCount = comments.length;
      });
    }
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
            (_averageRating != null || _commentCount > 0)
                ? Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Row(
                    children: [
                      if (_averageRating != null)
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < _averageRating!.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 22,
                            );
                          }),
                        ),
                      const SizedBox(width: 16),
                      if (_commentCount > 0)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => MasterScreen(
                                      appBarTitle: "Comments",
                                      showBackButton: true,
                                      child: CommentsScreen(
                                        packageId:
                                            widget.package.insurancePackageId!,
                                      ),
                                    ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.comment,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "$_commentCount comment${_commentCount > 1 ? 's' : ''}",
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
                : Center(
                  child: Text(
                    "No reviews yet!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
            SizedBox(height: 20),
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
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    "Price:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "\$${widget.package.price?.toStringAsFixed(2) ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.package.durationDays != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        "Duration:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${widget.package.durationDays} days",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const flutter_ui.Color.fromARGB(
                  255,
                  244,
                  226,
                  207,
                ),
                foregroundColor: Colors.black,
                minimumSize: flutter_ui.Size.fromRadius(20),
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
