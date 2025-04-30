import 'package:flutter/material.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/claim_request_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/claim_requests_screen.dart';
import 'package:insuratech_mobile/screens/renew_insurance_policy_screen.dart';
import 'package:provider/provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
        filter: {"ClientUsernameGTE": AuthProvider.username},
      );

      setState(() {
        _policies = searchResult.resultList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Failed to load policies',
      );
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
                  final bool isActive = policy.isActive ?? false;
                  final startDate =
                      policy.startDate != null
                          ? DateTime.tryParse(policy.startDate!)
                          : null;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                policy.insurancePackage?.name ?? "N/A",
                                style: _titleStyle,
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
                              if (policy.isActive == true &&
                                  startDate != null &&
                                  startDate.isBefore(DateTime.now()))
                                Center(
                                  child:
                                      policy.hasActiveClaimRequest == true
                                          ? Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                77,
                                                186,
                                                237,
                                              ).withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                  255,
                                                  77,
                                                  186,
                                                  237,
                                                ),
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: const [
                                                SizedBox(width: 8),
                                                Text(
                                                  'Claim in Progress',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          : ElevatedButton.icon(
                                            onPressed: () {
                                              _showClaimRequestDialog(
                                                policy.insurancePolicyId!,
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              foregroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 22,
                                                    vertical: 9,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            icon: const Icon(
                                              Icons.add_circle,
                                              size: 22,
                                            ),
                                            label: const Text(
                                              'Claim Request',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                )
                              else if (isActive &&
                                  startDate != null &&
                                  startDate.isAfter(DateTime.now()))
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey.withOpacity(
                                            0.8,
                                          ), // Orange background with opacity
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color:
                                                Colors
                                                    .blueGrey, // Orange border
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Text(
                                          'Policy starts from ${formatDateString(policy.startDate)}',
                                          style: const TextStyle(
                                            color: Colors.white, // White text
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          final confirm =
                                              await showCustomConfirmDialog(
                                                context,
                                                title: 'Confirm Deletion',
                                                text:
                                                    'Are you sure you want to delete this policy?',
                                              );

                                          if (confirm == true) {
                                            try {
                                              final insurancePolicyProvider =
                                                  Provider.of<
                                                    InsurancePolicyProvider
                                                  >(context, listen: false);
                                              await insurancePolicyProvider
                                                  .delete(
                                                    policy.insurancePolicyId!,
                                                  );
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.success,
                                                title: 'Success',
                                                text:
                                                    'Policy deleted successfully',
                                              );
                                              _fetchPolicies();
                                            } catch (e) {
                                              QuickAlert.show(
                                                context: context,
                                                type: QuickAlertType.error,
                                                title: 'Error',
                                                text: 'Failed to delete policy',
                                              );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 20,
                                        ),
                                        label: const Text('Delete'),
                                      ),
                                      const SizedBox(width: 12),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      RenewInsurancePolicyScreen(
                                                        policy: policy,
                                                      ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 10,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        icon: const Icon(
                                          Icons.refresh,
                                          size: 20,
                                        ),
                                        label: const Text('Renew'),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      return null;
                    },
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
                      if (value == null || value.trim().isEmpty) {
                        return 'Estimated amount is required';
                      }
                      final parsed = double.tryParse(value.trim());
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid positive number';
                      }
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

                    final claimRequestProvider =
                        Provider.of<ClaimRequestProvider>(
                          context,
                          listen: false,
                        );
                    await claimRequestProvider.insert(claimRequest);

                    Navigator.of(context).pop();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder:
                            (context) => MasterScreen(
                              appBarTitle: "Claim requests",
                              showBackButton: false,
                              child: ClaimRequestScreen(),
                            ),
                      ),
                    );
                  } catch (e) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Error',
                      text: e.toString(),
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
