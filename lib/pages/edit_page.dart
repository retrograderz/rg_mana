import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final Map<String, dynamic> userData; // Data passed from ProfilePage

  const EditPage({super.key, required this.userData});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _usernameController;
  late TextEditingController _studentIDController;
  late TextEditingController _roleController;
  late TextEditingController _gcredsController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current data
    _fullnameController = TextEditingController(text: widget.userData['fullname']);
    _usernameController = TextEditingController(text: widget.userData['username']);
    _studentIDController = TextEditingController(text: widget.userData['studentID']);
    _roleController = TextEditingController(text: widget.userData['role']);
    _gcredsController = TextEditingController(text: widget.userData['Gcreds'].toString());
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _studentIDController.dispose();
    _roleController.dispose();
    _gcredsController.dispose();
    super.dispose();
  }

  // Save updates to Firestore
  Future<void> _updateProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.email) // Use user email as document ID
          .update({
        'fullname': _fullnameController.text,
        'username': _usernameController.text,
        'studentID': _studentIDController.text,
        'role': _roleController.text,
        'Gcreds': int.parse(_gcredsController.text),
      });

      // After saving, show a success message and go back to the profile page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context); // Go back to the profile page
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Fullname field
                TextFormField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                // Username field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                // Student ID field
                TextFormField(
                  controller: _studentIDController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your student ID';
                    }
                    return null;
                  },
                ),
                // Role field
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your role';
                    }
                    return null;
                  },
                ),
                // Gcreds field
                TextFormField(
                  controller: _gcredsController,
                  decoration: const InputDecoration(labelText: 'Gcreds'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Gcreds';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Save button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _updateProfile();
                    }
                  },
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 20),
                // Cancel button to go back
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Go back without saving
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
