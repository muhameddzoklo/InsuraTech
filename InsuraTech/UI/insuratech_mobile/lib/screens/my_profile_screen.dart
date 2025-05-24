import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insuratech_mobile/models/client.dart';
import 'package:insuratech_mobile/models/loyalty_program.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/client_provider.dart';
import 'package:insuratech_mobile/providers/loyalty_program_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/edit_profile_screen.dart';
import 'package:insuratech_mobile/screens/loyalty_program_screen.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Client? _client;
  Uint8List? _previewImage;
  LoyaltyProgram? _loyaltyProgram;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileAndLoyalty();
  }

  Future<void> _loadProfileAndLoyalty() async {
    try {
      final clientProvider = Provider.of<ClientProvider>(
        context,
        listen: false,
      );
      final loyaltyProvider = LoyaltyProgramProvider();
      final clientId = AuthProvider.clientId!;

      final clientResult = await clientProvider.getById(clientId);
      final loyaltyResult = await loyaltyProvider.get(
        filter: {"ClientId": clientId},
      );

      Uint8List? imageBytes;
      if (clientResult.profilePicture != null &&
          clientResult.profilePicture!.isNotEmpty) {
        try {
          imageBytes = base64Decode(clientResult.profilePicture!);
        } catch (e) {
          showErrorAlert(context, "Error decoding picture: ${e.toString()}");
        }
      }

      if (!mounted) return;
      setState(() {
        _client = clientResult;
        _previewImage = imageBytes;
        _loyaltyProgram =
            loyaltyResult.resultList.isNotEmpty
                ? loyaltyResult.resultList.first
                : null;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showErrorAlert(context, "Error loading data: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_client == null) {
      return const Center(child: Text("Failed to load profile."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                _previewImage != null
                    ? MemoryImage(_previewImage!)
                    : const AssetImage('assets/images/placeholder.png')
                        as ImageProvider,
          ),
          const SizedBox(height: 20),
          Text(
            "${_client!.firstName ?? ''} ${_client!.lastName ?? ''}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "@${_client!.username ?? 'unknown'}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          _buildInfoTile(Icons.email, "Email", _client!.email),
          _buildInfoTile(Icons.phone, "Phone", _client!.phoneNumber),
          _buildInfoTile(
            Icons.calendar_today,
            "Member Since",
            formatDateString(_client!.registrationDate),
          ),
          _buildLoyaltyCard(),
          const SizedBox(height: 60),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(client: _client!),
                ),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profile"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String? value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(label),
        subtitle: Text(value ?? 'N/A'),
      ),
    );
  }

  Widget _buildLoyaltyCard() {
    if (_loyaltyProgram == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(top: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Loyalty Program",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text("Tier:"),
                Text(
                  " ${getLoyaltyTierName(_loyaltyProgram!.tier)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: getLoyaltyTierColor(_loyaltyProgram!.tier),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => LoyaltyProgramScreen(
                            loyaltyProgram: _loyaltyProgram!,
                          ),
                    ),
                  );
                },
                icon: const Icon(Icons.info),
                label: const Text("Details"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
