import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/auth/widgets/custom_button.dart';
import 'package:newhms/features/auth/widgets/custom_text_field.dart';
import 'package:newhms/services/firebase_room_service.dart';

class ChangeRoomScreen extends StatefulWidget {
  const ChangeRoomScreen({super.key});

  @override
  State<ChangeRoomScreen> createState() => _ChangeRoomScreenState();
}

class _ChangeRoomScreenState extends State<ChangeRoomScreen> {
  final FirebaseRoomService _firebaseRoomService = FirebaseRoomService();
  String? _selectedBlock;
  String? _selectedRoom;
  final TextEditingController _reasonController = TextEditingController();
  final List<String> _blockOptions = ['A', 'B'];
  final List<String> _roomOptionsA = ['101', '102', '103'];
  final List<String> _roomOptionsB = ['201', '202', '203'];

  // Current user data (in a real app, you might fetch this from Firestore)
  String _currentRoomNumber = '101'; // Default value, replace with actual data
  String _currentBlock = 'A'; // Default value, replace with actual data

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize with current user data
    _initializeCurrentRoomData();
  }

  Future<void> _initializeCurrentRoomData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Fetch current room data from Firestore
        final studentDoc = await FirebaseFirestore.instance
            .collection('students')
            .where('email', isEqualTo: user.email)
            .limit(1)
            .get();

        if (studentDoc.docs.isNotEmpty) {
          final studentData = studentDoc.docs.first.data();
          setState(() {
            _currentRoomNumber = studentData['roomNumber'] ?? '101';
            _currentBlock = studentData['block'] ?? 'A';
          });
        }
      }
    } catch (e) {
      print('Error fetching current room data: $e');
      // Keep default values
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitRoomChangeRequest() async {
    if (_selectedBlock == null || _selectedRoom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both block and room.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_reasonController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a reason for the change.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      await _firebaseRoomService.submitRoomChangeRequest(
        currentRoomNumber: _currentRoomNumber,
        currentBlock: _currentBlock,
        toChangeRoomNumber: _selectedRoom!,
        toChangeBlock: _selectedBlock!,
        changeReason: _reasonController.text.trim(),
        studentId: user.uid,
        studentEmail: user.email ?? '',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Room change request submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear form
        setState(() {
          _selectedBlock = null;
          _selectedRoom = null;
          _reasonController.clear();
        });

        // Optionally navigate back
        // Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to submit request: ${e.toString().replaceAll('Exception:', '').trim()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Change Room'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpacer(20),
                    Text(
                      'Current block and Room no.',
                      style: TextStyle(
                        color: const Color(0xFF464646),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    heightSpacer(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF2E8B57)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Room No - $_currentRoomNumber',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        ),
                        widthSpacer(30),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF2E8B57)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Block No - $_currentBlock',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightSpacer(20),
                    Text(
                      'Shift to block and Room no.',
                      style: TextStyle(
                        color: const Color(0xFF464646),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    heightSpacer(10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            width: double.maxFinite,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF2E8B57)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              isExpanded: true,
                              value: _selectedBlock,
                              hint: const Text('Select Block'),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedBlock = newValue;
                                  _selectedRoom = null;
                                });
                              },
                              items: _blockOptions.map((String block) {
                                return DropdownMenuItem<String>(
                                  value: block,
                                  child: Text(block),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        widthSpacer(20),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            width: double.maxFinite,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF2E8B57)),
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: DropdownButton<String>(
                              underline: const SizedBox(),
                              isExpanded: true,
                              value: _selectedRoom,
                              hint: const Text('Select Room'),
                              onChanged: _selectedBlock == null
                                  ? null
                                  : (String? newValue) {
                                      setState(() {
                                        _selectedRoom = newValue;
                                      });
                                    },
                              items: (_selectedBlock == 'A'
                                      ? _roomOptionsA
                                      : _selectedBlock == 'B'
                                          ? _roomOptionsB
                                          : [])
                                  .map<DropdownMenuItem<String>>((room) {
                                return DropdownMenuItem<String>(
                                  value: room,
                                  child: Text(room),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightSpacer(20),
                    Text(
                      'Reason for change',
                      style: TextStyle(
                        color: const Color(0xFF464646),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    heightSpacer(10),
                    CustomTextField(
                      controller: _reasonController,
                      inputHint: 'Write your reason',
                      maxLines: 3,
                    ),
                    heightSpacer(40),
                    CustomButton(
                      press: _submitRoomChangeRequest,
                      buttonText: 'Submit',
                      isLoading: _isLoading,
                    ),
                    heightSpacer(20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
