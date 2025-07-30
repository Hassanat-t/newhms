import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:newhms/models/issue_model.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  Future<List<IssueModel>> _fetchIssues() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('issues')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => IssueModel.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Student Issues'),
      body: FutureBuilder<List<IssueModel>>(
        future: _fetchIssues(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Failed to load issues.'));
          }

          final issues = snapshot.data!;

          if (issues.isEmpty) {
            return const Center(child: Text('No issues found.'));
          }

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: IssueCard(issue: issues[index]),
              );
            },
          );
        },
      ),
    );
  }
}


class IssueCard extends StatelessWidget {
  final IssueModel issue;
  const IssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const ShapeDecoration(shape: RoundedRectangleBorder()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heightSpacer(20),
          Container(
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2E8B57).withOpacity(0.5),
                  const Color(0x002E8B57),
                ],
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    heightSpacer(20),
                    Image.asset(AppConstants.person, height: 70.h, width: 70.w),
                    heightSpacer(10),
                    Text(issue.studentEmail.split('@').first,
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        )),
                    heightSpacer(20),
                  ],
                ),
                widthSpacer(20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpacer(10),
                      Text('UID: ${issue.uid}'),
                      heightSpacer(8),
                      Text('Room: ${issue.roomNumber}'),
                      heightSpacer(8),
                      Text('Email: ${issue.studentEmail}'),
                      heightSpacer(8),
                      Text('Phone: ${issue.contactNumber}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabelValue('Issue', issue.issueType),
                _buildLabelValue('Student Comment', issue.comment),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Issue marked as resolved')),
                      );
                      // 🔧 You can also update the issue status in Firestore here.
                    },
                    child: const Text('Resolve'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
