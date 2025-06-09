import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/report.dart';
import 'package:insuratech_desktop/providers/report_provider.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String? selectedYear;
  String? selectedMonth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReport();
    });
  }

  Future<Uint8List> _generatePdf({
    required Report report,
    required List<RevenuePerMonth> filteredProfit,
    required List<TopPackage> filteredPackages,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build:
            (pw.Context context) => [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'InsuraTech Report',
                  style: pw.TextStyle(fontSize: 24),
                ),
              ),
              pw.Paragraph(
                text:
                    "Total Profit: \$${report.totalProfit.toStringAsFixed(2)}",
              ),
              pw.SizedBox(height: 8),
              pw.Text("Profit per Month:"),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Month', 'Profit'],
                data:
                    filteredProfit
                        .map(
                          (e) => [e.month, "\$${e.profit.toStringAsFixed(2)}"],
                        )
                        .toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text("Top Packages:"),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Name', 'Sold', 'Rating'],
                data:
                    filteredPackages
                        .map(
                          (e) => [
                            e.name,
                            e.soldPolicies,
                            e.averageRating?.toStringAsFixed(2) ?? "N/A",
                          ],
                        )
                        .toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text("Policies:"),
              pw.Bullet(text: "Total: ${report.totalPolicies}"),
              pw.Bullet(text: "Active: ${report.activePolicies}"),
              pw.Bullet(text: "Expired: ${report.expiredPolicies}"),
              pw.Bullet(text: "Paid: ${report.paidPolicies}"),
              pw.SizedBox(height: 16),
              pw.Text("Claim Requests:"),
              pw.Bullet(text: "Total: ${report.totalClaimRequests}"),
              pw.Bullet(text: "Accepted: ${report.acceptedClaims}"),
              pw.Bullet(text: "Declined: ${report.declinedClaims}"),
              pw.Bullet(text: "Pending: ${report.pendingClaims}"),
              pw.SizedBox(height: 16),
              pw.Text("Top Packages:"),
              pw.Table.fromTextArray(
                context: context,
                headers: ['Name', 'Sold', 'Rating'],
                data:
                    report.topPackagesBySales
                        .map(
                          (e) => [
                            e.name,
                            e.soldPolicies,
                            e.averageRating?.toStringAsFixed(2) ?? "N/A",
                          ],
                        )
                        .toList(),
              ),
              pw.SizedBox(height: 16),
              pw.Text("Client Feedback:"),
              pw.Bullet(text: "Total Reviews: ${report.totalReviews}"),
              pw.Bullet(
                text:
                    "Avg. Rating: ${report.averagePackageRating.toStringAsFixed(2)}",
              ),
            ],
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportProvider>(context);
    final report = provider.report;

    List<String> availableYears = [];
    List<String> availableMonths = [
      '01',
      '02',
      '03',
      '04',
      '05',
      '06',
      '07',
      '08',
      '09',
      '10',
      '11',
      '12',
    ];

    if (report != null) {
      availableYears =
          report.profitPerMonth
              .map((e) => e.month.split('-')[0])
              .toSet()
              .toList()
            ..sort();
    }

    List<RevenuePerMonth> filteredProfit =
        report == null
            ? []
            : report.profitPerMonth.where((e) {
              final year = e.month.split('-')[0];
              final month = e.month.split('-')[1];
              if (selectedYear != null && year != selectedYear) return false;
              if (selectedMonth != null && month != selectedMonth) return false;
              return true;
            }).toList();

    final filteredPackages = report?.topPackagesBySales ?? [];
    return MasterScreen(
      title: "Reports",
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      hint: const Text('Year'),
                      value: selectedYear,
                      items:
                          availableYears
                              .map(
                                (y) =>
                                    DropdownMenuItem(value: y, child: Text(y)),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      hint: const Text('Month'),
                      value: selectedMonth,
                      items:
                          availableMonths
                              .map(
                                (m) =>
                                    DropdownMenuItem(value: m, child: Text(m)),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth = value;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7BBA8),
                        foregroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedYear = null;
                          selectedMonth = null;
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7BBA8),
                        foregroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (report == null) return;
                        final pdfData = await _generatePdf(
                          report: report,
                          filteredProfit: filteredProfit,
                          filteredPackages: filteredPackages,
                        );
                        await Printing.sharePdf(
                          bytes: pdfData,
                          filename: 'report.pdf',
                        );
                      },

                      icon: const Icon(Icons.download),
                      label: const Text('Download PDF'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD7BBA8),
                        foregroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        if (report == null) return;
                        final pdfData = await _generatePdf(
                          report: report,
                          filteredProfit: filteredProfit,
                          filteredPackages: filteredPackages,
                        );
                        await Printing.layoutPdf(
                          onLayout: (format) async => pdfData,
                        );
                      },

                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (provider.error != null)
              Center(
                child: Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (report == null)
              const Center(child: Text("No report data available."))
            else
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _dashboardCard(
                      child: ListTile(
                        title: const Text("Total Profit"),
                        trailing: Text(
                          "\$${report.totalProfit.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    _dashboardCard(
                      child: ListTile(
                        title: const Text("Profit per Month"),
                        subtitle: SizedBox(
                          height: 160,
                          child:
                              filteredProfit.isEmpty
                                  ? const Center(
                                    child: Text("No data for selected period"),
                                  )
                                  : ListView(
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        filteredProfit.map((e) {
                                          return Container(
                                            margin: const EdgeInsets.all(6),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.brown,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.brown.shade100,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  e.month,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "\$${e.profit.toStringAsFixed(2)}",
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                  ),
                        ),
                      ),
                    ),
                    _dashboardCard(
                      child: ListTile(
                        title: const Text("Policies"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _stat("Total", report.totalPolicies),
                            _stat("Active", report.activePolicies),
                            _stat("Expired", report.expiredPolicies),
                            _stat("Paid", report.paidPolicies),
                          ],
                        ),
                      ),
                    ),
                    _dashboardCard(
                      child: ListTile(
                        title: const Text("Claim Requests"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _stat("Total", report.totalClaimRequests),
                            _stat("Accepted", report.acceptedClaims),
                            _stat("Declined", report.declinedClaims),
                            _stat("Pending", report.pendingClaims),
                          ],
                        ),
                      ),
                    ),

                    _dashboardCard(
                      child: ListTile(
                        title: const Text("Top Packages by Sales"),
                        subtitle: SizedBox(
                          height: 160,
                          child:
                              report.topPackagesBySales.isEmpty
                                  ? const Center(child: Text("No packages."))
                                  : ListView(
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        report.topPackagesBySales.map((pkg) {
                                          return Container(
                                            margin: const EdgeInsets.all(6),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.brown,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.brown.shade100,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  pkg.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Sold: ${pkg.soldPolicies}",
                                                ),
                                                Text(
                                                  "Rating: ${pkg.averageRating?.toStringAsFixed(2) ?? 'N/A'}",
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                  ),
                        ),
                      ),
                    ),
                    _dashboardCard(
                      child: ListTile(
                        title: const Text("Client Feedback"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _stat("Total Reviews", report.totalReviews),
                            _stat(
                              "Avg. Rating",
                              report.averagePackageRating.toStringAsFixed(2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard({required Widget child}) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFF8EDE6),
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.brown.shade100.withOpacity(0.18),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.brown.shade100, width: 1),
    ),
    child: child,
  );

  Widget _stat(String label, dynamic value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}
