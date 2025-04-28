import 'package:flutter/material.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:insuratech_mobile/providers/insurance_policy_provider.dart';
import 'package:insuratech_mobile/models/insurance_policy.dart'; // Pretpostavljam da imaš model za polisu

class MyInsurancePoliciesScreen extends StatefulWidget {
  const MyInsurancePoliciesScreen({super.key});

  @override
  State<MyInsurancePoliciesScreen> createState() => _MyInsurancePoliciesScreenState();
}

class _MyInsurancePoliciesScreenState extends State<MyInsurancePoliciesScreen> {
  List<InsurancePolicy> _policies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPolicies();
  }

 Future<void> _fetchPolicies() async {
  try {
    var insurancePolicyProvider = Provider.of<InsurancePolicyProvider>(context, listen: false);
    var searchResult = await insurancePolicyProvider.get(
      orderBy: "IsActive",
      sortDirection: "desc",
      
      filter: {"ClientUsernameGTE": AuthProvider.username},
      
    );
   

    setState(() {
      _policies = searchResult.resultList;
      _isLoading = false;
    });
  } catch (e) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading policies: ${e.toString()}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE4E0C8),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _policies.isEmpty
              ? const Center(child: Text('No policies found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _policies.length,
                  itemBuilder: (context, index) {
  final policy = _policies[index];
  final bool isActive = policy.isActive ?? false; // assuming policy has isActive field

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${policy.insurancePackage!.name ?? "N/A"}', style: _titleStyle),
              const SizedBox(height: 8),
              Text('Start Date: ${formatDateString(policy.startDate)}', style: _infoStyle),
              Text('End Date: ${formatDateString(policy.endDate)}', style: _infoStyle),
              const SizedBox(height: 12),
              if (isActive) // Claim Request samo ako je active
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Claim Request coming soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Claim Request'),
                  ),
                ),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isActive ? 'Active' : 'Inactive',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
},

                ),
    );
  }



  static const TextStyle _titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.brown,
  );

  static const TextStyle _infoStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );
}
