import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/loyalty_program.dart';
import 'package:insuratech_desktop/providers/loyalty_program_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';

class LoyaltyProgramScreen extends StatefulWidget {
  const LoyaltyProgramScreen({super.key});

  @override
  State<LoyaltyProgramScreen> createState() => _LoyaltyProgramScreenState();
}

class _LoyaltyProgramScreenState extends State<LoyaltyProgramScreen> {
  final _provider = LoyaltyProgramProvider();
  List<LoyaltyProgram> _loyaltyList = [];
  bool _isLoading = true;
  String _searchClient = '';
  int? _selectedTier;

  @override
  void initState() {
    super.initState();
    _loadLoyaltyPrograms();
  }

  Future<void> _loadLoyaltyPrograms() async {
    try {
      var filter = {
        if (_selectedTier != null) 'Status': _selectedTier,
        if (_searchClient.isNotEmpty) 'ClientNameGTE': _searchClient,
      };
      final result = await _provider.get(filter: filter);
      setState(() {
        _loyaltyList = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      showErrorAlert(context, "Error loading loyalty programs: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Loyalty Program",
      child: Container(
        color: const Color(0xFFF4F1EE),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildFilters(),
            const SizedBox(height: 16),
            _buildTierInfoCard(),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(child: _buildDataTable()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: " Search by client name...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.brown.shade400),
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.brown),
            ),
            onChanged: (val) {
              setState(() => _searchClient = val);
              _loadLoyaltyPrograms();
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "Loyalty Tier",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            value: _selectedTier,
            items: const [
              DropdownMenuItem(value: null, child: Text("All")),
              DropdownMenuItem(value: 0, child: Text("Bronze")),
              DropdownMenuItem(value: 1, child: Text("Silver")),
              DropdownMenuItem(value: 2, child: Text("Gold")),
              DropdownMenuItem(value: 3, child: Text("Platinum")),
            ],
            onChanged: (val) {
              setState(() => _selectedTier = val);
              _loadLoyaltyPrograms();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTierInfoCard() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 700,
        minWidth: 700,
      ), // Fiksna širina
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centriraj sve
            children: [
              const Text(
                "Loyalty Tier Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              _buildTierRow(
                "Bronze",
                "0-100 points",
                "1% discount",
                const Color(0xFFCD7F32),
              ),
              _buildTierRow(
                "Silver",
                "101-250 points",
                "5% discount",
                const Color.fromARGB(255, 145, 143, 143),
              ),
              _buildTierRow(
                "Gold",
                "251-500 points",
                "10% discount",
                const Color.fromARGB(255, 205, 175, 3),
              ),
              _buildTierRow(
                "Platinum",
                "501+ points",
                "15% discount",
                const Color(0xFF2196F3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTierRow(
    String name,
    String points,
    String discount,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Centriraj redove
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            "$name: ",
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
          ),
          Text("$points ($discount)", textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 700,
            maxWidth: 700,
          ), // Fiksna širina
          child: DataTable(
            columnSpacing: 10,
            columns: const [
              DataColumn(label: SizedBox(width: 100, child: Text("Client"))),
              DataColumn(label: SizedBox(width: 100, child: Text("Points"))),
              DataColumn(label: SizedBox(width: 100, child: Text("Tier"))),
              DataColumn(
                label: SizedBox(width: 100, child: Text("Last Updated")),
              ),
              DataColumn(label: SizedBox(width: 100, child: Text("Actions"))),
            ],
            rows:
                _loyaltyList.map((program) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          "${program.client!.firstName} ${program.client!.lastName}",
                        ),
                      ),
                      DataCell(Text(program.points.toString())),
                      DataCell(
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: getLoyaltyTierColor(program.tier),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              getLoyaltyTierName(program.tier),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: getLoyaltyTierColor(program.tier),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(formatDateString(program.lastUpdated))),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.upgrade,
                                color: Colors.green,
                              ),
                              onPressed: () => _updateTier(program),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.blue),
                              onPressed: () => _addPoints(program),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => _removePoints(program),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _updateTier(LoyaltyProgram program) async {
    int? selectedTier = program.tier;
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Change Tier"),
              content: DropdownButton<int>(
                value: selectedTier,
                items: const [
                  DropdownMenuItem(value: 0, child: Text("Bronze")),
                  DropdownMenuItem(value: 1, child: Text("Silver")),
                  DropdownMenuItem(value: 2, child: Text("Gold")),
                  DropdownMenuItem(value: 3, child: Text("Platinum")),
                ],
                onChanged: (val) {
                  setState(() {
                    selectedTier = val;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, selectedTier),
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    ).then((newTier) async {
      if (newTier != null) {
        await _provider.update(program.loyaltyProgramId!, {'Tier': newTier});
        _loadLoyaltyPrograms();
      }
    });
  }

  Future<void> _addPoints(LoyaltyProgram program) async {
    int points = 0;
    int? newPoints = await showDialog<int>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Add Points"),
            content: TextField(
              decoration: const InputDecoration(labelText: "Points"),
              keyboardType: TextInputType.number,
              onChanged: (val) => points = int.tryParse(val) ?? 0,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, points),
                child: const Text("Add"),
              ),
            ],
          ),
    );
    if (newPoints != null) {
      await _provider.update(program.loyaltyProgramId!, {
        'Points': (program.points ?? 0) + newPoints,
      });
      _loadLoyaltyPrograms();
    }
  }

  Future<void> _removePoints(LoyaltyProgram program) async {
    int points = 0;
    int? removedPoints = await showDialog<int>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Remove Points"),
            content: TextField(
              decoration: const InputDecoration(labelText: "Points"),
              keyboardType: TextInputType.number,
              onChanged: (val) => points = int.tryParse(val) ?? 0,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, points),
                child: const Text("Remove"),
              ),
            ],
          ),
    );
    if (removedPoints != null) {
      int newTotal = (program.points ?? 0) - removedPoints;
      if (newTotal < 0) newTotal = 0;
      await _provider.update(program.loyaltyProgramId!, {'Points': newTotal});
      _loadLoyaltyPrograms();
    }
  }
}
