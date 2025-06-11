import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insuratech_mobile/main.dart';
import 'package:insuratech_mobile/providers/client_provider.dart';
import 'package:insuratech_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Uint8List? _imageBytes;
  File? _imageFile;

  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    if (_isPickingImage) return;
    setState(() => _isPickingImage = true);

    try {
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
    } catch (e) {
      showErrorAlert(context, "Error picking image: ${e.toString()}");
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      backgroundColor: const Color(0xFFE4E0C8),
      body: SingleChildScrollView(
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
              _buildTextField(
                _firstNameController,
                "First Name",
                required: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(_lastNameController, "Last Name", required: true),
              const SizedBox(height: 16),
              _buildTextField(
                _emailController,
                "Email",
                required: true,
                email: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _phoneController,
                "Phone (optional)",
                phoneNumber: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(_usernameController, "Username", required: true),
              const SizedBox(height: 16),
              _buildTextField(
                _passwordController,
                "Password",
                required: true,
                obscure: true,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  if (value == null || value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.app_registration),
                label: const Text("Register"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _submitRegistration,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                child: const Text("Already have an account? Login here"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool required = false,
    bool obscure = false,
    bool email = false,
    bool phoneNumber = false,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return "$label is required";
        }
        if (isPassword && value != null && value.length < 8) {
          return "$label must be at least 8 characters";
        }
        if (email && value != null && value.isNotEmpty) {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value)) {
            return "Invalid email format";
          }
        }
        if (phoneNumber && value != null && value.isNotEmpty) {
          final regex = RegExp(r'^\d{9,10}$');
          if (!regex.hasMatch(value)) {
            return "Phone must be 9 or 10 digits";
          }
        }
        return null;
      },
    );
  }

  void _submitRegistration() async {
    if (_formKey.currentState?.validate() != true) return;
    try {
      final clientProvider = Provider.of<ClientProvider>(
        context,
        listen: false,
      );
      final request = {
        "firstName": _firstNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "email": _emailController.text.trim(),
        "phoneNumber": _phoneController.text.trim(),
        "username": _usernameController.text.trim(),
        "password": _passwordController.text.trim(),
        "passwordConfirmation": _confirmPasswordController.text.trim(),
        "profilePicture": _imageBytes != null ? base64Encode(_imageBytes!) : "",
      };

      await clientProvider.register(request);

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      showSuccessAlert(context, "Profile created successfully");
    } catch (e) {
      showErrorAlert(context, "Username or email already exists");
    }
  }
}
