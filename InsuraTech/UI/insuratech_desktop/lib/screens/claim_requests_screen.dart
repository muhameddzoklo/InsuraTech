import 'package:flutter/material.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:intl/intl.dart';
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
      await _fetchRequests(); // Refetch after setting the date
    }
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
      ).get(filter: filter, retrieveAll: true);

      setState(() {
        _requests = result.resultList;
      });
    } catch (e) {
      debugPrint("Error fetching requests: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRequests();
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
                      ? "From: ${DateFormat.yMMMd().format(_fromDate!)}"
                      : "From Date",
                ),
                onPressed: () => _pickDate(isFrom: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.date_range),
                label: Text(
                  _toDate != null
                      ? "To: ${DateFormat.yMMMd().format(_toDate!)}"
                      : "To Date",
                ),
                onPressed: () => _pickDate(isFrom: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : Expanded(
                child: ListView.builder(
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    final r = _requests[index];
                    final isProcessed =
                        r.status == "accepted" || r.status == "declined";
                    final statusColor =
                        r.status == "accepted"
                            ? Colors.green
                            : r.status == "declined"
                            ? Colors.red
                            : Colors.black;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Submitted: ${formatDateString(r.submittedAt)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  "Status: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  r.status ?? "unknown",
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Amount: \$${r.estimatedAmount?.toStringAsFixed(2) ?? "0.00"}",
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isProcessed ? "Comment:" : "Description:",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              isProcessed
                                  ? r.comment ?? "N/A"
                                  : r.description ?? "N/A",
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child:
                                  r.status == "in progress"
                                      ? ElevatedButton(
                                        onPressed: () {
                                          // Edit logic
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.orange.shade700,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        child: const Text("Process request"),
                                      )
                                      : const Text(
                                        "Processed",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ],
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
