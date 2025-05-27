import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/client_feedback.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/claim_request_provider.dart';
import 'package:insuratech_mobile/providers/client_feedback_provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/claim_requests_screen.dart';
import 'package:insuratech_mobile/screens/create_insurance_policy_screen.dart';
import 'package:provider/provider.dart';

class MyInsurancePoliciesScreen extends StatefulWidget {
  const MyInsurancePoliciesScreen({super.key});

  @override
  State<MyInsurancePoliciesScreen> createState() =>
      _MyInsurancePoliciesScreenState();
}

class _MyInsurancePoliciesScreenState extends State<MyInsurancePoliciesScreen> {
  List<InsurancePolicy> _policies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPolicies();
  }

  Future<void> _fetchPolicies() async {
    try {
      final policyProvider = Provider.of<InsurancePolicyProvider>(
        context,
        listen: false,
      );
      final feedbackProvider = Provider.of<ClientFeedbackProvider>(
        context,
        listen: false,
      );

      final result = await policyProvider.get(
        orderBy: "IsActive",
        sortDirection: "desc",
        filter: {"ClientUsername": AuthProvider.username},
      );

      final policies = result.resultList;

      for (var policy in policies) {
        final feedbackResult = await feedbackProvider.get(
          filter: {
            "InsurancePolicyId": policy.insurancePolicyId,
            "isDeleted": true,
          },
        );
        if (feedbackResult.resultList.isNotEmpty) {
          policy.clientFeedback = feedbackResult.resultList.first;
        }
      }

      if (!mounted) return;
      setState(() {
        _policies = policies;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showErrorAlert(context, "Failed to load policies: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E0C8),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _policies.isEmpty
              ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.brown,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "No policies created",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _policies.length,
                itemBuilder: (context, index) {
                  final policy = _policies[index];
                  final isActive = policy.isActive ?? false;
                  final isPaid = policy.isPaid ?? false;
                  final startDate =
                      policy.startDate != null
                          ? DateTime.tryParse(policy.startDate!)
                          : null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  policy.insurancePackage?.name ?? "N/A",
                                  style: _titleStyle,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'claim':
                                      _showClaimRequestDialog(
                                        policy.insurancePolicyId!,
                                      );
                                      break;
                                    case 'delete':
                                      final confirm = await showCustomConfirmDialog(
                                        context,
                                        title: 'Confirm Deletion',
                                        text:
                                            'Are you sure you want to delete this policy?',
                                      );
                                      if (confirm == true) {
                                        try {
                                          await Provider.of<
                                            InsurancePolicyProvider
                                          >(
                                            context,
                                            listen: false,
                                          ).delete(policy.insurancePolicyId!);
                                          showSuccessAlert(
                                            context,
                                            "Policy deleted successfully",
                                          );
                                          _fetchPolicies();
                                        } catch (e) {
                                          showErrorAlert(
                                            context,
                                            "Failed to delete policy: ${e.toString()}",
                                          );
                                        }
                                      }
                                      break;
                                    case 'pay':
                                    case 'renew':
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  CreateInsurancePolicyScreen(
                                                    policy: policy,
                                                  ),
                                        ),
                                      );
                                      break;
                                  }
                                },
                                itemBuilder: (context) {
                                  List<PopupMenuEntry<String>> items = [];

                                  if (isActive) {
                                    if (startDate != null &&
                                        startDate.isBefore(DateTime.now())) {
                                      if (policy.hasActiveClaimRequest ==
                                          true) {
                                        items.add(
                                          const PopupMenuItem<String>(
                                            value: 'claim',
                                            enabled: false,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.report_gmailerrorred,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Claim in Progress",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        items.add(
                                          const PopupMenuItem<String>(
                                            value: 'claim',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.assignment_outlined,
                                                  color: Colors.black87,
                                                ),
                                                SizedBox(width: 8),
                                                Text("Submit Claim Request"),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    } else if (startDate != null &&
                                        startDate.isAfter(DateTime.now())) {
                                      items.add(
                                        PopupMenuItem<String>(
                                          value: 'future',
                                          enabled: false,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.schedule,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Policy starts on: ${formatDateString(policy.startDate)}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    items.add(
                                      const PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_forever_outlined,
                                              color: Colors.redAccent,
                                            ),
                                            SizedBox(width: 8),
                                            Text("Delete Policy"),
                                          ],
                                        ),
                                      ),
                                    );
                                    items.add(
                                      PopupMenuItem<String>(
                                        value: isPaid ? 'renew' : 'pay',
                                        child: Row(
                                          children: [
                                            Icon(
                                              isPaid
                                                  ? Icons.refresh
                                                  : Icons.payment,
                                              color: Colors.teal,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              isPaid
                                                  ? "Renew Policy"
                                                  : "Pay Now",
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  return items;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isActive
                                      ? Colors.green.shade300
                                      : Colors.red.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isActive ? 'Active' : 'Inactive',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text('Start Date:', style: _infoStyle),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  formatDateString(policy.startDate),
                                  style: _infoStyle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Expanded(
                                flex: 2,
                                child: Text('End Date:', style: _infoStyle),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  formatDateString(policy.endDate),
                                  style: _infoStyle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildFeedbackSection(policy),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  void showAddReviewDialog(InsurancePolicy policy) {
    final _formKey = GlobalKey<FormState>();
    final _commentController = TextEditingController();
    int _rating = 3;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave Feedback'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => setState(() => _rating = index + 1),
                        );
                      }),
                    ),
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Comment (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<ClientFeedbackProvider>(
                    context,
                    listen: false,
                  ).insert({
                    "insurancePolicyId": policy.insurancePolicyId,
                    "insurancePackageId":
                        policy.insurancePackage?.insurancePackageId,
                    "clientId": AuthProvider.clientId,
                    "rating": _rating,
                    "comment": _commentController.text.trim(),
                  });

                  Navigator.pop(context);
                  _fetchPolicies();
                  showSuccessAlert(context, "Feedback submitted.");
                } catch (e) {
                  showErrorAlert(
                    context,
                    "Error submiting feedback ${e.toString()}",
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void showEditReviewDialog(InsurancePolicy policy, ClientFeedback feedback) {
    final _formKey = GlobalKey<FormState>();
    final _commentController = TextEditingController(text: feedback.comment);
    int _rating = feedback.rating?.round() ?? 3;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Feedback'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => setState(() => _rating = index + 1),
                        );
                      }),
                    ),
                    TextFormField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        labelText: 'Comment (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await Provider.of<ClientFeedbackProvider>(
                    context,
                    listen: false,
                  ).update(feedback.clientFeedbackId!, {
                    "rating": _rating,
                    "comment": _commentController.text.trim(),
                  });

                  Navigator.pop(context);
                  _fetchPolicies();
                  showSuccessAlert(context, "Feedback updated.");
                } catch (e) {
                  showErrorAlert(
                    context,
                    "Error updating feedback ${e.toString()}",
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeedbackSection(InsurancePolicy policy) {
    final feedback = policy.clientFeedback;
    final isPaid = policy.isPaid ?? false;
    final isActive = policy.isActive ?? false;

    if (!isPaid && !isActive) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          "You can review after purchasing the policy",
          style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
        ),
      );
    }

    if (feedback == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(20), // zaobljeni rubovi
        ),
        child: InkWell(
          onTap: () => showAddReviewDialog(policy),

          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add review", style: TextStyle(color: Colors.black)),
              const SizedBox(width: 8),
              Tooltip(
                message: "Add review",
                child: Icon(Icons.rate_review_outlined, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    }

    if (feedback.isDeleted == true) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text("Reviewed", style: TextStyle(color: Colors.black)),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(20), // zaobljeni rubovi
      ),
      child: InkWell(
        onTap: () => showEditReviewDialog(policy, feedback),
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Reviewed", style: TextStyle(color: Colors.black)),
            const SizedBox(width: 8),
            Tooltip(
              message: "Edit review",
              child: Icon(Icons.edit_outlined, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  void _showClaimRequestDialog(int insurancePolicyId) {
    final _formKey = GlobalKey<FormState>();
    final _descriptionController = TextEditingController();
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Claim Request'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator:
                        (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Description is required'
                                : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Estimated Amount',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Estimated amount is required';
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null || parsed <= 0)
                        return 'Enter a valid positive number';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final claimRequest = {
                      "insurancePolicyId": insurancePolicyId,
                      "description": _descriptionController.text.trim(),
                      "estimatedAmount": double.parse(
                        _amountController.text.trim(),
                      ),
                    };
                    await Provider.of<ClaimRequestProvider>(
                      context,
                      listen: false,
                    ).insert(claimRequest);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder:
                            (_) => const MasterScreen(
                              appBarTitle: "Claim requests",
                              showBackButton: false,
                              child: ClaimRequestScreen(),
                            ),
                      ),
                    );
                    showSuccessAlert(context, "Request created successfully");
                  } catch (e) {
                    showErrorAlert(
                      context,
                      "Fail to claim request: ${e.toString()}",
                    );
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.brown,
  );
  static const TextStyle _infoStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
}
