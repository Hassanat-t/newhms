import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  // No need for IssueModel? issueModel; anymore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Student Issues'),
      body: ListView.builder(
        itemCount: 2, // Show two dummy cards
        itemBuilder: (context, index) {
          // Remove 'const' here because IssueCard's build method uses non-const values
          return Padding(
            padding: const EdgeInsets.all(10.0),
            // Remove 'const' from IssueCard() call
            child: IssueCard(),
          );
        },
      ),
    );
  }
}

class IssueCard extends StatelessWidget {
  // Remove the 'required this.issue' from the constructor
  const IssueCard({super.key}); // Constructor takes no arguments

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Ensure full width
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
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align items to top
              children: [
                Column(
                  children: [
                    heightSpacer(20),
                    Image.asset(
                      AppConstants.person, // Ensure this asset exists
                      height: 70.h,
                      width: 70.w,
                    ),
                    heightSpacer(10),
                    Text(
                      'Anidu Hassanat', // Static name
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
                // ****** FIX 1: Remove 'const' from Expanded and its child Column ******
                // Use Expanded to prevent overflow and allow text wrapping
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        'Username: hassy01', // Static username
                        style: TextStyle(
                          color: Color(0xFF333333),
                          // fontSize: 14.sp, // Consider if ScreenUtil is needed for static text
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Room Number: A101'), // Static room number
                      SizedBox(height: 8.0),
                      // SizedBox with fixed width might cause issues on different screens
                      // Consider removing width or using FittedBox/Text overflow
                      SizedBox(
                        // width: 160.w, // Removed fixed width for better adaptability
                        child: Text(
                          'Email Id: hassy@gmail.com', // Static email
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text('Phone No.: 123-456-7890'), // Static phone
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            // Removed fixed height to allow content to dictate size
            // height: 160.h,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ****** FIX 2: Remove 'const' from Container's child Column ******
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    // <-- Removed 'const' here
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Issue Description ---
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ****** FIX 4: Remove unnecessary 'const' ******
                              Text(
                                // <-- Removed 'const'
                                'Issue :',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // Style is not constant due to potential sp
                                  color: Color(0xFF333333),
                                  fontSize:
                                      16, // Use int if not using ScreenUtil here
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                  width: 12), // Space between label and text
                              // Use Expanded for the description text
                              Expanded(
                                // ****** FIX 3: Ensure Expanded is not forced const ******
                                // It's generally okay, but ensure parent Row isn't const
                                child: Text(
                                  'The light in my room is broken.', // Static issue description
                                  style: TextStyle(
                                    // Style is not constant due to sp
                                    color: Color(0xFF333333),
                                    // fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12), // Vertical space
                          // --- Student Comment ---
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ****** FIX 4: Remove unnecessary 'const' ******
                              Text(
                                // <-- Removed 'const'
                                'Student comment :',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // Style is not constant due to sp
                                  color: Color(0xFF333333),
                                  fontSize:
                                      16, // Use int if not using ScreenUtil here
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                  width: 12), // Space between label and text
                              // Use Expanded for the comment text
                              Expanded(
                                child: Text(
                                  'It stopped working two days ago.', // Static comment
                                  style: TextStyle(
                                    // Style is not constant due to sp
                                    color: Color(0xFF333333),
                                    // fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20), // Vertical space before button
                          // --- Resolve Button ---
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Placeholder action - show a SnackBar
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Issue marked as Resolved (Simulated)')),
                                    );
                                  }
                                  // Removed apiCall.closeAnIssue(...)
                                },
                                child: Container(
                                  // width: 120.w, // Consider if fixed width is necessary
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  decoration: ShapeDecoration(
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 8,
                                        offset: Offset(1, 3),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize
                                        .min, // Shrink to fit content
                                    children: [
                                      // ****** FIX 4: Remove unnecessary 'const' ******
                                      Text(
                                        // <-- Removed 'const'
                                        'Resolve',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          // Style is not constant due to sp
                                          color: Colors.white,
                                          fontSize:
                                              16, // Use int if not using ScreenUtil here
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10), // Space at the bottom
                        ],
                      ),
                    ],
                  ),
                ),
                // Accept/Reject buttons are commented out in the original, so left as is
              ],
            ),
          ),
        ],
      ),
    );
  }
}
