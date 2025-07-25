import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDocument(String collectionPath, Map<String, dynamic> data, {String? docId}) async {
    try {
      if (docId != null) {
        await _firestore.collection(collectionPath).doc(docId).set(data);
      } else {
        await _firestore.collection(collectionPath).add(data);
      }
    } catch (e) {
      debugPrint('FirestoreService add error: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot?> getDocument(String collectionPath, String docId) async {
    try {
      return await _firestore.collection(collectionPath).doc(docId).get();
    } catch (e) {
      debugPrint('FirestoreService get error: $e');
      return null;
    }
  }

  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
    } catch (e) {
      debugPrint('FirestoreService delete error: $e');
    }
  }

  Stream<QuerySnapshot> streamCollection(String collectionPath) {
    return _firestore.collection(collectionPath).snapshots();
  }
}

