import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:insuratech_mobile/models/client.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/client_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Client? _client;
  Uint8List? _previewImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClientProfile();
  }

  Future<void> _loadClientProfile() async {
    try {
      final clientProvider = Provider.of<ClientProvider>(
        context,
        listen: false,
      );
      final clientId = AuthProvider.clientId!;
      final result = await clientProvider.getById(clientId);

      Uint8List? imageBytes;
      if (result.profilePicture != null && result.profilePicture!.isNotEmpty) {
        try {
          imageBytes = base64Decode(result.profilePicture!);
        } catch (e) {
          showErrorAlert(context, "Error decoding picture: ${e.toString()}");
        }
      }

      setState(() {
        _client = result;
        _previewImage = imageBytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorAlert(context, "Error loading profile: ${e.toString()}");
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
            backgroundImage: _previewImage != null
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
}
