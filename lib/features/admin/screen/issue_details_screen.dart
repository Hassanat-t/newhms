import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';

class IssueScreen extends StatelessWidget {
  const IssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Student Issues'),
      body: ListView.builder(
        itemCount: dummyIssues.length,
        itemBuilder: (context, index) {
          final issue = dummyIssues[index];
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: IssueCard(issue: issue),
          );
        },
      ),
    );
  }
}

class DummyIssue {
  final String issueId;
  final String issue;
  final String studentComment;
  final String firstName;
  final String lastName;
  final String emailId;
  final String phoneNumber;
  final String roomNumber;

  DummyIssue({
    required this.issueId,
    required this.issue,
    required this.studentComment,
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.phoneNumber,
    required this.roomNumber,
  });
}

List<DummyIssue> dummyIssues = [
  DummyIssue(
    issueId: '1',
    issue: 'Leaking pipe',
    studentComment: 'Water keeps dripping every night',
    firstName: 'John',
    lastName: 'Doe',
    emailId: 'john.doe@example.com',
    phoneNumber: '08012345678',
    roomNumber: '101',
  ),
  DummyIssue(
    issueId: '2',
    issue: 'Broken fan',
    studentComment: 'Fan not rotating at all',
    firstName: 'Jane',
    lastName: 'Smith',
    emailId: 'jane.smith@example.com',
    phoneNumber: '08087654321',
    roomNumber: '202',
  ),
];

class IssueCard extends StatelessWidget {
  final DummyIssue issue;

  const IssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const ShapeDecoration(shape: RoundedRectangleBorder()),
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
                      '${issue.firstName} ${issue.lastName}',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpacer(10.0),
                    Text('Username: ${issue.firstName}',
                        style: TextStyle(
                            color: const Color(0xFF333333), fontSize: 14.sp)),
                    heightSpacer(8.0),
                    Text('Room Number: ${issue.roomNumber}'),
                    heightSpacer(8.0),
                    SizedBox(
                      width: 160.w,
                      child: Text(
                        'Email Id: ${issue.emailId}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    heightSpacer(8.0),
                    Text('Phone No.: ${issue.phoneNumber}'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Issue:',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              issue.issue,
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        heightSpacer(12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student comment:',
                              style: TextStyle(
                                color: const Color(0xFF333333),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            widthSpacer(8),
                            Expanded(
                              child: Text(
                                '“${issue.studentComment}”',
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 16.sp,
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
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Issue marked as resolved'),
                                  ),
                                );
                              },
                              child: Container(
                                width: 120.w,
                                padding: const EdgeInsets.all(8),
                                decoration: ShapeDecoration(
                                  color: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 8,
                                      offset: Offset(1, 3),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Resolve',
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
