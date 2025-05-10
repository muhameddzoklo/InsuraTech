import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:insuratech_mobile/models/insurance_package.dart';
import 'package:insuratech_mobile/providers/insurance_package_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/insurance_package_details_screen.dart';

class InsurancePackageScreen extends StatefulWidget {
  const InsurancePackageScreen({super.key});

  @override
  State<InsurancePackageScreen> createState() => _InsurancePackageScreenState();
}

class _InsurancePackageScreenState extends State<InsurancePackageScreen> {
  late InsurancePackageProvider _insurancePackageProvider;
  List<InsurancePackage> _packages = [];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _insurancePackageProvider = InsurancePackageProvider();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    try {
      final result = await _insurancePackageProvider.get();
      if (!mounted) return;
      setState(() {
        _packages = result.resultList;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      showErrorAlert(context, "Error catching packages: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredPackages =
        _packages
            .where(
              (p) => (p.name ?? '').toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Packages',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
              const SizedBox(height: 20),
              ...filteredPackages.map(_buildPackageCard).toList(),
            ],
          ),
        );
  }

  Widget _buildPackageCard(InsurancePackage package) {
    Uint8List? imageBytes;
    if (package.picture != null && package.picture!.isNotEmpty) {
      imageBytes = base64Decode(package.picture!);
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  imageBytes,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/placeholder.png",
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              package.name ?? '',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              package.description ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              "Price: \$${package.price?.toStringAsFixed(2) ?? 'N/A'}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            if (package.durationDays != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  "Duration: ${package.durationDays} days",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown.shade700,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              InsurancePackageDetailsScreen(package: package),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text("Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
