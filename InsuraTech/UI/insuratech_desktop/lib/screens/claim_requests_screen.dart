import 'package:flutter/material.dart';
import 'package:insuratech_desktop/providers/auth_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/claim_request.dart';
import 'package:insuratech_desktop/providers/claim_request_provider.dart';
import 'package:provider/provider.dart';

class ClaimRequestsScreen extends StatefulWidget {
  const ClaimRequestsScreen({super.key});

  @override
  State<ClaimRequestsScreen> createState() => _ClaimRequestsScreenState();
}

class _ClaimRequestsScreenState extends State<ClaimRequestsScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;
  List<ClaimRequest> _requests = [];
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading) {
      _loadStatusOptions();
    }
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
      await _fetchRequests();
    }
  }

  Future<void> _loadStatusOptions() async {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _fetchRequests() async {
    setState(() => _isLoading = true);
    try {
      final filter = {
        if (_fromDate != null) "StartDate": _fromDate!.toIso8601String(),
        if (_toDate != null) "EndDate": _toDate!.toIso8601String(),
      };

      final result = await Provider.of<ClaimRequestProvider>(
        context,
        listen: false,
      ).get(filter: filter, orderBy: "Status", sortDirection: "DESC");

      setState(() {
        _requests = result.resultList;
      });
    } catch (e) {
      showErrorAlert(context, "Error fetching requests ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchRequests();
  }

  void _showProcessDialog(ClaimRequest request) {
    final commentController = TextEditingController();
    final amountController = TextEditingController(
      text: request.estimatedAmount?.toStringAsFixed(2) ?? "",
    );

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Process Request",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.brown.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          request.description ?? "No description provided.",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Estimated Amount",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value != null && value.trim().isNotEmpty) {
                            final parsed = double.tryParse(value);
                            if (parsed == null || parsed < 0) {
                              return "Enter a valid amount";
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: commentController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "Comment (required)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Comment is required.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              try {
                                final updatedRequest = {
                                  "isAccepted": true,
                                  "comment": commentController.text,
                                  "estimatedAmount":
                                      double.tryParse(amountController.text) ??
                                      0,
                                  "userId": AuthProvider.userId,
                                };

                                await Provider.of<ClaimRequestProvider>(
                                  context,
                                  listen: false,
                                ).update(
                                  request.claimRequestId!,
                                  updatedRequest,
                                );

                                Navigator.of(context).pop();
                                showSuccessAlert(
                                  context,
                                  "Request accepted successfully",
                                );
                                _fetchRequests();
                              } catch (e) {
                                showErrorAlert(
                                  context,
                                  "Error accepting request: ${e.toString()}",
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                            label: const Text("Accept"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              try {
                                final updatedRequest = {
                                  "isAccepted": false,
                                  "comment": commentController.text,
                                  "estimatedAmount": request.estimatedAmount,
                                  "userId": AuthProvider.userId,
                                };

                                await Provider.of<ClaimRequestProvider>(
                                  context,
                                  listen: false,
                                ).update(
                                  request.claimRequestId!,
                                  updatedRequest,
                                );

                                Navigator.of(context).pop();
                                showSuccessAlert(
                                  context,
                                  "Request declined successfully",
                                );
                                _fetchRequests();
                              } catch (e) {
                                showErrorAlert(
                                  context,
                                  "Error declining request: ${e.toString()}",
                                );
                              }
                            },
                            icon: const Icon(Icons.close),
                            label: const Text("Decline"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Claim Requests",
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.date_range),
                label: Text(
                  _fromDate != null
                      ? "From: ${formatDate(_fromDate!)}"
                      : "From Date",
                ),
                onPressed: () => _pickDate(isFrom: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.date_range),
                label: Text(
                  _toDate != null ? "To: ${formatDate(_toDate!)}" : "To Date",
                ),
                onPressed: () => _pickDate(isFrom: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                      itemCount: _requests.length,
                      itemBuilder: (context, index) {
                        final r = _requests[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r
                                                    .insurancePolicy
                                                    ?.insurancePackage
                                                    ?.name ??
                                                "N/A",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Period: ${formatDateString(r.insurancePolicy!.startDate!)} - ${formatDateString(r.insurancePolicy!.endDate!)}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "Client: ${r.insurancePolicy!.client?.firstName ?? ''} ${r.insurancePolicy!.client?.lastName ?? ''}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Submitted: ${formatDateString(r.submittedAt)}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Status: ${r.status ?? 'unknown'}",
                                            style: TextStyle(
                                              color:
                                                  r.status == "Accepted"
                                                      ? Colors.green
                                                      : r.status == "Declined"
                                                      ? Colors.red
                                                      : Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Amount: ${r.estimatedAmount?.toStringAsFixed(2) ?? "0.00"}",
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            r.status == "Accepted" ||
                                                    r.status == "Declined"
                                                ? "Comment:"
                                                : "Description:",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            r.status == "Accepted" ||
                                                    r.status == "Declined"
                                                ? r.comment ?? "N/A"
                                                : r.description ?? "N/A",
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Spacer(),
                                          Align(
                                            alignment: Alignment.center,
                                            child:
                                                r.status == "In progress"
                                                    ? ElevatedButton(
                                                      onPressed:
                                                          () =>
                                                              _showProcessDialog(
                                                                r,
                                                              ),
                                                      child: const Text(
                                                        "Process request",
                                                      ),
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.orange,
                                                            foregroundColor:
                                                                Colors.black,
                                                          ),
                                                    )
                                                    : ElevatedButton(
                                                      onPressed: null,
                                                      child: const Text(
                                                        "Processed",
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.blue,
                                                        foregroundColor:
                                                            Colors.white,
                                                        disabledBackgroundColor:
                                                            Colors.blue,
                                                        disabledForegroundColor:
                                                            Colors.white,
                                                      ),
                                                    ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
