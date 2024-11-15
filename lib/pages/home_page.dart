import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:rg_mana/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();

  // Function to get the current user's username
  Future<String?> getCurrentUserUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.displayName ?? user.email?.split('@')[0]; // Use displayName or fallback to email
    }
    return null;
  }

  void openNoteBox({String? docID}) async {
    String? currentUser = await getCurrentUserUsername(); // Get current user's username

    if (currentUser == null) {
      // Handle case where user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to create notes.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addNote(textController.text);
              } else {
                firestoreService.updateNote(docID, textController.text);
              }

              textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                // Get each document
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                // Get note data
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String noteText = data['note'] ?? "No note available";
                String createdBy = data['created_by'] ?? 'Unknown';
                Timestamp createdAt = data['created_at'] ?? Timestamp.now();
                DateTime createdTime = createdAt.toDate();
                String formattedTime = '${createdTime.day}/${createdTime.month}/${createdTime.year} ${createdTime.hour}:${createdTime.minute}';

                // Debugging
                print('Created by: $createdBy');
                print('Created at: $formattedTime');

                // Display note with creator and timestamp
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(noteText),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Created by: $createdBy'),
                        Text('Created at: $formattedTime'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Update note button
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.edit),
                        ),
                        // Delete note button
                        IconButton(
                          onPressed: () => firestoreService.deleteNote(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
