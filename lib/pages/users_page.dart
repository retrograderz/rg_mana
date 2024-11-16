import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/user_role.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Widget _title() => const Text(
    'Users',
    style: TextStyle(
      color: Colors.white,
      fontFamily: 'Inter_24pt',
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
  );

  Future<UserRole> getCurrentUserRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .get();
      String role = snapshot.data()?['role'] ?? 'viewer';
      return _mapStringToRole(role);
    }
    return UserRole.viewer;
  }

  UserRole _mapStringToRole(String role) {
    switch (role) {
      case 'PRES':
        return UserRole.admin;
      case 'HEAD':
        return UserRole.editor;
      case 'Member':
      default:
        return UserRole.viewer;
    }
  }

  void _showEditUserDialog(BuildContext context, Map<String, dynamic> user, String userId) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController fullnameController = TextEditingController(text: user['fullname']);
    TextEditingController emailController = TextEditingController(text: user['email']);
    TextEditingController roleController = TextEditingController(text: user['role'] ?? 'viewer');
    TextEditingController gcredsController = TextEditingController(text: user['Gcreds']?.toString() ?? '');

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: fullnameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the full name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: roleController,
                    decoration: const InputDecoration(labelText: 'Role'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the role';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: gcredsController,
                    decoration: const InputDecoration(labelText: 'Gcreds'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the Gcreds value';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Convert Gcreds to an integer before updating
                  int gcreds = int.parse(gcredsController.text);

                  // Update the user's data in Firestore
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .update({
                    'fullname': fullnameController.text,
                    'email': emailController.text,
                    'role': roleController.text,
                    'Gcreds': gcreds,
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User updated successfully')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Alert
  Future<void> _showDeleteConfirmationDialog(BuildContext context, String userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ACTION CONFIRM', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),),
          content: const Text('Eliminate this user?', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Delete user
                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User deleted')),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  void _showUserDetails(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    user['username'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user['email'],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user['fullname'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    "HSID: ${user['studentID']}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Role: ${user['role']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 5,),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close', style: TextStyle(color: Colors.red),),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController fullnameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController IDController = TextEditingController();
    TextEditingController usernameController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Member'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: fullnameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the full name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: IDController,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter student ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final FirebaseAuth auth = FirebaseAuth.instance;
                  final currentUser = auth.currentUser; // Preserve PRES account

                  try {
                    // Create the new user account
                    await auth.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Add the user details to Firestore
                    await FirebaseFirestore.instance.collection('Users').doc(emailController.text).set({
                      'fullname': fullnameController.text,
                      'email': emailController.text,
                      'studentID': IDController.text,
                      'username': usernameController.text,
                      'role': 'newuser',
                      'Gcreds': int.parse('0'),
                    });

                    // Re-login to PRES account
                    if (currentUser != null) {
                      await auth.signOut();
                      // await auth.signInWithEmailAndPassword(
                      //   email: currentUser.email!,
                      //   password: '123456', // Replace with your PRES password
                      // );
                    }

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Member added successfully')),
                    );
                  }
                  on FirebaseAuthException catch (e) {
                    String errorMessage;
                    if (e.code == 'email-already-in-use') {
                      errorMessage = 'The email is already in use by another account.';
                    } else if (e.code == 'invalid-email') {
                      errorMessage = 'The email address is not valid.';
                    }
                    // else if (e.code == 'weak-password') {
                    //   errorMessage = 'The password is too weak.';
                    // }
                    else {
                      errorMessage = 'An error occurred: ${e.message}';
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _title(),
        elevation: 0,
        centerTitle: true,
      ),
      body:
      FutureBuilder<UserRole>(
        future: getCurrentUserRole(),
        builder: (context, roleSnapshot) {
          if (!roleSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentUserRole = roleSnapshot.data!;

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null) return const Text("No data");

              final users = snapshot.data!.docs;

              return
                ListView.builder(
                    itemCount: users.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final user = users[index].data();
                      final userRole = _mapStringToRole(user['role'] ?? 'viewer');
                      final userId = users[index].id;

                      return GestureDetector(
                        onTap: () => _showUserDetails(context, user),
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey.shade400,
                                  child: Text(
                                    user['username'][0].toUpperCase(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['fullname'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user['email'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (currentUserRole == UserRole.admin && userRole != UserRole.admin)
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditUserDialog(context, user, userId);
                                    },
                                  ),
                                if (currentUserRole == UserRole.admin && userRole != UserRole.admin)
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(context, userId);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<UserRole>(
        future: getCurrentUserRole(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == UserRole.admin) {
            return FloatingActionButton(
              onPressed: () => _showAddMemberDialog(context),
              backgroundColor: Colors.black,
              child: const Icon(
                  Icons.add,
                  color: Colors.white,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
