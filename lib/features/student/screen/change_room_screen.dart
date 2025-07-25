import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';

class ChangeRoomScreen extends StatefulWidget {
  const ChangeRoomScreen({super.key});

  @override
  State<ChangeRoomScreen> createState() => _ChangeRoomScreenState();
}

class _ChangeRoomScreenState extends State<ChangeRoomScreen> {
  final TextEditingController reason = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? currentBlock;
  String? currentRoom;
  String? selectedBlock;
  String? selectedRoom;
  final List<String> blockOptions = ['A', 'B'];
  final List<String> roomOptionsA = ['101', '102', '103'];
  final List<String> roomOptionsB = ['201', '202', '203'];

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          currentBlock = doc['block'];
          currentRoom = doc['roomNumber'];
        });
      }
    }
  }

  Future<void> _submitRoomChangeRequest() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || selectedBlock == null || selectedRoom == null || reason.text.isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('room_requests').add({
        'userId': uid,
        'currentBlock': currentBlock,
        'currentRoom': currentRoom,
        'requestedBlock': selectedBlock,
        'requestedRoom': selectedRoom,
        'reason': reason.text,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Room change request submitted")),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting request: $e")),
      );
    }
  }

  @override
  void dispose() {
    reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Change Room'),
      body: currentBlock == null || currentRoom == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current block and Room no.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  heightSpacer(10),
                  Row(
                    children: [
                      _infoCard("Room No - $currentRoom"),
                      widthSpacer(20),
                      _infoCard("Block - $currentBlock"),
                    ],
                  ),
                  heightSpacer(20),
                  Text(
                    'Shift to block and Room no.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  heightSpacer(10),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown(blockOptions, selectedBlock, (val) {
                        setState(() {
                          selectedBlock = val;
                          selectedRoom = null;
                        });
                      })),
                      widthSpacer(20),
                      Expanded(
                        child: _buildDropdown(
                          selectedBlock == 'A' ? roomOptionsA : roomOptionsB,
                          selectedRoom,
                          (val) => setState(() => selectedRoom = val),
                        ),
                      ),
                    ],
                  ),
                  heightSpacer(20),
                  Text(
                    'Reason for change',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  heightSpacer(10),
                  CustomTextField(
                    controller: reason,
                    inputHint: 'Write your reason',
                    maxLines: 4,
                  ),
                  heightSpacer(40),
                  CustomButton(
                    buttonText: 'Submit',
                    press: _submitRoomChangeRequest,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoCard(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF2E8B57)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.sp, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2E8B57)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      ),
    );
  }
}
