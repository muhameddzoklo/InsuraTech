import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/client_feedback.dart';
import 'package:insuratech_desktop/providers/client_feedback_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class ClientFeedbackScreen extends StatefulWidget {
  const ClientFeedbackScreen({super.key});

  @override
  State<ClientFeedbackScreen> createState() => _ClientFeedbackScreenState();
}

class _ClientFeedbackScreenState extends State<ClientFeedbackScreen> {
  List<ClientFeedback> _feedbackList = [];
  bool _isLoading = true;
  String? _searchTerm;

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
        filter: {"ClientNameGTE": _searchTerm, "isDeleted": true},
      );
      setState(() {
        _feedbackList = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorAlert(context, e.toString());
    }
  }

  Future<void> _deleteFeedback(int id) async {
    try {
      final provider = Provider.of<ClientFeedbackProvider>(
        context,
        listen: false,
      );
      await provider.delete(id);
      showSuccessAlert(context, "Feedback deleted.");
      _loadFeedbacks();
    } catch (e) {
      showErrorAlert(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Support tickets",
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
            ],
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
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      feedback.clientName ?? 'Anonymous',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed:
                                          () => _deleteFeedback(
                                            feedback.clientFeedbackId!,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < (feedback.rating?.round() ?? 0)
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                if (feedback.comment != null &&
                                    feedback.comment!.trim().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(feedback.comment!),
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
