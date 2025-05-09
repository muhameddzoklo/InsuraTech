import 'package:flutter/material.dart';
import 'package:insuratech_desktop/providers/notification_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:intl/intl.dart';
import 'package:insuratech_desktop/models/insurance_policy.dart';
import 'package:insuratech_desktop/providers/insurance_policy_provider.dart';
import 'package:provider/provider.dart';
import '../layouts/master_screen.dart';

class NotifyClientsScreen extends StatefulWidget {
  const NotifyClientsScreen({super.key});

  @override
  State<NotifyClientsScreen> createState() => _NotifyClientsScreenState();
}

class _NotifyClientsScreenState extends State<NotifyClientsScreen> {
  late InsurancePolicyProvider _policyProvider;
  List<InsurancePolicy> _policies = [];
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _policyProvider = context.read<InsurancePolicyProvider>();
    _selectedDate = null;

    _loadData();
  }

  Future<void> _loadData() async {
    final filter = {
      "isActive": true,
      if (_selectedDate != null) "EndDateLTE": _selectedDate,
    };

    final result = await _policyProvider.get(
      filter: filter,
      includeTables: "Client,InsurancePackage",
      orderBy: "IsNotificationSent",
      sortDirection: "ASC",
    );
    setState(() {
      _policies = result.resultList;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Notify Clients",
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Notify clients expiring before:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    _selectedDate != null
                        ? DateFormat('dd.MM.yyyy').format(_selectedDate!)
                        : "Select date",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade300,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                if (_selectedDate != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                      });
                      _loadData();
                    },

                    label: const Text("Clear date"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 16,
                  runSpacing: 16,
                  children:
                      _policies.map((policy) {
                        final pkg = policy.insurancePackage!;
                        final client = policy.client!;
                        return Container(
                          width: 400,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFEFEF),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow("Package:", pkg.name ?? ''),
                              _infoRow(
                                "Client:",
                                "${client.firstName} ${client.lastName}",
                              ),
                              _infoRow("Paid:", "${pkg.price}\$"),
                              _infoRow(
                                "Start date:",
                                formatDateString(policy.startDate.toString()),
                              ),
                              _infoRow(
                                "End date:",
                                formatDateString(policy.endDate.toString()),
                              ),
                              const SizedBox(height: 16),
                              Center(
                                child: ElevatedButton(
                                  onPressed:
                                      policy.isNotificationSent!
                                          ? null
                                          : () async {
                                            try {
                                              final notificationProvider =
                                                  Provider.of<
                                                    NotificationProvider
                                                  >(context, listen: false);

                                              await notificationProvider.insert(
                                                {
                                                  "clientId": policy.clientId,
                                                  "insurancePolicyId":
                                                      policy.insurancePolicyId,
                                                },
                                              );
                                              showSuccessAlert(
                                                context,
                                                "Notification sent",
                                              );

                                              _loadData();
                                            } catch (e) {
                                              showErrorAlert(
                                                context,
                                                "Error Sending notification ${e.toString()}",
                                              );
                                            }
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        policy.isNotificationSent!
                                            ? Colors.blue
                                            : Colors.orange,
                                    foregroundColor: Colors.black,
                                    disabledBackgroundColor: Colors.blue,
                                    disabledForegroundColor: Colors.white,
                                  ),
                                  child: Text(
                                    policy.isNotificationSent!
                                        ? "Notification sent"
                                        : "Send notification",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
