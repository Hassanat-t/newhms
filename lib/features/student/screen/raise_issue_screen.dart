import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/theme/colors.dart';

class RaiseIssueScreen extends StatefulWidget {
  const RaiseIssueScreen({super.key});

  @override
  State<RaiseIssueScreen> createState() => _RaiseIssueScreenState();
}

class _RaiseIssueScreenState extends State<RaiseIssueScreen> {
  final _issueTypes = ['Plumbing', 'Electrical', 'Cleaning', 'Other'];
  String? selectedType;
  final TextEditingController _descController = TextEditingController();

  String block = '';
  String roomNumber = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserRoomInfo();
  }

  Future<void> _loadUserRoomInfo() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      setState(() {
        block = data['block'] ?? '';
        roomNumber = data['roomNumber'] ?? '';
      });
    }
  }

  Future<void> _submitIssue() async {
    if (selectedType == null || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required")));
      return;
    }

    setState(() => isLoading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('issues').add({
      'studentId': uid,
      'issueType': selectedType,
      'description': _descController.text.trim(),
      'block': block,
      'roomNumber': roomNumber,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Issue submitted")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Raise Issue', fontSize: 20, fontWeight: FontWeight.bold),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(labelText: 'Select Issue Type'),
              items: _issueTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (val) => setState(() => selectedType = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Describe the issue',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitIssue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Submit Issue'),
                  ),
          ],
        ),
      ),
    );
  }
}
