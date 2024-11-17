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

  // Future<void> signInWithEmailAndPassword() async {
  //   showDialog(context: context, builder:
  //   (context) => const Center(
  //     child: CircularProgressIndicator(),
  //    ),
  //   );
  //
  //   try {
  //     await Auth().signInWithEmailAndPassword(
  //       email: _controllerEmail.text,
  //       password: _controllerPassword.text,
  //     );
  //     if (context.mounted) Navigator.pop(context);
  //
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.pop(context);
  //     setState( () {
  //       errorMessage = e.message;
  //     });
  //   }
  // }

  Future<void> signInWithEmailAndPassword() async {
    // Hiển thị hộp thoại loading
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Đăng nhập và nhận UserCredential từ Firebase Authentication
      final userCredential = await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );

      // Truy xuất thông tin user từ UserCredential
      final user = userCredential.user;
      if (user != null) {
        // Kiểm tra xem người dùng có tồn tại trong Firestore không
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)  // Sử dụng email làm id tài liệu
            .get();

        // Nếu tài khoản không tồn tại trong Firestore, chặn đăng nhập
        if (!userDoc.exists) {
          await FirebaseAuth.instance.signOut(); // Đăng xuất người dùng

          // Đóng loading dialog
          Navigator.pop(context);

          // Hiển thị thông báo popup
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                "Account Deleted",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              content: const Text(
                "This account has been eliminated.",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng popup
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
          );

          return; // Kết thúc hàm nếu tài khoản không tồn tại
        }

        // Nếu tài khoản tồn tại trong Firestore, tiếp tục xử lý
        if (context.mounted) Navigator.pop(context);

        // Chuyển hướng người dùng (nếu cần)
        // ...
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Đóng loading dialog khi gặp lỗi
      setState(() {
        errorMessage = e.message ?? "An error occurred.";
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