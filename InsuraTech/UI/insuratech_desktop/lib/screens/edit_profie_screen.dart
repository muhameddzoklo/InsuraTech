import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/user.dart';
import 'package:insuratech_desktop/providers/auth_provider.dart';
import 'package:insuratech_desktop/providers/users_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:insuratech_desktop/screens/my_profile_screen.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({super.key, required this.user});

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
    _firstName = widget.user.firstName ?? "";
    _lastName = widget.user.lastName ?? "";
    _phone = widget.user.phoneNumber ?? "";

    if (widget.user.profilePicture != null &&
        widget.user.profilePicture!.isNotEmpty) {
      try {
        _imageBytes = base64Decode(widget.user.profilePicture!);
      } catch (_) {}
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
      title: "Edit Profile",
      showBackButton: true,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: const Color(0xFFEFEBE9),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                  : const AssetImage(
                                        'assets/images/placeholder.png',
                                      )
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
                        decoration: const InputDecoration(
                          labelText: "First Name",
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                        onSaved: (value) => _firstName = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _lastName,
                        decoration: const InputDecoration(
                          labelText: "Last Name",
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Required'
                                    : null,
                        onSaved: (value) => _lastName = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: _phone,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter phone number';
                          if (!RegExp(r'^\d{9,10}$').hasMatch(value)) {
                            return 'Enter 9-10 digits';
                          }
                          return null;
                        },
                        onSaved: (value) => _phone = value!,
                      ),
                      const SizedBox(height: 24),
                      SwitchListTile(
                        title: const Text("Change Password"),
                        value: _changePassword,
                        onChanged:
                            (value) => setState(() => _changePassword = value),
                      ),
                      if (_changePassword) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Current Password",
                          ),
                          validator:
                              (value) =>
                                  _changePassword &&
                                          (value == null || value.isEmpty)
                                      ? 'Required'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "New Password",
                          ),
                          validator: (value) {
                            if (_changePassword &&
                                (value == null || value.isEmpty)) {
                              return 'Required';
                            }
                            if (_changePassword && value!.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            if (value == _currentPasswordController.text) {
                              return 'Must differ from current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Confirm Password",
                          ),
                          validator: (value) {
                            if (_changePassword &&
                                (value == null || value.isEmpty)) {
                              return 'Required';
                            }
                            if (_changePassword && value!.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
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
                          backgroundColor: Colors.green.shade800,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _saveChanges,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final request = {
      "firstName": _firstName,
      "lastName": _lastName,
      "phoneNumber": _phone,
      "edit": true,
      "isActive": true,
    };

    if (_imageBytes != null) {
      request["profilePicture"] = base64Encode(_imageBytes!);
    }

    if (_changePassword) {
      request["currentPassword"] = _currentPasswordController.text.trim();
      request["password"] = _newPasswordController.text.trim();
      request["passwordConfirmation"] = _confirmPasswordController.text.trim();
    }

    try {
      final provider = Provider.of<UsersProvider>(context, listen: false);
      await provider.update(widget.user.userId!, request);

      if (_changePassword) {
        AuthProvider.userId = null;
        AuthProvider.username = null;
        AuthProvider.password = null;
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        showSuccessAlert(context, "Password changed. Please log in again.");
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MyProfileScreen()),
        );
        showSuccessAlert(context, "Profile updated successfully");
      }
    } catch (e) {
      showErrorAlert(context, "Invalid current password");
    }
  }
}
