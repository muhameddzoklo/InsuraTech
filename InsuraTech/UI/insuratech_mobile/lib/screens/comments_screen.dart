import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insuratech_mobile/models/client_feedback.dart';
import 'package:insuratech_mobile/providers/client_feedback_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class CommentsScreen extends StatefulWidget {
  final int packageId;

  const CommentsScreen({super.key, required this.packageId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<ClientFeedback> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final feedbackProvider = Provider.of<ClientFeedbackProvider>(
        context,
        listen: false,
      );
      final result = await feedbackProvider.get(
        filter: {"InsurancePackageId": widget.packageId, "isDeleted": false},
      );

      if (!mounted) return;
      setState(() {
        _comments = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showErrorAlert(context, "Failed to load comments: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_comments.isEmpty) {
      return const Center(
        child: Text("No comments found.", style: TextStyle(fontSize: 16)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _comments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final comment = _comments[index];
        Uint8List? profileImageBytes;
        if (comment.clientProfilePicture != null &&
            comment.clientProfilePicture!.isNotEmpty) {
          profileImageBytes = base64Decode(comment.clientProfilePicture!);
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        profileImageBytes != null
                            ? MemoryImage(profileImageBytes)
                            : null,
                    child:
                        profileImageBytes == null
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.clientName ?? "Anonymous",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          comment.createdAt != null
                              ? formatDateString(comment.createdAt)
                              : '',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < (comment.rating?.round() ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
              if (comment.comment != null && comment.comment!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(comment.comment!),
                ),
            ],
          ),
        );
      },
    );
  }
}
