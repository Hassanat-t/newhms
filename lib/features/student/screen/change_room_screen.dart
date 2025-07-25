import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/theme/colors.dart';

class ChangeRoomScreen extends StatefulWidget {
  const ChangeRoomScreen({super.key});

  @override
  State<ChangeRoomScreen> createState() => _ChangeRoomScreenState();
}

class _ChangeRoomScreenState extends State<ChangeRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentRoomController = TextEditingController();
  final TextEditingController _newRoomController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userData = userDoc.data();

    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not found')),
      );
      return;
    }

    final requestData = {
      'userId': uid,
      'firstName': userData['firstName'],
      'lastName': userData['lastName'],
      'currentRoom': _currentRoomController.text.trim(),
      'requestedRoom': _newRoomController.text.trim(),
      'reason': _reasonController.text.trim(),
      'status': 'Pending',
      'requestedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('roomChangeRequests')
        .add(requestData);

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request submitted successfully')),
    );

    _currentRoomController.clear();
    _newRoomController.clear();
    _reasonController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const CustomText(
          text: 'Change Room Request',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              verticalSpacing(16),
              TextFormField(
                controller: _currentRoomController,
                decoration: const InputDecoration(labelText: 'Current Room'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              verticalSpacing(16),
              TextFormField(
                controller: _newRoomController,
                decoration: const InputDecoration(labelText: 'Requested Room'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              verticalSpacing(16),
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Reason'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              verticalSpacing(24),
              CustomButton(
                isLoading: _isSubmitting,
                onPressed: _submitRequest,
                buttonText: 'Submit Request',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
