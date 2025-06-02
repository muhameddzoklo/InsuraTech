import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/support_ticket.dart';
import 'package:insuratech_desktop/providers/auth_provider.dart';
import 'package:insuratech_desktop/providers/support_ticket_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class SupportTicketsScreen extends StatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  State<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends State<SupportTicketsScreen> {
  late SupportTicketProvider _provider;
  List<SupportTicket> _tickets = [];
  bool _isLoading = false;

  DateTime? _dateFrom;
  DateTime? _dateTo;
  bool? _isAnswered;
  bool? _isClosed;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<SupportTicketProvider>(context, listen: false);
    _fetchTickets();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    setState(() => _isLoading = true);

    final result = await _provider.get(
      filter: {
        if (_dateFrom != null) 'dateFrom': _dateFrom,
        if (_dateTo != null) 'dateTo': _dateTo,
        if (_isAnswered != null) 'isAnswered': _isAnswered,
        if (_isClosed != null) 'isClosed': _isClosed,
      },
    );

    if (mounted) {
      setState(() {
        _tickets = result.resultList;
        _isLoading = false;
      });
    }
  }

  void _showResolveTicketDialog(SupportTicket ticket) {
    final replyController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
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
                            "Resolve Ticket",
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
                          "Subject",
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
                          ticket.subject ?? "-",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Message",
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
                          ticket.message ?? "-",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      TextFormField(
                        controller: replyController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: "Reply (required)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Reply is required.";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text("Resolve"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;

                            final updatedData = {
                              "reply": replyController.text.trim(),
                              "isAnswered": true,
                              "isClosed": true,
                              "UserId": AuthProvider.userId,
                            };

                            try {
                              await Provider.of<SupportTicketProvider>(
                                context,
                                listen: false,
                              ).update(ticket.supportTicketId!, updatedData);

                              Navigator.of(context).pop();
                              _fetchTickets();
                              showSuccessAlert(
                                context,
                                "Ticket resolved successfully",
                              );
                            } catch (e) {
                              showErrorAlert(
                                context,
                                "Error resolving ticket: ${e.toString()}",
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateFrom ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() => _dateFrom = date);
              _fetchTickets();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown.shade100,
            foregroundColor: Colors.brown.shade900,
          ),
          child: Text(
            _dateFrom != null
                ? "From: ${_dateFrom!.toLocal().toString().split(' ')[0]}"
                : "From date",
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateTo ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() => _dateTo = date);
              _fetchTickets();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown.shade100,
            foregroundColor: Colors.brown.shade900,
          ),
          child: Text(
            _dateTo != null
                ? "To: ${_dateTo!.toLocal().toString().split(' ')[0]}"
                : "To date",
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<bool?>(
          value: _isAnswered,
          hint: const Text("Answered"),
          items: const [
            DropdownMenuItem(value: null, child: Text("All")),
            DropdownMenuItem(value: true, child: Text("Answered")),
            DropdownMenuItem(value: false, child: Text("Not Answered")),
          ],
          onChanged: (value) {
            setState(() => _isAnswered = value);
            _fetchTickets();
          },
        ),
        const SizedBox(width: 8),
        DropdownButton<bool?>(
          value: _isClosed,
          hint: const Text("Closed"),
          items: const [
            DropdownMenuItem(value: null, child: Text("All")),
            DropdownMenuItem(value: true, child: Text("Closed")),
            DropdownMenuItem(value: false, child: Text("Open")),
          ],
          onChanged: (value) {
            setState(() => _isClosed = value);
            _fetchTickets();
          },
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
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
              _dateFrom = null;
              _dateTo = null;
              _isAnswered = null;
              _isClosed = null;
            });
            _fetchTickets();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Support tickets",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilters(),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _tickets.isEmpty
                    ? const Center(child: Text("No support tickets found."))
                    : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          width: double.infinity,
                          child: DataTable(
                            columnSpacing: 30,
                            dataRowMinHeight: 56,
                            dataRowMaxHeight: 72,
                            columns: const [
                              DataColumn(label: Text('Subject')),
                              DataColumn(label: Text('Created')),
                              DataColumn(label: Text('Answered')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows:
                                _tickets.map((ticket) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(ticket.subject ?? "-")),
                                      DataCell(
                                        Text(
                                          formatDateString(ticket.createdAt),
                                        ),
                                      ),
                                      DataCell(
                                        ticket.isAnswered == true
                                            ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                            : const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                      ),
                                      DataCell(
                                        ticket.isClosed == true
                                            ? const Icon(
                                              Icons.lock,
                                              color: Colors.red,
                                            )
                                            : const Icon(
                                              Icons.lock_open,
                                              color: Colors.green,
                                            ),
                                      ),

                                      DataCell(
                                        SizedBox(
                                          width: 120,
                                          child:
                                              ticket.isClosed == false
                                                  ? ElevatedButton(
                                                    onPressed:
                                                        () =>
                                                            _showResolveTicketDialog(
                                                              ticket,
                                                            ),
                                                    child: const Text(
                                                      "Resolve",
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
                                                      "Resolved",
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
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
