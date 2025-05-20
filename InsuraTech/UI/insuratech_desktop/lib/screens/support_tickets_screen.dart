import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/search_result.dart';
import 'package:insuratech_desktop/models/support_ticket.dart';
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
        'retrieveAll': true,
      },
    );

    if (mounted) {
      setState(() {
        _tickets = result.resultList;
        _isLoading = false;
      });
    }
  }

  void _closeTicket(SupportTicket ticket) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Close Ticket'),
            content: const Text('Are you sure you want to close this ticket?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Close'),
              ),
            ],
          ),
    );
    if (confirm == true) {
      await _provider.CloseTicket(ticket.supportTicketId!);
      _fetchTickets();
    }
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
        IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchTickets),
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
                          width:
                              double
                                  .infinity, // <<< Ovdje se rasteže tabela maksimalno
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
                                          width:
                                              120, // ✅ fiksna širina za oba dugmeta
                                          child:
                                              ticket.isClosed == false
                                                  ? ElevatedButton(
                                                    onPressed:
                                                        () => _closeTicket(
                                                          ticket,
                                                        ),
                                                    child: const Text(
                                                      "Resolve",
                                                    ),
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.blue,
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                  )
                                                  : ElevatedButton(
                                                    onPressed:
                                                        null, // ✅ disabled dugme
                                                    child: const Text(
                                                      "Resolved",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors.grey,
                                                      foregroundColor:
                                                          Colors.black,
                                                      disabledBackgroundColor:
                                                          Colors.grey,
                                                      disabledForegroundColor:
                                                          Colors.black,
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
