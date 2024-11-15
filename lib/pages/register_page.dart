import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rg_mana/components/my_textfield.dart';
import 'package:rg_mana/components/custom_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerFullname = TextEditingController();
  final TextEditingController _controllerStudentID = TextEditingController();

  String? errorMessage;

  Future<void> createUserWithEmailAndPassword() async {
    try {
      // Firebase Auth: Register User
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      // Firestore: Save User Info
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'email': _controllerEmail.text,
        'username': _controllerUsername.text,
        'fullname' : _controllerFullname.text,
        'studentID' : _controllerStudentID.text,
        'Gcreds' : 0,
        'role' : 'newuser',
      });

      // Navigate to another page after registration
      if (context.mounted) {
        Navigator.pop(context); // Or navigate to the home screen
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),

                // App Logo
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 100,
                ),

                const SizedBox(height: 20),

                // Welcome text
                const Text(
                  'Create Your Account',
                  style: TextStyle(
                    fontFamily: 'Inter_24pt',
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 30),

                // Username textfield
                MyTextField(
                  controller: _controllerUsername,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Fullname textfield
                MyTextField(
                  controller: _controllerFullname,
                  hintText: 'Fullname',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // StudentID textfield
                MyTextField(
                  controller: _controllerStudentID,
                  hintText: 'HUST StudentID (eg: 202417010)',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Email textfield
                MyTextField(
                  controller: _controllerEmail,
                  hintText: 'Email (eg: 24171010@gdg.hust.vn)',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // Password textfield
                MyTextField(
                  controller: _controllerPassword,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 20),

                // Error message (if any)
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // Register button
                CustomButton(
                  text: 'Register',
                  textColor: Colors.black,
                  onTap: createUserWithEmailAndPassword,
                  color: Colors.greenAccent,
                ),


                const SizedBox(height: 25),

                // Already have an account? Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to Login
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
