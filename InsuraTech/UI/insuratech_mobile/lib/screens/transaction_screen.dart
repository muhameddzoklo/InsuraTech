import 'package:flutter/material.dart';
import 'package:insuratech_mobile/models/transaction.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/transaction_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

enum TransactionRange { all, last30Days, last3Months, last6Months, lastYear }

extension TransactionRangeExtension on TransactionRange {
  String get label {
    switch (this) {
      case TransactionRange.last3Months:
        return "Last 3 months";
      case TransactionRange.last6Months:
        return "Last 6 months";
      case TransactionRange.lastYear:
        return "Last year";
      default:
        return "Last 30 days";
    }
  }

  Map<String, String> get dateRange {
    final now = DateTime.now();
    DateTime from;
    switch (this) {
      case TransactionRange.last3Months:
        from = now.subtract(const Duration(days: 90));
        break;
      case TransactionRange.last6Months:
        from = now.subtract(const Duration(days: 180));
        break;
      case TransactionRange.lastYear:
        from = now.subtract(const Duration(days: 365));
        break;
      default:
        from = now.subtract(const Duration(days: 30));
    }
    return {
      "FromDate": from.toIso8601String(),
      "ToDate": now.toIso8601String(),
    };
  }
}

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];
  TransactionRange _selectedRange = TransactionRange.last30Days;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    final filter = {
      "clientId": AuthProvider.clientId,
      if (_selectedRange != TransactionRange.all)
        "dateFrom": _calculateDateFrom(_selectedRange).toIso8601String(),
    };

    if (_selectedRange != TransactionRange.all) {
      final dateFrom = _calculateDateFrom(_selectedRange);
      filter["dateFrom"] = dateFrom.toIso8601String();
    }

    final result = await provider.get(filter: filter);

    if (!mounted) return;
    setState(() {
      _transactions = result.resultList;
    });
  }

  DateTime _calculateDateFrom(TransactionRange range) {
    final now = DateTime.now();

    switch (range) {
      case TransactionRange.last3Months:
        return now.subtract(const Duration(days: 90));
      case TransactionRange.last6Months:
        return now.subtract(const Duration(days: 180));
      case TransactionRange.lastYear:
        return now.subtract(const Duration(days: 365));
      case TransactionRange.last30Days:
      default:
        return now.subtract(const Duration(days: 30));
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(flex: 7, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildBoldInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: DropdownButton<TransactionRange>(
            value: _selectedRange,
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: TransactionRange.all, child: Text("All")),
              DropdownMenuItem(
                value: TransactionRange.last30Days,
                child: Text("Last 30 days"),
              ),
              DropdownMenuItem(
                value: TransactionRange.last3Months,
                child: Text("Last 3 months"),
              ),
              DropdownMenuItem(
                value: TransactionRange.last6Months,
                child: Text("Last 6 months"),
              ),
              DropdownMenuItem(
                value: TransactionRange.lastYear,
                child: Text("Last year"),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedRange = value;
                });
                _loadTransactions();
              }
            },
          ),
        ),
        Expanded(
          child:
              _transactions.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.receipt_long, size: 64, color: Colors.brown),
                        SizedBox(height: 12),
                        Text(
                          "No transactions found",
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
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final t = _transactions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        color: const Color(0xFFFBE9E7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.paymentId ?? "N/A",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                "Paid on:",
                                formatDateString(t.transactionDate),
                              ),
                              _buildBoldInfoRow(
                                "Amount:",
                                "\$${t.amount?.toStringAsFixed(2) ?? "0.00"}",
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.info_outline,
                                    size: 16,
                                  ),
                                  label: const Text(
                                    "Details",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown.shade400,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 32),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final policy = t.insurancePolicy;
                                        final package =
                                            policy?.insurancePackage;
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          titlePadding: const EdgeInsets.only(
                                            left: 20,
                                            top: 16,
                                            right: 8,
                                          ),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Policy Details",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close),
                                                splashRadius: 20,
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                              ),
                                            ],
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildInfoRow(
                                                "Package:",
                                                package?.name ?? "N/A",
                                              ),
                                              _buildInfoRow(
                                                "Duration:",
                                                "${package?.durationDays ?? "N/A"} days",
                                              ),
                                              _buildInfoRow(
                                                "Start:",
                                                formatDateString(
                                                  policy?.startDate,
                                                ),
                                              ),
                                              _buildInfoRow(
                                                "End:",
                                                formatDateString(
                                                  policy?.endDate,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
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
