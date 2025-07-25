import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/theme/colors.dart';

class IssueDetailsScreen extends StatelessWidget {
  const IssueDetailsScreen({super.key});

  Future<void> updateIssueStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance.collection('issues').doc(docId).update({
      'status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const CustomText(
          text: 'All Issues',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('issues')
            .orderBy('submittedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No issues found'));
          }

          final issues = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];
              final data = issue.data() as Map<String, dynamic>;
              final docId = issue.id;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Name: ${data['firstName']} ${data['lastName']}',
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(text: 'Room: ${data['roomNumber']} Block: ${data['block']}'),
                      CustomText(text: 'Issue: ${data['issueType']}'),
                      CustomText(text: 'Description: ${data['description']}'),
                      CustomText(
                        text: 'Status: ${data['status']}',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: data['status'] == 'Resolved'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(height: 10),
                      if (data['status'] != 'Resolved')
                        ElevatedButton(
                          onPressed: () async {
                            await updateIssueStatus(docId, 'Resolved');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Issue marked as resolved')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          child: const Text('Mark as Resolved'),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
