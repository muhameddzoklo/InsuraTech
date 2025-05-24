import 'package:flutter/material.dart';
import 'package:insuratech_desktop/main.dart';
import 'package:insuratech_desktop/providers/auth_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:insuratech_desktop/screens/claim_requests_screen.dart';
import 'package:insuratech_desktop/screens/client_feedbacks_screen.dart';
import 'package:insuratech_desktop/screens/insurancepackages_screen.dart';
import 'package:insuratech_desktop/screens/loyalty_program_screen.dart';
import 'package:insuratech_desktop/screens/my_profile_screen.dart';
import 'package:insuratech_desktop/screens/notify_clients_screen.dart';
import 'package:insuratech_desktop/screens/support_tickets_screen.dart';
import 'package:insuratech_desktop/screens/users_screen.dart';

class MasterScreen extends StatefulWidget {
  final String title;
  final Widget child;
  final bool showBackButton;

  const MasterScreen({
    super.key,
    required this.title,
    required this.child,
    this.showBackButton = false,
  });

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
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                        _buildSidebarItem(
                          context,
                          "My profile",
                          Icons.account_circle,
                          const MyProfileScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Packages",
                          Icons.inventory,
                          const InsurancePackageScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Users",
                          Icons.person,
                          const UsersScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Claim Requests",
                          Icons.description,
                          const ClaimRequestsScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Notify clients",
                          Icons.notifications,
                          const NotifyClientsScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Support tickets",
                          Icons.support_agent,
                          const SupportTicketsScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Client Feedbacks",
                          Icons.reviews,
                          const ClientFeedbackScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Reports",
                          Icons.edit_document,
                          const Placeholder(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Loyalty program",
                          Icons.loyalty,
                          const LoyaltyProgramScreen(),
                        ),
                        _buildSidebarItem(
                          context,
                          "Management",
                          Icons.settings,
                          const Placeholder(),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    final confirm = await showCustomConfirmDialog(
                      context,
                      title: "Logout",
                      text: "Are you sure you want to logout?",
                      confirmBtnColor: Colors.red,
                    );
                    if (confirm == false) {
                      return;
                    } else {
                      AuthProvider.userId = null;
                      AuthProvider.username = null;
                      AuthProvider.password = null;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF5D4037),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                            widget.showBackButton
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                                : const SizedBox.shrink(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(width: 50),
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

  Widget _buildSidebarItem(
    BuildContext context,
    String title,
    IconData icon,
    Widget screen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => screen));
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
