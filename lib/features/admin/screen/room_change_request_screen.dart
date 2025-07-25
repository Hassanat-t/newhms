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
        SnackBar(content: Text('Request marked as $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${data['userId'] ?? 'N/A'}'),
                heightSpacer(6),
                Text('Current Block: ${data['currentBlock'] ?? 'N/A'}'),
                heightSpacer(6),
                Text('Current Room: ${data['currentRoom'] ?? 'N/A'}'),
                heightSpacer(6),
                Text('Requested Block: ${data['requestedBlock'] ?? 'N/A'}'),
                heightSpacer(6),
                Text('Requested Room: ${data['requestedRoom'] ?? 'N/A'}'),
                heightSpacer(6),
                Text('Reason: ${data['reason'] ?? 'No reason provided'}'),
                heightSpacer(6),
                Text('Status: ${data['status'] ?? 'Pending'}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: data['status'] == 'APPROVED'
                          ? Colors.green
                          : data['status'] == 'REJECTED'
                              ? Colors.red
                              : Colors.orange,
                    )),
              ],
            ),
          ),
          Container(
            height: 50.h,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => updateStatus(context, 'REJECTED'),
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Reject',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                widthSpacer(16),
                Expanded(
                  child: InkWell(
                    onTap: () => updateStatus(context, 'APPROVED'),
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Approve',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
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
