import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/insurance_package.dart';
import 'package:insuratech_desktop/providers/insurance_package_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class InsurancePackageScreen extends StatefulWidget {
  const InsurancePackageScreen({super.key});

  @override
  State<InsurancePackageScreen> createState() => _InsurancePackageScreenState();
}

class _InsurancePackageScreenState extends State<InsurancePackageScreen> {
  List<InsurancePackage> _packages = [];
  List<InsurancePackage> _filteredPackages = [];
  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPackages();
    _searchController.addListener(_filterPackages);
  }

  Future<void> _fetchPackages() async {
    setState(() => _isLoading = true);
    try {
      var packagesResult = await Provider.of<InsurancePackageProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);

      setState(() {
        _packages = packagesResult.resultList;
        _filteredPackages = _packages;
      });
    } catch (e) {
      showErrorAlert(context, "Failed fetching packages  ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showUpdatePackageDialog(InsurancePackage package) {
    final _formKey = GlobalKey<FormState>();
    String name = package.name ?? '';
    String description = package.description ?? '';
    double price = package.price ?? 0;
    String picture = package.picture ?? '';
    int durationDays = package.durationDays ?? 0;
    Uint8List? previewImage = picture.isNotEmpty ? base64Decode(picture) : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setModalState) => AlertDialog(
                title: const Text("Update Insurance Package"),
                content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              initialValue: name,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Enter name'
                                          : null,
                              onSaved: (value) => name = value!,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              initialValue: price.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Price',
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value == null ||
                                              double.tryParse(value) == null
                                          ? 'Enter valid price'
                                          : null,
                              onSaved: (value) => price = double.parse(value!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              initialValue: durationDays.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Duration days',
                              ),
                              keyboardType: TextInputType.number,
                              validator:
                                  (value) =>
                                      value == null ||
                                              int.tryParse(value) == null
                                          ? 'Enter valid number'
                                          : null,
                              onSaved:
                                  (value) => durationDays = int.parse(value!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 300,
                            child: TextFormField(
                              initialValue: description,
                              maxLines: 4,
                              minLines: 3,
                              decoration: const InputDecoration(
                                hintText: 'Description',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (value) =>
                                      value == null || value.isEmpty
                                          ? 'Enter description'
                                          : null,
                              onSaved: (value) => description = value!,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 300,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                var result = await FilePicker.platform
                                    .pickFiles(type: FileType.image);
                                if (result != null &&
                                    result.files.single.path != null) {
                                  final imageFile = File(
                                    result.files.single.path!,
                                  );
                                  final bytes = await imageFile.readAsBytes();
                                  picture = base64Encode(bytes);
                                  setModalState(() {
                                    previewImage = bytes;
                                  });
                                }
                              },
                              icon: const Icon(Icons.image),
                              label: const Text("Pick Image"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (previewImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              previewImage!,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: const Text("Update"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final request = {
                          "name": name,
                          "description": description,
                          "price": price,
                          "picture": picture,
                          "durationDays": durationDays,
                        };
                        try {
                          await Provider.of<InsurancePackageProvider>(
                            context,
                            listen: false,
                          ).update(package.insurancePackageId!, request);
                          Navigator.pop(context);
                          _fetchPackages();
                          showSuccessAlert(
                            context,
                            "Package Edited successfully",
                          );
                        } catch (e) {
                          showErrorAlert(
                            context,
                            "Error updating package ${e.toString()} ",
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
        );
      },
    );
  }

  void _filterPackages() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPackages =
          _packages
              .where((package) => package.name!.toLowerCase().contains(query))
              .toList();
    });
  }

  void _showAddPackageDialog() {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    double price = 0;
    String picture = '';
    int durationDays = 0;

    showDialog(
      context: context,
      builder: (context) {
        Uint8List? previewImage;

        return StatefulBuilder(
          builder:
              (context, setModalState) => AlertDialog(
                title: const Text("Add New Insurance Package"),
                content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Name'),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter name'
                                      : null,
                          onSaved: (value) => name = value!,
                        ),

                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator:
                              (value) =>
                                  value == null ||
                                          double.tryParse(value) == null
                                      ? 'Enter valid price'
                                      : null,
                          onSaved: (value) => price = double.parse(value!),
                        ),

                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Duration days',
                          ),
                          keyboardType: TextInputType.number,
                          validator:
                              (value) =>
                                  value == null || int.tryParse(value) == null
                                      ? 'Enter valid number'
                                      : null,
                          onSaved: (value) => durationDays = int.parse(value!),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          maxLines: 4,
                          minLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Enter description'
                                      : null,
                          onSaved: (value) => description = value!,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            var result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null &&
                                result.files.single.path != null) {
                              final imageFile = File(result.files.single.path!);
                              final bytes = await imageFile.readAsBytes();
                              picture = base64Encode(bytes);
                              setModalState(() {
                                previewImage = bytes;
                              });
                            }
                          },
                          icon: const Icon(Icons.image),
                          label: const Text("Pick Image"),
                        ),
                        const SizedBox(height: 10),
                        if (previewImage != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              previewImage!,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ElevatedButton(
                    child: const Text("Add"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final request = {
                          "name": name,
                          "description": description,
                          "price": price,
                          "picture": picture,
                          "durationDays": durationDays,
                        };
                        try {
                          await Provider.of<InsurancePackageProvider>(
                            context,
                            listen: false,
                          ).insert(request);
                          Navigator.pop(context);
                          _fetchPackages();
                          showSuccessAlert(
                            context,
                            "Package Added successfully",
                          );
                        } catch (e) {
                          showErrorAlert(
                            context,
                            "Error creating package ${e.toString()} ",
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Insurance Packages",
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search packages...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Package"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D6E63),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 18,
                  ),
                ),
                onPressed: _showAddPackageDialog,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 500,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _filteredPackages.length,
                  itemBuilder: (context, index) {
                    final package = _filteredPackages[index];
                    return InsurancePackageCard(
                      package: package,
                      onRefresh: _fetchPackages,
                      onUpdate: () => _showUpdatePackageDialog(package),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}

class InsurancePackageCard extends StatelessWidget {
  final InsurancePackage package;
  final VoidCallback onRefresh;
  final VoidCallback onUpdate;

  const InsurancePackageCard({
    super.key,
    required this.package,
    required this.onRefresh,
    required this.onUpdate,
  });

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(label, style: const TextStyle(fontSize: 13)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String state = package.stateMachine?.toLowerCase() ?? '';
    final bool isHidden = state == 'hidden';
    final bool isActive = state == 'active';
    final bool isDraft = state == 'draft';

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name ?? 'N/A',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package.description ?? 'No description',
                    style: TextStyle(color: Colors.grey[700]),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Duration: ${package.durationDays?.toString() ?? ''} days",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (isActive)
                    Text(
                      "${package.price?.toStringAsFixed(2) ?? ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                  if (isDraft) ...[
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            await Provider.of<InsurancePackageProvider>(
                              context,
                              listen: false,
                            ).ChangeState(
                              package.insurancePackageId!,
                              "activate",
                            );
                            onRefresh();
                            showSuccessAlert(
                              context,
                              "Package activated successfully",
                            );
                          } catch (e) {
                            showErrorAlert(
                              context,
                              "Error activating: ${e.toString()}",
                            );
                          }
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Activate"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          backgroundColor: const Color.fromARGB(
                            255,
                            36,
                            131,
                            7,
                          ),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Rastegljivi prostor
                  Expanded(child: Container()),

                  // Bottom dugmad
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!isHidden)
                        _buildActionButton(
                          icon: Icons.visibility_off,
                          label: "Hide",
                          color: Colors.grey,
                          onPressed: () async {
                            final result = await showCustomConfirmDialog(
                              context,
                              title: "Hide package",
                              text: "Do you want to hide this package?",
                            );
                            if (result == true) {
                              try {
                                await Provider.of<InsurancePackageProvider>(
                                  context,
                                  listen: false,
                                ).ChangeState(
                                  package.insurancePackageId!,
                                  "hide",
                                );
                                onRefresh();
                              } catch (e) {
                                showErrorAlert(
                                  context,
                                  "Error hiding: ${e.toString()}",
                                );
                              }
                            }
                          },
                        ),
                      if (isDraft)
                        _buildActionButton(
                          icon: Icons.edit,
                          label: "Update",
                          color: Colors.orange,
                          onPressed: onUpdate,
                        ),
                      if (isDraft)
                        _buildActionButton(
                          icon: Icons.delete,
                          label: "Delete",
                          color: Colors.red,
                          onPressed: () async {
                            final result = await showCustomConfirmDialog(
                              context,
                              title: "Delete Package",
                              text:
                                  "Are you sure you want to delete this package?",
                            );
                            if (result == true) {
                              try {
                                await Provider.of<InsurancePackageProvider>(
                                  context,
                                  listen: false,
                                ).delete(package.insurancePackageId!);
                                onRefresh();
                                showSuccessAlert(
                                  context,
                                  "Package deleted successfully",
                                );
                              } catch (e) {
                                showErrorAlert(
                                  context,
                                  "Error deleting: ${e.toString()}",
                                );
                              }
                            }
                          },
                        ),
                      if (!isDraft && !isActive)
                        _buildActionButton(
                          icon: Icons.update,
                          label: "Edit",
                          color: const Color(0xFF8D6E63),
                          onPressed: () async {
                            try {
                              await Provider.of<InsurancePackageProvider>(
                                context,
                                listen: false,
                              ).ChangeState(
                                package.insurancePackageId!,
                                "edit",
                              );
                              onRefresh();
                            } catch (e) {
                              showErrorAlert(
                                context,
                                "Error editing: ${e.toString()}",
                              );
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isHidden)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "INACTIVE",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
