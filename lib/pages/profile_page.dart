import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import 'edit_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Fetch user details from Firestore
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetail() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .get();
  }

  // Sign out method
  Future<void> signOut() async {
    await Auth().signOut();
  }

  // Sign out button
  Widget _signOutButton() => ElevatedButton(
    onPressed: signOut,
    child: const Text('Sign out'),
  );

  // Edit profile button
  Widget _editProfile(Map<String, dynamic> userData) => ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditPage(userData: userData)),
      );
    },
    child: const Text('Edit Profile', style: TextStyle(color: Colors.blue),)
  );

  // Title widget for app bar
  Widget _title() => const Text(
    'Profile',
    style: TextStyle(
      color: Colors.white,
      fontFamily: 'Inter_24pt',
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06D6A0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: _title(),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Details in Card Layout
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: getUserDetail(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  Map<String, dynamic>? userData = snapshot.data!.data();
                  return Center(
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.fromLTRB(25, 40, 25, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: 380,
                        height: 450,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            // Avatar section with name below
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 50, // Avatar size
                                  backgroundImage: userData?['avatar'] != null
                                      ? NetworkImage(userData!['avatar'])
                                      : const AssetImage('assets/default_avatar.png') as ImageProvider,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${userData?['fullname'] ?? 'No name available'}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // User info section
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData!['email'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Username: ${userData['username'] ?? 'No Username'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Student ID: ${userData['studentID'] ?? 'Not provided'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Role: ${userData['role'] ?? 'Not assigned'}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Gcreds: ${userData['Gcreds'] ?? 0}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(child: Text("No data"));
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getUserDetail(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Map<String, dynamic>? userData = snapshot.data!.data();
                      return _editProfile(userData!); // Pass the userData
                    } else {
                      return Container(); // Placeholder while data is loading
                    }
                  },
                ),
                const SizedBox(width: 20,),
                _signOutButton(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
