import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {

  // get collection
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // CREATE
  void addNote(String noteText) {
    FirebaseFirestore.instance.collection('notes').add({
      'note': noteText,
      'created_by': FirebaseAuth.instance.currentUser?.displayName ?? 'Anonymous',  // Set the creator
      'created_at': FieldValue.serverTimestamp(),  // Set the timestamp
    });
  }

  // READ:
  Stream<QuerySnapshot> getNotesStream() {
    return FirebaseFirestore.instance
        .collection('notes')
        .orderBy('created_at', descending: true)
        .snapshots();
  }
  // UPDATE:
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note' : newNote,
      'timestamp' : Timestamp.now(),
    });
  }
  // DELETE:
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}