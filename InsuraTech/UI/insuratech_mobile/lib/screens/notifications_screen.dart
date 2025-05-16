import 'package:flutter/material.dart';
import 'package:insuratech_mobile/models/notification.dart' as model;
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/notification_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<model.Notification> _notifications = [];
  bool _isLoading = true;
  Set<int> _expandedItems = {};

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final provider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );
      final result = await provider.get(
        filter: {'ClientId': AuthProvider.clientId},
        includeTables: 'InsurancePolicy.InsurancePackage',
        orderBy: "IsRead",
        sortDirection: "ASC",
      );
      setState(() {
        _notifications = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorAlert(context, "Failed to load notifications: ${e.toString()}");
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24)
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    if (diff.inDays < 7)
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    if (diff.inDays < 30)
      return '${(diff.inDays / 7).floor()} week${(diff.inDays / 7).floor() > 1 ? 's' : ''} ago';
    return '${(diff.inDays / 30).floor()} month${(diff.inDays / 30).floor() > 1 ? 's' : ''} ago';
  }

  void _toggleExpand(int id) {
    setState(() {
      if (_expandedItems.contains(id)) {
        _expandedItems.remove(id);
      } else {
        _expandedItems.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _notifications.isEmpty
        ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.notifications_active, size: 64, color: Colors.brown),
              SizedBox(height: 12),
              Text(
                "No notifications",
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
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final n = _notifications[index];
            final isRead = n.isRead ?? false;
            final title =
                n.insurancePolicy?.insurancePackage?.name ?? 'Unknown package';
            final sentDate =
                n.sentAt != null
                    ? _formatTimeAgo(DateTime.parse(n.sentAt!))
                    : 'Unknown date';
            final expanded = _expandedItems.contains(n.notificationId);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color:
                    isRead
                        ? Colors.blueGrey.shade100
                        : Colors.blueGrey.shade200,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () async {
                  if (!(n.isRead ?? false)) {
                    try {
                      await Provider.of<NotificationProvider>(
                        context,
                        listen: false,
                      ).update(n.notificationId!, {'isRead': true});
                      setState(() {
                        n.isRead = true;
                      });
                      _toggleExpand(n.notificationId!);
                    } catch (e) {
                      showErrorAlert(
                        context,
                        "Failed to mark as read: ${e.toString()}",
                      );
                    }
                  } else {
                    _toggleExpand(n.notificationId!);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        " $sentDate",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      if (expanded) ...[
                        const SizedBox(height: 14),
                        Text(
                          n.message ?? "No message provided.",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedRotation(
                            duration: const Duration(milliseconds: 200),
                            turns: expanded ? 0.5 : 0,
                            child: const Icon(Icons.expand_more, size: 24),
                          ),
                          if (n.isRead == true)
                            TextButton.icon(
                              onPressed: () async {
                                final confirm = await showCustomConfirmDialog(
                                  context,
                                  title: "Delete Notification",
                                  text:
                                      "Are you sure you want to delete this notification?",
                                  confirmBtnColor: Colors.red,
                                );
                                if (confirm == true) {
                                  try {
                                    await Provider.of<NotificationProvider>(
                                      context,
                                      listen: false,
                                    ).delete(n.notificationId!);
                                    setState(() {
                                      _notifications.removeAt(index);
                                    });
                                    showSuccessAlert(
                                      context,
                                      "Notification deleted.",
                                    );
                                  } catch (e) {
                                    showErrorAlert(
                                      context,
                                      "Failed to delete notification: ${e.toString()}",
                                    );
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}
