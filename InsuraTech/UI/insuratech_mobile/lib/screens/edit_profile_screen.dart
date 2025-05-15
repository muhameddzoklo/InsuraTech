import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insuratech_mobile/main.dart';
import 'package:insuratech_mobile/models/client.dart';
import 'package:insuratech_mobile/providers/auth_provider.dart';
import 'package:insuratech_mobile/providers/client_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:insuratech_mobile/screens/my_profile_screen.dart';
import 'package:provider/provider.dart';
import '../layouts/master_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final Client client;
  const EditProfileScreen({super.key, required this.client});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _phone;

  bool _changePassword = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Uint8List? _imageBytes;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _firstName = widget.client.firstName ?? '';
    _lastName = widget.client.lastName ?? '';
    _phone = widget.client.phoneNumber ?? '';

    if (widget.client.profilePicture != null &&
        widget.client.profilePicture!.isNotEmpty) {
      try {
        _imageBytes = base64Decode(widget.client.profilePicture!);
      } catch (e) {
        showErrorAlert(context, "Error deconing picture: ${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _imageFile = File(picked.path);
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      appBarTitle: "Edit Profile",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _imageFile != null
                          ? FileImage(_imageFile!)
                          : _imageBytes != null
                          ? MemoryImage(_imageBytes!)
                          : const AssetImage('assets/images/placeholder.png')
                              as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Icon(Icons.camera_alt, size: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _firstName,
                decoration: const InputDecoration(labelText: "First Name"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _firstName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _lastName,
                decoration: const InputDecoration(labelText: "Last Name"),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _lastName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter phone number';
                  }
                  final regex = RegExp(r'^\d{9,10}$');
                  if (!regex.hasMatch(value)) {
                    return 'Enter exactly 9 or 10 digits';
                  }
                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: const Text("Change Password"),
                value: _changePassword,
                onChanged: (value) {
                  setState(() {
                    _changePassword = value;
                  });
                },
              ),
              if (_changePassword) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                  ),
                  validator: (value) {
                    if (_changePassword && (value == null || value.isEmpty)) {
                      return 'Current password is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "New Password"),
                  validator: (value) {
                    if (_changePassword) {
                      if (value == null || value.isEmpty) {
                        return 'New password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (value == _currentPasswordController.text) {
                        return 'New password must differ from current password';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm New Password",
                  ),
                  validator: (value) {
                    if (_changePassword) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm new password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() != true) return;
    _formKey.currentState?.save();

    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final Map<String, dynamic> request = {
      "firstName": _firstName,
      "lastName": _lastName,
      "phoneNumber": _phone,
      "isActive": true,
    };

    if (_imageBytes != null) {
      final base64Image = base64Encode(_imageBytes!);
      request["profilePicture"] = base64Image;
    }
    if (_changePassword) {
      request["currentPassword"] = currentPassword;
      request["password"] = newPassword;
      request["passwordConfirmation"] = confirmPassword;
    }

    try {
      final clientProvider = Provider.of<ClientProvider>(
        context,
        listen: false,
      );

      await clientProvider.update(widget.client.clientId!, request);
      if (_changePassword) {
        AuthProvider.username = null;
        AuthProvider.password = null;
        AuthProvider.clientId = null;

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
        showSuccessAlert(context, "Password changed. Please log in again");
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => const MasterScreen(
                  appBarTitle: "My Profile",
                  showBackButton: false,
                  child: MyProfileScreen(),
                ),
          ),
        );
        showSuccessAlert(context, "Profile updated successfully");
      }
    } catch (e) {
      showErrorAlert(context, "Invalid current password");
    }
  }
}
