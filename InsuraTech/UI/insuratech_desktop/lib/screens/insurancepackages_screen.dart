import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/insurance_package.dart';
import 'package:insuratech_desktop/providers/insurance_package_provider.dart';
import 'package:provider/provider.dart';

class InsurancePackageScreen extends StatefulWidget {
  const InsurancePackageScreen({super.key});

  @override
  State<InsurancePackageScreen> createState() => _InsurancePackageScreenState();
}

class _InsurancePackageScreenState extends State<InsurancePackageScreen> {
  List<InsurancePackage> _packages = [];
  List<InsurancePackage> _filteredPackages = [];
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPackages();

    _searchController.addListener(() {
      _filterPackages();
    });
  }

  Future<void> _fetchPackages() async {
    setState(() => _isLoading = true);

    try {
      var packagesResult = await Provider.of<InsurancePackageProvider>(context, listen: false)
          .get(retrieveAll: true);

      setState(() {
        _packages = packagesResult.resultList;
        _filteredPackages = _packages;
      });
    } catch (e) {
      print('Greška pri dohvaćanju paketa: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterPackages() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredPackages = _packages
          .where((package) => package.name!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Insurance Packages",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search packages...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Package"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 18,
                  ),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _filteredPackages.length,
                    itemBuilder: (context, index) {
                      final package = _filteredPackages[index];
                      return InsurancePackageCard(package: package);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class InsurancePackageCard extends StatelessWidget {
  final InsurancePackage package;

  const InsurancePackageCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              package.name ?? 'N/A',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                package.description ?? 'No description',
                style: TextStyle(color: Colors.grey[700]),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${package.price?.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D6E63),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text("Hide", style: TextStyle(color: Colors.white)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
