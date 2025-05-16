import 'package:flutter/material.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/claim_request_provider.dart';
import 'package:insuratech_mobile/models/claim_request.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class ClaimRequestScreen extends StatefulWidget {
  const ClaimRequestScreen({super.key});

  @override
  State<ClaimRequestScreen> createState() => _ClaimRequestScreenState();
}

class _ClaimRequestScreenState extends State<ClaimRequestScreen> {
  List<ClaimRequest> _claimRequests = [];
  bool _isLoading = true;
  Set<int> _expandedCards = {};

  @override
  void initState() {
    super.initState();
    _fetchClaimRequests();
  }

  Future<void> _fetchClaimRequests() async {
    try {
      final claimRequestProvider = Provider.of<ClaimRequestProvider>(
        context,
        listen: false,
      );
      final searchResult = await claimRequestProvider.get(
        filter: {"Username": AuthProvider.username},
      );
      if (!mounted) return;
      setState(() {
        _claimRequests = searchResult.resultList;
        _isLoading = false;
      });
    } catch (e) {
      showErrorAlert(context, "Error fetching claim requests: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE4E0C8),
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _claimRequests.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assignment, size: 64, color: Colors.brown),
                    const SizedBox(height: 20),
                    const Text(
                      "You don't have any claim requests yet",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _fetchClaimRequests,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _claimRequests.length,
                  itemBuilder: (context, index) {
                    final claim = _claimRequests[index];
                    final isExpanded = _expandedCards.contains(
                      claim.claimRequestId,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  claim
                                          .insurancePolicy!
                                          .insurancePackage!
                                          .name ??
                                      "-",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildStatusBadge(claim.status),
                            SizedBox(height: 16),
                            Text(
                              "Description: ${claim.description ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Estimated Amount: ${claim.estimatedAmount?.toStringAsFixed(2) ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (claim.status?.toLowerCase() == "accepted" ||
                                claim.status?.toLowerCase() == "declined") ...[
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      if (isExpanded) {
                                        _expandedCards.remove(
                                          claim.claimRequestId,
                                        );
                                      } else {
                                        _expandedCards.add(
                                          claim.claimRequestId!,
                                        );
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.blueGrey,
                                  ),
                                  label: Text(
                                    isExpanded
                                        ? "Hide Details"
                                        : "Show Details",
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (isExpanded &&
                                (claim.comment != null &&
                                    claim.comment!.isNotEmpty)) ...[
                              const SizedBox(height: 12),
                              const Divider(thickness: 1),
                              Text(
                                "Comment:",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                claim.comment!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color badgeColor;
    String label = status ?? "Unknown";

    switch (status?.toLowerCase()) {
      case "in progress":
        badgeColor = Colors.blueAccent;
        break;
      case "accepted":
        badgeColor = Colors.green;
        break;
      case "declined":
        badgeColor = Colors.redAccent;
        break;
      default:
        badgeColor = Colors.grey;
        label = "Unknown";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        border: Border.all(color: badgeColor, width: 1.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
