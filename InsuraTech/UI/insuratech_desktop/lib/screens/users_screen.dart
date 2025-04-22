import 'package:flutter/material.dart';
import 'package:insuratech_desktop/layouts/master_screen.dart';
import 'package:insuratech_desktop/models/user.dart';
import 'package:insuratech_desktop/models/client.dart';
import 'package:insuratech_desktop/models/role.dart';
import 'package:insuratech_desktop/providers/users_provider.dart';
import 'package:insuratech_desktop/providers/clients_provider.dart';
import 'package:insuratech_desktop/providers/roles_provider.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool showEmployees = true;
  String searchQuery = '';
  bool isLoading = false;
  List<User> employees = [];
  List<Client> clients = [];
  List<Role> roles = [];
  bool clientsLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadEmployees();
      await _loadRoles();
    });
  }

  Future<void> _loadRoles() async {
    try {
      final result = await Provider.of<RolesProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);
      if (mounted) setState(() => roles = result.resultList);
    } on Exception catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Failed',
          text: 'Error: ${e.toString()}',
        );
      }
    }
  }

  void _showAddEmployeeDialog() {
    final _formKey = GlobalKey<FormState>();
    String firstName = '';
    String lastName = '';
    String email = '';
    String phoneNumber = '';
    String username = '';
    int? roleId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Employee"),
          content: SizedBox(
            width: 400, // Fiksna širina
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter first name'
                                  : null,
                      onSaved: (value) => firstName = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter last name'
                                  : null,
                      onSaved: (value) => lastName = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator:
                          (value) =>
                              value == null || !value.contains('@')
                                  ? 'Enter valid email (example@example.com)'
                                  : null,
                      onSaved: (value) => email = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter phone number';
                        }
                        final regex = RegExp(r'^\d{9}$');
                        if (!regex.hasMatch(value)) {
                          return 'Enter exactly 9 digits';
                        }
                        return null;
                      },
                      onSaved: (value) => phoneNumber = value!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Enter username'
                                  : null,
                      onSaved: (value) => username = value!,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: 'Role'),
                      items:
                          roles.map((role) {
                            return DropdownMenuItem<int>(
                              value: role.roleId,
                              child: Text(role.roleName ?? "N/A"),
                            );
                          }).toList(),
                      onChanged: (value) => roleId = value,
                      validator:
                          (value) => value == null ? 'Select a role' : null,
                    ),
                  ],
                ),
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
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email,
                    "phoneNumber": phoneNumber,
                    "username": username,
                    "roleId": roleId,
                  };

                  try {
                    await Provider.of<UsersProvider>(
                      context,
                      listen: false,
                    ).insert(request);
                    Navigator.pop(context);
                    _loadEmployees();
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'Success',
                      text: 'Employee Added successfully',
                    );
                  } on Exception catch (e) {
                    if (mounted) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Failed',
                        text: 'Error: ${e.toString()}',
                      );
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
  void _showUpdateUserDialog(User user) {
  final _formKey = GlobalKey<FormState>();
  String firstName = user.firstName ?? '';
  String lastName = user.lastName ?? '';
  String phoneNumber = user.phoneNumber ?? '';
  bool isActive = user.isActive ?? true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text("Update Employee"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 400, 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: firstName,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter first name' : null,
                      onSaved: (value) => firstName = value!,
                    ),
                    TextFormField(
                      initialValue: lastName,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter last name' : null,
                      onSaved: (value) => lastName = value!,
                    ),
                    TextFormField(
                      initialValue: phoneNumber,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter phone number' : null,
                      onSaved: (value) => phoneNumber = value!,
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title:  Text(isActive?"Active":"Inactive"),
                      value: isActive,
                      onChanged: (value) {
                        setModalState(() {
                          isActive = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
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
                    "firstName": firstName,
                    "lastName": lastName,
                    "phoneNumber": phoneNumber,
                    "isActive": isActive,
                  };

                  try {
                    await Provider.of<UsersProvider>(
                      context,
                      listen: false,
                    ).update(user.userId!, request);
                    Navigator.pop(context);
                    _loadEmployees();
                  QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'Success',
                      text: 'Employee Updated successfully',
                    );
                  } on Exception catch (e) {
                      if (mounted) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Failed',
                          text: 'Error: ${e.toString()}',
                        );
                      }
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

void _showUpdateClientDialog(Client client) {
  final _formKey = GlobalKey<FormState>();
  String firstName = client.firstName ?? '';
  String lastName = client.lastName ?? '';
  String phoneNumber = client.phoneNumber ?? '';
  bool isActive = client.isActive ?? true;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text("Update Client"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: firstName,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter first name' : null,
                      onSaved: (value) => firstName = value!,
                    ),
                    TextFormField(
                      initialValue: lastName,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter last name' : null,
                      onSaved: (value) => lastName = value!,
                    ),
                    TextFormField(
                      initialValue: phoneNumber,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter phone number' : null,
                      onSaved: (value) => phoneNumber = value!,
                    ),
                    const SizedBox(height: 10),
                    SwitchListTile(
                      title:  Text(isActive?"Active":"Inactive"),
                      value: isActive,
                      onChanged: (value) {
                        setModalState(() {
                          isActive = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
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
                    "firstName": firstName,
                    "lastName": lastName,
                    "phoneNumber": phoneNumber,
                    "isActive": isActive,
                  };
                  try {
                    await Provider.of<ClientsProvider>(
                      context,
                      listen: false,
                    ).update(client.clientId!, request);
                    Navigator.pop(context);
                    _loadClients();
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.success,
                      title: 'Success',
                      text: 'Client Updated successfully',
                    );
                  } on Exception catch (e) {
                      if (mounted) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: 'Failed',
                          text: 'Error: ${e.toString()}',
                        );
                      }
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


  Future<void> _loadEmployees() async {
    setState(() => isLoading = true);
    try {
      final result = await Provider.of<UsersProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);
      if (mounted) {
        setState(() => employees = result.resultList);
      }
    } on Exception catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Failed',
          text: 'Error: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadClients() async {
    setState(() => isLoading = true);
    try {
      final result = await Provider.of<ClientsProvider>(
        context,
        listen: false,
      ).get(retrieveAll: true);
      if (mounted) {
        setState(() {
          clients = result.resultList;
          clientsLoaded = true;
        });
      }
    } on Exception catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Failed',
          text: 'Error: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEmployees =
        employees
            .where(
              (u) =>
                  u.username != null &&
                  u.username!.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    final filteredClients =
        clients
            .where(
              (u) =>
                  u.username != null &&
                  u.username!.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();

    return MasterScreen(
      title: "Users",
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search users...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged:
                              (value) => setState(() => searchQuery = value),
                        ),
                      ),
                      const SizedBox(width: 20),
                      if (showEmployees)
                        ElevatedButton.icon(
                          onPressed: _showAddEmployeeDialog,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Employee"),
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      FilterChip(
                        label: const Text("Employees"),
                        selected: showEmployees,
                        onSelected:
                            (val) => setState(() => showEmployees = true),
                      ),
                      const SizedBox(width: 10),
                      FilterChip(
                        label: const Text("Clients"),
                        selected: !showEmployees,
                        onSelected: (val) {
                          setState(() => showEmployees = false);
                          if (!clientsLoaded) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _loadClients();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: DataTable(
                        columnSpacing: 40,
                        columns: const [
                          DataColumn(label: Text("Username")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows:
                            showEmployees
                                ? filteredEmployees.map((user) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(user.username ?? 'N/A')),
                                      DataCell(
                                        Text(
                                          (user.isActive ?? false)
                                              ? "Active"
                                              : "Inactive",
                                          style: TextStyle(
                                            color:
                                                (user.isActive ?? false)
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed: ()=>_showUpdateUserDialog(user),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text("Are you sure?"),
                                                    content: const Text("Do you want to delete this client?"),
                                                    actionsAlignment: MainAxisAlignment.center,
                                                    actions: [
                                                      SizedBox(
                                                        width: 100,
                                                        height: 30,
                                                        child: TextButton(
                                                          onPressed: () => Navigator.of(context).pop(),
                                                          style: TextButton.styleFrom(
                                                            backgroundColor: Colors.red,
                                                            foregroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                            ),
                                                            minimumSize: const Size.fromHeight(40),
                                                          ),
                                                          child: const Text("No"),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      SizedBox(
                                                        width: 100,
                                                        height: 30,
                                                        child: ElevatedButton.icon(
                                                          onPressed: () async {
                                                            Navigator.of(context).pop();
                                                            try {
                                                              await Provider.of<UsersProvider>(
                                                                context,
                                                                listen: false,
                                                              ).delete(user.userId!);
                                                               _loadEmployees();
                                                              QuickAlert.show(
                                                                context: context,
                                                                type: QuickAlertType.success,
                                                                title: 'Success',
                                                                text: 'Employee deleted successfully',
                                                              );
                                                            }on Exception catch (e) {
                                                              QuickAlert.show(
                                                                context: context,
                                                                type: QuickAlertType.error,
                                                                title: 'Failed',
                                                                text: 'Error: ${e.toString()}',
                                                              );
                                                           }
                                                          },
                                                          icon: const Icon(Icons.check, size: 18),
                                                          label: const Text("Yes"),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: const Color.fromARGB(255, 36, 131, 7),
                                                            foregroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            ),
                                                            minimumSize: const Size.fromHeight(40),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList()
                                : filteredClients.map((client) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(client.username ?? 'N/A')),
                                      DataCell(
                                        Text(
                                          (client.isActive ?? false)
                                              ? "Active"
                                              : "Inactive",
                                          style: TextStyle(
                                            color:
                                                (client.isActive ?? false)
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.blue,
                                              ),
                                              onPressed:()=> _showUpdateClientDialog(client),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text("Are you sure?"),
                                                    content: const Text("Do you want to delete this client?"),
                                                    actionsAlignment: MainAxisAlignment.center,
                                                    actions: [
                                                      SizedBox(
                                                        width: 100,
                                                        height: 30,
                                                        child: TextButton(
                                                          onPressed: () => Navigator.of(context).pop(),
                                                          style: TextButton.styleFrom(
                                                            backgroundColor: Colors.red,
                                                            foregroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(15),
                                                            ),
                                                            minimumSize: const Size.fromHeight(40),
                                                          ),
                                                          child: const Text("No"),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      SizedBox(
                                                        width: 100,
                                                        height: 30,
                                                        child: ElevatedButton.icon(
                                                          onPressed: () async {
                                                            Navigator.of(context).pop();
                                                            try {
                                                              await Provider.of<ClientsProvider>(
                                                                context,
                                                                listen: false,
                                                              ).delete(client.clientId!);
                                                              
                                                               _loadClients();
                                                              QuickAlert.show(
                                                                context: context,
                                                                type: QuickAlertType.success,
                                                                title: 'Success',
                                                                text: 'Client deleted successfully',
                                                              );
                                                            }on Exception catch (e) {
                                                              QuickAlert.show(
                                                                context: context,
                                                                type: QuickAlertType.error,
                                                                title: 'Failed',
                                                                text: 'Error: ${e.toString()}',
                                                              );
                                                          }
                                                          },
                                                          icon: const Icon(Icons.check, size: 18),
                                                          label: const Text("Yes"),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: const Color.fromARGB(255, 36, 131, 7),
                                                            foregroundColor: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(15),
                                                            ),
                                                            minimumSize: const Size.fromHeight(40),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
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
                ],
              ),
    );
  }
}
