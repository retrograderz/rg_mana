import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rg_mana/components/custom_button.dart';
import 'package:rg_mana/components/my_textfield.dart';
import 'package:rg_mana/pages/register_page.dart';

import '../auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = ' ';
  bool isLogin = true;

  // text editing controllers
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    showDialog(context: context, builder:
    (context) => const Center(
      child: CircularProgressIndicator(),
     ),
    );

    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (context.mounted) Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      setState( () {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      UserCredential? userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _controllerEmail.text, password: _controllerPassword.text);

      createUserDocument(userCredential);

    } on FirebaseAuthException catch (e) {
      setState( () {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.email).set({
        'email' : userCredential.user!.email,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
        
                // logo
                const Icon(
                  Icons.adb_rounded,
                  size: 150,
                  color: Colors.greenAccent,
                ),
        
                const SizedBox(height: 25),
        
                // welcome back,
                Text(
                  'Welcome back to GDGo!',
                  style: TextStyle(
                    fontFamily: 'Inter_24pt',
                    color: Colors.grey[200],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        
                const SizedBox(height: 50),
        
                // email textfield
                MyTextField(
                  controller: _controllerEmail,
                  hintText: 'Email',
                  obscureText: false,
                ),
        
                const SizedBox(height: 10),
        
                // password textfield
                MyTextField(
                  controller: _controllerPassword,
                  hintText: 'Password',
                  obscureText: true,
                ),
        
                const SizedBox(height: 10),
        
                // forgot password?
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         'Forgot Password?',
                //         style: TextStyle(color: Colors.grey[600]),
                //       ),
                //     ],
                //   ),
                // ),
        
                const SizedBox(height: 20),
        
                // sign in button
                CustomButton(
                  text: 'Go!',
                  textColor: Colors.black,
                  onTap: signInWithEmailAndPassword,
                  color: Colors.greenAccent,
                ),
        
                const SizedBox(height: 25),
        
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[200], fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(), // Replace with your register page
                          ),
                        );
                      },
                      child: const Text(
                        'Register Now',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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