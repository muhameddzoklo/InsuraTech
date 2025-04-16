import 'package:flutter/material.dart';
import 'package:insuratech_desktop/screens/insurancepackages_screen.dart';
import 'package:insuratech_desktop/screens/placeholder_screen.dart';

class MasterScreen extends StatefulWidget {
  final String title;
  final Widget child;

  const MasterScreen({super.key, required this.title, required this.child});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6D4C41),
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: const Color(0xFF8D6E63),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(3, 0),
                )
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSidebarItem(context, "Packages", Icons.inventory, const InsurancePackageScreen()),
                _buildSidebarItem(context, "Termini", Icons.event, const PlaceholderListScreen()),
                _buildSidebarItem(context, "Statistika", Icons.bar_chart, const PlaceholderListScreen()),
                _buildSidebarItem(context, "Recepti", Icons.receipt, const PlaceholderListScreen()),
                _buildSidebarItem(context, "Obavještenja", Icons.notifications, const PlaceholderListScreen()),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5D4037),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.account_circle, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.brown.shade50,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, String title, IconData icon, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}