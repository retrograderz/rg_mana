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

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetail() async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .get();
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton() => ElevatedButton(
    onPressed: signOut,
    child: const Text('Sign out'),
  );

  Widget _editProfile(Map<String, dynamic> userData) => ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditPage(userData: userData)),
      );
    },
    child: const Text('Edit Profile',
        style: TextStyle(color: Colors.blue)),
  );

  Widget _avatarSection(Map<String, dynamic> userData) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: userData['avatar'] != null
          ? NetworkImage(userData['avatar'])
          : const AssetImage('assets/default_avatar.png') as ImageProvider,
    );
  }

  Widget _roleCard(String role) => Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.blueGrey[800],
    child: Container(
      padding: const EdgeInsets.all(12.0),
      width: 140,
      child: Column(
        children: [
          const Icon(Icons.shield, color: Colors.amber, size: 30),
          const SizedBox(height: 8),
          const Text(
            'Role',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            role,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amberAccent,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _gcredsCard(int gcreds) => Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.green[800],
    child: Container(
      padding: const EdgeInsets.all(12.0),
      width: 140,
      child: Column(
        children: [
          const Icon(Icons.monetization_on,
              color: Colors.yellow, size: 30),
          const SizedBox(height: 8),
          const Text(
            'Gcreds',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$gcreds',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.lightGreenAccent,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _statCardWithIcon({
    required IconData icon,
    required String label,
    required String value,
    required Color? color,
  })
   => Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color, // Dynamic card color
      child: Container(
        width: 140, // Matches avatar's diameter
        height: 60, // Slightly taller for more visual balance
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.amber, size: 30),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  Widget _userInfoSection(Map<String, dynamic> userData) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.blueAccent.shade400, width: 2), // Blue border
      ),
      color: Colors.black.withOpacity(0.8), // Dark background for a game feel
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: 320,  // Make sure this width matches the width of the row above
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade600], // Dark blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 10),
                Text(
                  'Username:',
                  style: TextStyle(
                    color: Colors.blueAccent.shade100, // Light blue text
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              userData['username'] ?? 'No Username',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(color: Colors.blueAccent, thickness: 1),
            Row(
              children: [
                const Icon(Icons.badge, color: Colors.blueAccent, size: 28),
                const SizedBox(width: 10),

                Text(
                  'Student ID:',
                  style: TextStyle(
                    color: Colors.blueAccent.shade100, // Light blue text
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              userData['studentID'] ?? 'Not provided',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1B24),
      // appBar: AppBar(
      //   title: const Text('Profile'),
      //   backgroundColor: Colors.deepPurple,
      // ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            Map<String, dynamic>? userData = snapshot.data!.data();

            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Avatar and Stats Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Enlarged Avatar
                          CircleAvatar(
                            radius: 70, // Increased size of avatar
                            backgroundImage: userData!['avatar'] != null
                                ? NetworkImage(userData['avatar'])
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          const SizedBox(width: 30),
                          // Stats Cards
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _statCardWithIcon(
                                icon: Icons.rocket_launch_rounded,
                                label: 'Role',
                                value: userData['role'] ?? 'Not assigned',
                                color: Colors.blueGrey[800],
                              ),
                              const SizedBox(height: 10),
                              _statCardWithIcon(
                                icon: Icons.star_rounded,
                                label: 'Gcreds',
                                value: '${userData['Gcreds'] ?? 0}',
                                color: Colors.green[800],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // User Info Section
                      _userInfoSection(userData),
                    ],
                  ),
                ),
                // Buttons at the Bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _editProfile(userData),
                      const SizedBox(width: 20),
                      _signOutButton(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("No data"));
          }
        },
      ),
    );
  }
}