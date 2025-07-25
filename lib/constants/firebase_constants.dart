import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

final staffCollection = firestore.collection('staff');
final studentCollection = firestore.collection('students');
final roomRequestCollection = firestore.collection('room_requests');
final issuesCollection = firestore.collection('issues');
final hostelFeesCollection = firestore.collection('hostel_fees');