import 'package:flutter/material.dart';
import 'package:insuratech_mobile/main.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/claim_requests_screen.dart';
import 'package:insuratech_mobile/screens/insurance_package_screen.dart';
import 'package:insuratech_mobile/screens/my_insurance_policies_screen.dart';
import 'package:insuratech_mobile/screens/my_profile_screen.dart';


class MasterScreen extends StatefulWidget {
  final Widget? child;
  final String appBarTitle;
  final bool showBackButton;

  const MasterScreen({
    super.key,
    required this.appBarTitle,
    this.child,
    this.showBackButton = true,
  });

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> _menuItems = [
    {"icon": Icons.policy, "label": "Packages", "screen": const InsurancePackageScreen()},
    {"icon": Icons.account_circle, "label": "My Profile", "screen": MyProfileScreen()},
    {"icon": Icons.assignment, "label": "My Policies", "screen": const MyInsurancePoliciesScreen()},
    {"icon": Icons.description, "label": "My Claims", "screen": const ClaimRequestScreen()},

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget screenToShow =
        _selectedIndex != null ? _menuItems[_selectedIndex!]['screen'] : widget.child!;

    return Scaffold(
      backgroundColor: const Color(0xFFE4E0C8),
      drawer: Drawer(
  child: Column(
    children: [
      const DrawerHeader(
        child: Text(
          "Navigation",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      for (int i = 0; i < _menuItems.length; i++)
        ListTile(
          leading: Icon(_menuItems[i]['icon']),
          title: Text(_menuItems[i]['label']),
          selected: _selectedIndex == i,
          onTap: () {
            Navigator.pop(context);
            _onItemTapped(i);
          },
        ),
      const Spacer(),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("Logout", style: TextStyle(color: Colors.red)),
        onTap: () => _confirmLogout(context),
      ),
    ],
  ),
),


      appBar: AppBar(
        backgroundColor: const Color(0xFFE4E0C8),
        leadingWidth: 100,
        leading: Builder(
          builder: (context) => Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              if (widget.showBackButton)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
            ],
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            _selectedIndex != null ? _menuItems[_selectedIndex!]['label'] : widget.appBarTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: screenToShow,
    );
  }
  void _confirmLogout(BuildContext context) async {
  final confirm = await showCustomConfirmDialog(
  context,
  title: 'Confirm Logout',
  text: 'Are you sure you want to log out?',
  confirmBtnText: 'Logout',
  cancelBtnText: 'Cancel',
  confirmBtnColor: Colors.red,
  cancelBorderColor: Colors.grey.shade600,
);


  if (confirm == true) {
    // Clear credentials
    AuthProvider.username = null;
    AuthProvider.password = null;
    AuthProvider.clientId = null;

    // Return to login
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}

}
