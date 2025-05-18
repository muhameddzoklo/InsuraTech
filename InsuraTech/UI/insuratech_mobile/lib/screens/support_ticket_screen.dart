import 'package:flutter/material.dart';
import 'package:insuratech_mobile/models/support_ticket.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/support_ticket_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/layouts/master_screen.dart';
import 'package:provider/provider.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  List<SupportTicket> _tickets = [];
  bool _isLoading = true;

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => _isLoading = true);
    final provider = Provider.of<SupportTicketProvider>(context, listen: false);
    final result = await provider.get(
      filter: {"clientId": AuthProvider.clientId},
    );

    if (!mounted) return;
    setState(() {
      _tickets = result.resultList;
      _isLoading = false;
    });
  }

  Future<void> _closeTicket(int id) async {
    final provider = Provider.of<SupportTicketProvider>(context, listen: false);
    try {
      final msg = await provider.CloseTicket(id);
      await _loadTickets();
      showSuccessAlert(context, msg);
    } catch (e) {
      showErrorAlert(context, e.toString());
    }
  }

  void _showCreateTicketDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("New Support Ticket"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: "Subject"),
              ),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(labelText: "Message"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final subject = _subjectController.text.trim();
                final message = _messageController.text.trim();

                if (subject.isEmpty || message.isEmpty) {
                  showErrorAlert(context, "Both fields are required.");
                  return;
                }

                final request = {
                  "clientId": AuthProvider.clientId,
                  "subject": subject,
                  "message": message,
                };

                final provider = Provider.of<SupportTicketProvider>(
                  context,
                  listen: false,
                );

                try {
                  await provider.insert(request);
                  Navigator.pop(context);
                  await _loadTickets();
                  showSuccessAlert(context, "Ticket submitted.");
                  _subjectController.clear();
                  _messageController.clear();
                } catch (e) {
                  showErrorAlert(context, e.toString());
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  String getTicketStatusLabel(SupportTicket t) {
    if ((t.isClosed ?? false) && (t.isAnswered ?? false)) {
      return "Resolved";
    }
    return "Unresolved";
  }

  Color getTicketStatusColor(SupportTicket t) {
    if (getTicketStatusLabel(t) == "Resolved") {
      return Colors.green[100]!;
    }
    return Colors.orange[100]!;
  }

  Color getTicketStatusTextColor(SupportTicket t) {
    if (getTicketStatusLabel(t) == "Resolved") {
      return Colors.green[800]!;
    }
    return Colors.orange[800]!;
  }

  Future<void> _deleteTicket(int id) async {
    final provider = Provider.of<SupportTicketProvider>(context, listen: false);
    try {
      await provider.delete(id);
      await _loadTickets();
      showSuccessAlert(context, "Ticket deleted.");
    } catch (e) {
      showErrorAlert(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("New Ticket"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                onPressed: _showCreateTicketDialog,
              ),
            ),
            Expanded(
              child:
                  _tickets.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.support_agent,
                              size: 60,
                              color: Colors.brown,
                            ),
                            SizedBox(height: 12),
                            Text("You have no support tickets."),
                          ],
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _tickets.length,
                        itemBuilder: (context, index) {
                          final t = _tickets[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            color: const Color(0xFFFFF3E0),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Status row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: getTicketStatusColor(t),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          getTicketStatusLabel(t),
                                          style: TextStyle(
                                            color: getTicketStatusTextColor(t),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      if ((t.isClosed ?? false))
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Closed",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              tooltip: "Delete ticket",
                                              onPressed: () async {
                                                final confirmed =
                                                    await showCustomConfirmDialog(
                                                      context,
                                                      title: "Delete Ticket",
                                                      text:
                                                          "Are you sure you want to permanently delete this ticket?",
                                                    );
                                                if (confirmed == true) {
                                                  await _deleteTicket(
                                                    t.supportTicketId!,
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    t.subject ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text("Message: ${t.message}"),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Created: ${formatDateString(t.createdAt)}",
                                  ),
                                  if (t.reply != null) ...[
                                    const SizedBox(height: 6),
                                    Text("Reply: ${t.reply}"),
                                  ],
                                  const SizedBox(height: 10),
                                  if (!(t.isClosed ?? false))
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed:
                                            () => _closeTicket(
                                              t.supportTicketId!,
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade400,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                        child: const Text("Close Ticket"),
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
        );
  }
}
