import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/user.dart';
import 'package:insuratech_desktop/providers/auth_provider.dart';
import 'package:insuratech_desktop/providers/users_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:insuratech_desktop/screens/edit_profie_screen.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? _user;
  Uint8List? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final provider = Provider.of<UsersProvider>(context, listen: false);
      final result = await provider.getById(AuthProvider.userId!);

      Uint8List? imageBytes;
      if (result.profilePicture != null && result.profilePicture!.isNotEmpty) {
        imageBytes = base64Decode(result.profilePicture!);
      }

      if (!mounted) return;
      setState(() {
        _user = result;
        _profileImage = imageBytes;
        _isLoading = false;
      });
    } catch (e) {
      showErrorAlert(context, "Error loading profile ${e.toString()}");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "My Profile",
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _user == null
              ? const Center(child: Text("Failed to load user profile."))
              : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;

                  return Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: isWide ? 900 : 600),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: const Color(0xFFEFEBE9),
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      _profileImage != null
                                          ? MemoryImage(_profileImage!)
                                          : const AssetImage(
                                                'assets/images/placeholder.png',
                                              )
                                              as ImageProvider,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "@${_user!.username}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                                const Divider(height: 32, thickness: 1),
                                Table(
                                  columnWidths: const {
                                    0: IntrinsicColumnWidth(),
                                    1: FixedColumnWidth(100),
                                    2: FlexColumnWidth(),
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    _buildTableRow(
                                      icon: Icons.admin_panel_settings,
                                      label: "Role",
                                      value:
                                          _user
                                              ?.userRoles!
                                              .first
                                              .role
                                              ?.roleName ??
                                          "",
                                    ),
                                    _buildTableRow(
                                      icon: Icons.person,
                                      label: "Full name",
                                      value:
                                          "${_user!.firstName} ${_user!.lastName}",
                                    ),
                                    _buildTableRow(
                                      icon: Icons.email,
                                      label: "Email",
                                      value: _user!.email ?? "",
                                    ),
                                    _buildTableRow(
                                      icon: Icons.phone,
                                      label: "Phone",
                                      value: _user!.phoneNumber ?? "N/A",
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => EditProfileScreen(
                                                user: _user!,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text("Edit"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown.shade700,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  TableRow _buildTableRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Icon(icon, color: Colors.brown.shade700),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }

  String formatDateString(String? dateStr) {
    if (dateStr == null) return "N/A";
    final date = DateTime.tryParse(dateStr);
    if (date == null) return "Invalid";
    return "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";
  }
}
