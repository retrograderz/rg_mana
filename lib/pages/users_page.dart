import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<String> getCurrentUserRole() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .get();
      return snapshot.data()?['role'] ?? 'viewer';
    }
    return 'viewer';
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
                    const SizedBox(height: 5,),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
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
      body: FutureBuilder<String>(
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

              return ListView.builder(
                itemCount: users.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final user = users[index].data();
                  final userRole = user['role'] ?? 'viewer';

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
                            if (currentUserRole == 'admin' && userRole != 'admin')
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Điều hướng tới trang chỉnh sửa
                                },
                              ),
                            if (currentUserRole == 'admin' && userRole != 'admin')
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Gọi hàm xóa user
                                  FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(users[index].id)
                                    .delete();
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
    );
  }

}
