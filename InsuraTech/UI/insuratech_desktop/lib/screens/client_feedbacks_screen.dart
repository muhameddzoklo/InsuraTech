import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/client_feedback.dart';
import 'package:insuratech_desktop/providers/client_feedback_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ClientFeedbackScreen extends StatefulWidget {
  const ClientFeedbackScreen({super.key});

  @override
  State<ClientFeedbackScreen> createState() => _ClientFeedbackScreenState();
}

class _ClientFeedbackScreenState extends State<ClientFeedbackScreen> {
  List<ClientFeedback> _feedbackList = [];
  bool _isLoading = true;
  String? _searchTerm;
  String? _packageName;
  DateTime? _createdAfter;
  DateTime? _createdBefore;

  @override
  void initState() {
    super.initState();
    _loadFeedbacks();
  }

  Future<void> _loadFeedbacks() async {
    setState(() => _isLoading = true);
    try {
      final provider = Provider.of<ClientFeedbackProvider>(
        context,
        listen: false,
      );
      final result = await provider.get(
        filter: {
          "ClientNameGTE": _searchTerm,
          "PackageNameGTE": _packageName,
          if (_createdAfter != null)
            "CreatedAfter": _createdAfter!.toIso8601String(),
          if (_createdBefore != null)
            "CreatedBefore": _createdBefore!.toIso8601String(),
          "isDeleted": true,
          "OrderBy": "IsDeleted",
          "SortDirection": "ASC",
        },
      );
      setState(() {
        _feedbackList = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorAlert(context, "Error fetching Feadbacks ${e.toString()}");
    }
  }

  Future<void> _deleteFeedback(int id) async {
    final result = await showCustomConfirmDialog(
      context,
      title: "Delete Feedback",
      text: "Do you want to delete this feedback?",
    );

    if (result == true) {
      try {
        final provider = Provider.of<ClientFeedbackProvider>(
          context,
          listen: false,
        );
        await provider.delete(id);
        showSuccessAlert(context, "Feedback deleted.");
        _loadFeedbacks();
      } catch (e) {
        showErrorAlert(context, "Error deleting Feedback${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Client feedbacks",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by client name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _searchTerm = value);
                    _loadFeedbacks();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by package name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() => _packageName = value);
                    _loadFeedbacks();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _createdAfter == null
                        ? 'From Date'
                        : formatDate(_createdAfter!),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          _createdAfter ??
                          DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _createdAfter = picked);
                      _loadFeedbacks();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton.icon(
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _createdBefore == null
                        ? 'To Date'
                        : formatDate(_createdBefore!),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _createdBefore ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setState(() => _createdBefore = picked);
                      _loadFeedbacks();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Reset All Filters"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _searchTerm = null;
                  _packageName = null;
                  _createdAfter = null;
                  _createdBefore = null;
                });
                _loadFeedbacks();
              },
            ),
          ),

          const SizedBox(height: 20),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _feedbackList.isEmpty
                    ? const Center(child: Text("No feedbacks found."))
                    : ListView.separated(
                      itemCount: _feedbackList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final feedback = _feedbackList[index];
                        return Opacity(
                          opacity: feedback.isDeleted == true ? 0.5 : 1.0,
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        feedback.clientProfilePicture != null
                                            ? MemoryImage(
                                              base64Decode(
                                                feedback.clientProfilePicture!,
                                              ),
                                            )
                                            : const AssetImage(
                                                  'assets/images/placeholder.png',
                                                )
                                                as ImageProvider,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          feedback.clientName ?? 'Anonymous',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "Date:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  "Package:",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  formatDateString(
                                                    feedback.createdAt,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Text(
                                                  feedback.packageName ?? 'N/A',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (i) => Icon(
                                              i <
                                                      (feedback.rating
                                                              ?.round() ??
                                                          0)
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        if (feedback.comment != null &&
                                            feedback.comment!.trim().isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            child: Text(
                                              feedback.comment!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  feedback.isDeleted == true
                                      ? const Text(
                                        "Deleted",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                      : IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed:
                                            () => _deleteFeedback(
                                              feedback.clientFeedbackId!,
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
        ],
      ),
    );
  }
}
