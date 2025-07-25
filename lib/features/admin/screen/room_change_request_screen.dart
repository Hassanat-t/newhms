import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
//import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';

class RoomChangeRequestScreen extends StatelessWidget {
  const RoomChangeRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Room change requests'),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('room_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('No room change requests found'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: RoomCard(data: data, docId: docs[index].id),
              );
            },
          );
        },
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const RoomCard({super.key, required this.data, required this.docId});

  Future<void> updateStatus(BuildContext context, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('room_requests')
          .doc(docId)
          .update({
        'status': status,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(),
      ),
      child: Column(
        children: [
          heightSpacer(20),
          Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.00, -1.00),
                end: const Alignment(0, 1),
                colors: [
                  const Color(0xFF2E8B57).withOpacity(0.5),
                  const Color(0x002E8B57),
                ],
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${data['userId'] ?? 'Unknown'}'),
                heightSpacer(8),
                Text('Requested Room: ${data['newRoom']}'),
                heightSpacer(8),
                Text('Requested Block: ${data['newBlock']}'),
                heightSpacer(8),
                Text('Reason: ${data['reason']}'),
                heightSpacer(8),
                Text('Status: ${data['status']}'),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 50.h,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => updateStatus(context, 'REJECTED'),
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFED6A77),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Center(
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                widthSpacer(32),
                Expanded(
                  child: InkWell(
                    onTap: () => updateStatus(context, 'APPROVED'),
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.all(4),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF2ECC71),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Center(
                        child: Text(
                          'Approve',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
