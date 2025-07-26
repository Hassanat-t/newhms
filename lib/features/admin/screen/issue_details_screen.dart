import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/services/firebase_services.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Student Issues'),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseServices.getOpenIssuesTest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Issues found"),
            );
          } else {
            final issues = snapshot.data!.docs;
            return ListView.builder(
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issueDoc = issues[index];
                final issueData = issueDoc.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IssueCard(
                    issueDoc: issueDoc,
                    issueData: issueData,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  final QueryDocumentSnapshot issueDoc;
  final Map<String, dynamic> issueData;

  const IssueCard({
    super.key,
    required this.issueDoc,
    required this.issueData,
  });

  Future<void> _resolveIssue(BuildContext context) async {
    try {
      final firebaseServices = FirebaseServices();
      await firebaseServices.updateIssueStatus(issueDoc.id, 'resolved');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Issue resolved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resolve issue: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract data directly from the document (test mode - all data embedded)
    final firstName = issueData['studentFirstName'] ?? 'Unknown';
    final lastName = issueData['studentLastName'] ?? 'Student';
    final email = issueData['studentEmail'] ?? 'No email';
    final phone = issueData['studentPhone'] ?? 'No phone';
    final roomNumber = issueData['roomNumber'] ?? 'Unknown Room';
    final issueText = issueData['issue'] ?? '';
    final comment = issueData['studentComment'] ?? '';

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
            child: Row(
              children: [
                Column(
                  children: [
                    heightSpacer(20),
                    Image.asset(
                      AppConstants.person,
                      height: 70.h,
                      width: 70.w,
                    ),
                    heightSpacer(10),
                    Text(
                      '$firstName $lastName',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    heightSpacer(20),
                  ],
                ),
                widthSpacer(20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpacer(10.0),
                    Text(
                      'Username: $firstName',
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 14.sp,
                      ),
                    ),
                    heightSpacer(8.0),
                    Text('Room Number: $roomNumber'),
                    heightSpacer(8.0),
                    SizedBox(
                      width: 160.w,
                      child: Text(
                        'Email Id: $email',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    heightSpacer(8.0),
                    Text('Phone No.: $phone'),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 160.h,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Issue :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    issueText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            heightSpacer(12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Student comment :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '“$comment”',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 16.sp,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            heightSpacer(20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () => _resolveIssue(context),
                                  child: Container(
                                    width: 120.w,
                                    padding: const EdgeInsets.all(8),
                                    decoration: ShapeDecoration(
                                      color: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      shadows: const [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 8,
                                          offset: Offset(1, 3),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Resolve',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            heightSpacer(10),
                          ],
                        ),
                      ],
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