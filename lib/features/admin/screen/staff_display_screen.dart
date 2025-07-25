import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/theme/colors.dart';

class StaffDisplayScreen extends StatelessWidget {
  const StaffDisplayScreen({super.key});

  Future<void> deleteStaff(String docId) async {
    await FirebaseFirestore.instance.collection('staff').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const CustomText(
          text: 'All Staff',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('staff').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No staff available.'));
          }

          final staffList = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: staffList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                final staff = staffList[index];
                final staffData = staff.data() as Map<String, dynamic>;
                final staffId = staff.id;

                return Container(
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryColor),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "${staffData['firstName']} ${staffData['lastName']}",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      CustomText(
                        text: staffData['jobRole'] ?? 'No role',
                        fontSize: 14,
                      ),
                      IconButton(
                        onPressed: () async {
                          await deleteStaff(staffId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Staff deleted')),
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
