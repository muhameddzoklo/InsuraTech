import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/claim_request_provider.dart';
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
      var insurancePolicyProvider = Provider.of<InsurancePolicyProvider>(
        context,
        listen: false,
      );
      var searchResult = await insurancePolicyProvider.get(
        orderBy: "IsActive",
        sortDirection: "desc",
        filter: {"ClientUsername": AuthProvider.username},
      );
      if (!mounted) return;
      setState(() {
        _policies = searchResult.resultList;
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
              ? const Center(child: Text('No policies found'))
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
                          Text(
                            policy.insurancePackage?.name ?? "N/A",
                            style: _titleStyle,
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isActive ? 'Active' : 'Inactive',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start Date: ${formatDateString(policy.startDate)}',
                            style: _infoStyle,
                          ),
                          Text(
                            'End Date: ${formatDateString(policy.endDate)}',
                            style: _infoStyle,
                          ),
                          const SizedBox(height: 12),
                          if (isActive &&
                              startDate != null &&
                              startDate.isBefore(DateTime.now()))
                            Center(
                              child:
                                  policy.hasActiveClaimRequest == true
                                      ? _buildTag(
                                        'Claim in Progress',
                                        Colors.lightBlueAccent,
                                      )
                                      : _buildClaimButton(
                                        policy.insurancePolicyId!,
                                      ),
                            )
                          else if (isActive &&
                              startDate != null &&
                              startDate.isAfter(DateTime.now()))
                            Center(
                              child: _buildTag(
                                'Policy starts from ${formatDateString(policy.startDate)}',
                                Colors.blueGrey,
                              ),
                            )
                          else
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildDeleteButton(policy.insurancePolicyId!),
                                  const SizedBox(width: 12),
                                  if (!isPaid)
                                    _buildPayNowButton(policy)
                                  else
                                    _buildRenewButton(policy),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildClaimButton(int policyId) {
    return ElevatedButton.icon(
      onPressed: () => _showClaimRequestDialog(policyId),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.add_circle, size: 22),
      label: const Text('Claim Request', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildDeleteButton(int policyId) {
    return ElevatedButton.icon(
      onPressed: () async {
        final confirm = await showCustomConfirmDialog(
          context,
          title: 'Confirm Deletion',
          text: 'Are you sure you want to delete this policy?',
        );
        if (confirm == true) {
          try {
            await Provider.of<InsurancePolicyProvider>(
              context,
              listen: false,
            ).delete(policyId);
            showSuccessAlert(context, "Policy deleted successfully");
            _fetchPolicies();
          } catch (e) {
            showErrorAlert(context, "Failed to delete policy: ${e.toString()}");
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.delete_outline, size: 20),
      label: const Text('Delete'),
    );
  }

  Widget _buildRenewButton(InsurancePolicy policy) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CreateInsurancePolicyScreen(policy: policy),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.refresh, size: 20),
      label: const Text('Renew'),
    );
  }

  Widget _buildPayNowButton(InsurancePolicy policy) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CreateInsurancePolicyScreen(policy: policy),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.payment, size: 20),
      label: const Text('Pay Now'),
    );
  }

  void _showClaimRequestDialog(int insurancePolicyId) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _descriptionController =
        TextEditingController();
    final TextEditingController _amountController = TextEditingController();

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
                            value == null || value.trim().isEmpty
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
