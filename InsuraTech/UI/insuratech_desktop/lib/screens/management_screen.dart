import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/role.dart';
import 'package:insuratech_desktop/providers/roles_provider.dart';
import 'package:insuratech_desktop/providers/utils.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});
  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final RolesProvider _provider = RolesProvider();
  List<Role> _roles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() => _isLoading = true);
    try {
      final result = await _provider.get();
      setState(() {
        _roles = result.resultList;
        _isLoading = false;
      });
    } catch (e) {
      showErrorAlert(context, "Error loading roles: ${e.toString()}");
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _showRoleDialog({Role? role}) async {
    final isEdit = role != null;
    final _formKey = GlobalKey<FormState>();
    final _descriptionController = TextEditingController(
      text: role?.description ?? '',
    );
    final _roleNameController = TextEditingController(
      text: role?.roleName ?? '',
    );

    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isEdit ? "Edit Role" : "Add Role"),
            content: SizedBox(
              width: 350,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _roleNameController,
                      decoration: const InputDecoration(labelText: "Role Name"),
                      enabled: !isEdit,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Role Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Description is required";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  final desc = _descriptionController.text.trim();
                  final name = _roleNameController.text.trim();

                  if (isEdit) {
                    await _provider.update(role!.roleId!, {
                      "description": desc,
                      "roleName": role.roleName,
                    });
                    Navigator.pop(context, "updated");
                  } else {
                    await _provider.insert({
                      "roleName": name,
                      "description": desc,
                    });
                    Navigator.pop(context, "added");
                  }
                },
                child: Text(isEdit ? "Save" : "Add"),
              ),
            ],
          ),
    );
    _descriptionController.dispose();
    _roleNameController.dispose();
    return result;
  }

  Future<void> _deleteRole(Role role) async {
    final confirm = await showCustomConfirmDialog(
      context,
      title: "Are you sure you want to delete this role?",
      text:
          "This action will hide it from management screens, but it won't affect users currently assigned to it.",
      confirmBtnColor: Colors.red,
    );
    if (confirm == true) {
      try {
        await _provider.delete(role.roleId!);
        _loadRoles();
        showSuccessAlert(context, "Role deleted successfully!");
      } catch (e) {
        showErrorAlert(context, "Failed to delete role: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Management",
      child: Container(
        padding: const EdgeInsets.all(24),
        color: const Color(0xFFF4F1EE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade200,
                    foregroundColor: Colors.brown.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  label: const Text("Add New Role"),
                  onPressed: () async {
                    final result = await _showRoleDialog();
                    if (result == "added") {
                      showSuccessAlert(context, "Role added successfully!");
                      _loadRoles();
                    }
                  },
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    "List of roles in the system",
                    style: TextStyle(
                      color: Colors.brown.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.shade100.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Role Name")),
                            DataColumn(label: Text("Description")),
                            DataColumn(label: Text("Actions")),
                          ],
                          rows:
                              _roles.map((r) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(r.roleName ?? "-")),
                                    DataCell(Text(r.description ?? "-")),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () async {
                                              final result =
                                                  await _showRoleDialog(
                                                    role: r,
                                                  );
                                              if (result == "updated") {
                                                showSuccessAlert(
                                                  context,
                                                  "Role updated successfully!",
                                                );
                                                _loadRoles();
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () => _deleteRole(r),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
