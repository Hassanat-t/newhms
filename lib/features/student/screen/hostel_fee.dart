import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/theme/colors.dart';

class HostelFeeScreen extends StatefulWidget {
  const HostelFeeScreen({Key? key}) : super(key: key);

  @override
  State<HostelFeeScreen> createState() => _HostelFeeScreenState();
}

class _HostelFeeScreenState extends State<HostelFeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _paymentMethodController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitFee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userData = userDoc.data();

    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User data not found')),
      );
      return;
    }

    final feeData = {
      'userId': uid,
      'firstName': userData['firstName'],
      'lastName': userData['lastName'],
      'roomNumber': userData['roomNumber'],
      'amount': _amountController.text.trim(),
      'paymentMethod': _paymentMethodController.text.trim(),
      'note': _noteController.text.trim(),
      'status': 'Pending',
      'submittedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance.collection('hostelFees').add(feeData);

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hostel fee submitted')),
    );

    _amountController.clear();
    _paymentMethodController.clear();
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const CustomText(
          text: 'Pay Hostel Fee',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              verticalSpacing(16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              verticalSpacing(16),
              TextFormField(
                controller: _paymentMethodController,
                decoration: const InputDecoration(labelText: 'Payment Method (e.g. Bank Transfer)'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              verticalSpacing(16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              verticalSpacing(24),
              CustomButton(
                isLoading: _isSubmitting,
                onPressed: _submitFee,
                buttonText: 'Submit Fee',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
