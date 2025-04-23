import 'package:flutter/material.dart';
import 'package:insuratech_mobile/screens/insurance_package_screen.dart';

class MasterScreen extends StatefulWidget {
  final Widget child;
  final String appBarTitle;
  final bool showBackButton;

  const MasterScreen({
    super.key,
    required this.child,
    required this.appBarTitle,
    this.showBackButton = true,
  });

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {"icon": Icons.home, "label": "Home", "screen": Placeholder()},
    {
      "icon": Icons.policy,
      "label": "Packages",
      "screen": InsurancePackageScreen(),
    },
    {"icon": Icons.account_circle, "label": "Profile", "screen": Placeholder()},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) => MasterScreen(
              appBarTitle: _menuItems[index]['label'],
              child: _menuItems[index]['screen'],
              showBackButton: false, // jer je to root screen
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Navigator.pop(context); // zatvori drawer
                  _onItemTapped(i);
                },
              ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE4E0C8),
        leadingWidth: 100,
        leading: Builder(
          builder:
              (context) => Row(
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
            widget.appBarTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: widget.child,
    );
  }
}
