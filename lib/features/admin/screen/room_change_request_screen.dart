import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/services/firebase_services.dart';

class RoomChangeRequestScreen extends StatefulWidget {
  const RoomChangeRequestScreen({super.key});

  @override
  State<RoomChangeRequestScreen> createState() => _RoomChangeRequestScreenState();
}

class _RoomChangeRequestScreenState extends State<RoomChangeRequestScreen> {
  final FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    // Check if user has permission (assuming only admins can view room change requests)
    bool hasPermission = user != null; // Add your role checking logic here

    return Scaffold(
      appBar: buildAppBar(context, 'Room change requests'),
      body: !hasPermission
          ? const Center(
              child: Text("You don't have permission to view this page"),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firebaseServices.getPendingRoomChangeRequestsTest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No change room requests found"),
                  );
                } else {
                  final requests = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      final requestDoc = requests[index];
                      final requestData = requestDoc.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RoomCard(
                          requestDoc: requestDoc,
                          requestData: requestData,
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

class RoomCard extends StatelessWidget {
  final QueryDocumentSnapshot requestDoc;
  final Map<String, dynamic> requestData;

  const RoomCard({
    super.key,
    required this.requestDoc,
    required this.requestData,
  });

  Future<void> _approveRequest(BuildContext context, String status) async {
    try {
      final firebaseServices = FirebaseServices();
      await firebaseServices.updateRoomChangeRequestStatus(
        requestDoc.id, 
        status
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request $status successfully'),
            backgroundColor: status == 'APPROVED' ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract data directly from the document (test mode - all data embedded)
    final firstName = requestData['studentFirstName'] ?? 'Unknown';
    final lastName = requestData['studentLastName'] ?? 'Student';
    final email = requestData['studentEmail'] ?? 'No email';
    final phone = requestData['studentPhone'] ?? 'No phone';
    final currentRoomNumber = requestData['currentRoomNumber'] ?? 'Unknown Room';
    final currentBlock = requestData['currentBlock'] ?? 'Unknown Block';
    final toChangeBlock = requestData['toChangeBlock'] ?? 'Unknown Block';
    final toChangeRoomNumber = requestData['toChangeRoomNumber'] ?? 'Unknown Room';
    final changeReason = requestData['changeReason'] ?? '';

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
                    Text('Current Room: $currentRoomNumber'),
                    heightSpacer(8.0),
                    Text('Current Block: $currentBlock'),
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
                                  'Asked For :',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Block : $toChangeBlock",
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    widthSpacer(20),
                                    Text(
                                      "Room No : $toChangeRoomNumber",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            heightSpacer(12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reason :  ',
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
                                    changeReason,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 40.h,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _approveRequest(context, 'REJECTED'),
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.all(4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFED6A77),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Reject',
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
                      ),
                      widthSpacer(32),
                      Expanded(
                        child: InkWell(
                          onTap: () => _approveRequest(context, 'APPROVED'),
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.all(4),
                            decoration: ShapeDecoration(
                              color: const Color(0xFF2ECC71),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Approve ',
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
                      ),
                    ],
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