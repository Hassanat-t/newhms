import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';

// --- Dummy Data Models (Simplified versions) ---
class StudentDetails {
  final String firstName;
  final String lastName;
  final String emailId;
  final String phoneNumber;

  StudentDetails({
    required this.firstName,
    required this.lastName,
    required this.emailId,
    required this.phoneNumber,
  });
}

class Result {
  final String roomChangeRequestId;
  final String currentRoomNumber;
  final String currentBlock;
  final String toChangeBlock;
  final String toChangeRoomNumber;
  final String changeReason;
  final StudentDetails studentDetails;

  Result({
    required this.roomChangeRequestId,
    required this.currentRoomNumber,
    required this.currentBlock,
    required this.toChangeBlock,
    required this.toChangeRoomNumber,
    required this.changeReason,
    required this.studentDetails,
  });
}

class RoomChangeModel {
  final List<Result> result;

  RoomChangeModel({required this.result});
}

// --- Main Screen ---
class RoomChangeRequestScreen extends StatefulWidget {
  const RoomChangeRequestScreen({super.key});

  @override
  State<RoomChangeRequestScreen> createState() =>
      _RoomChangeRequestScreenState();
}

class _RoomChangeRequestScreenState extends State<RoomChangeRequestScreen> {
  // Dummy data - replace with your actual data fetching logic if needed
  late Future<RoomChangeModel> _fetchRequestsFuture;

  Future<RoomChangeModel> _fetchRequests() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return dummy data
    return RoomChangeModel(
      result: [
        Result(
          roomChangeRequestId: 'REQ_001',
          currentRoomNumber: 'A101',
          currentBlock: 'Block A',
          toChangeBlock: 'Block B',
          toChangeRoomNumber: 'B205',
          changeReason: 'Roommate conflict',
          studentDetails: StudentDetails(
            firstName: 'Alice',
            lastName: 'Johnson',
            emailId: 'alice.j@example.com',
            phoneNumber: '555-1234',
          ),
        ),
        Result(
          roomChangeRequestId: 'REQ_002',
          currentRoomNumber: 'C150',
          currentBlock: 'Block C',
          toChangeBlock: 'Block A',
          toChangeRoomNumber: 'A110',
          changeReason: 'Need a quieter room',
          studentDetails: StudentDetails(
            firstName: 'Bob',
            lastName: 'Smith',
            emailId: 'bob.smith@example.com',
            phoneNumber: '555-5678',
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchRequestsFuture = _fetchRequests();
  }

  // Dummy function to simulate approval/rejection logic locally
  void _handleRequestAction(String requestId, String action) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request $requestId marked as $action (Simulated)'),
        ),
      );
      // TODO: Implement actual logic to update UI or data state
      // For example, you might want to refresh the list or update the specific item's status visually
    }
  }

  @override
  Widget build(BuildContext context) {
    // Removed the role check: ApiUrls.roleId == 2 || ApiUrls.roleId == 3 ? ... : ...
    // The screen will now always attempt to load and display requests.
    return Scaffold(
      appBar: buildAppBar(context, 'Room change requests'),
      body: FutureBuilder<RoomChangeModel>(
        future: _fetchRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // It's good practice to show errors to the user
            return Center(
                child: Text('Error loading requests: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final List<Result> requests = snapshot.data!.result;
            // Check if the list of requests is empty
            if (requests.isEmpty) {
              return const Center(
                child: Text("No change room requests found"),
              );
            } else {
              // Build the list of request cards
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RoomCard(
                      request: request,
                      // Pass the handler functions for button callbacks
                      onApprove: () => _handleRequestAction(
                          request.roomChangeRequestId, 'Approved'),
                      onReject: () => _handleRequestAction(
                          request.roomChangeRequestId, 'Rejected'),
                    ),
                  );
                },
              );
            }
          } else {
            // Handle the case where snapshot.hasData is true but data is null
            // This is unlikely with dummy data but good for robustness
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}

// --- Room Card Widget ---
class RoomCard extends StatelessWidget {
  final Result request;
  // Callbacks for button actions, passed from the parent screen
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RoomCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // Removed API call instantiation: ApiCall apiCall = ApiCall();

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
              // Use CrossAxisAlignment.start to align items to the top
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    heightSpacer(20),
                    Image.asset(
                      AppConstants.person, // Ensure this asset path is correct
                      height: 70.h,
                      width: 70.w,
                    ),
                    heightSpacer(10),
                    Text(
                      '${request.studentDetails.firstName} ${request.studentDetails.lastName}',
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
                // Use Expanded to allow the column of details to take available space
                // and prevent overflow issues
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpacer(10.0),
                      Text(
                        'Username: ${request.studentDetails.firstName}', // Simplified username
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 14.sp,
                        ),
                      ),
                      heightSpacer(8.0),
                      Text('Current Room: ${request.currentRoomNumber}'),
                      heightSpacer(8.0),
                      Text('Current Block: ${request.currentBlock}'),
                      heightSpacer(8.0),
                      // Consider if fixed width is needed or if TextOverflow.ellipsis is sufficient
                      SizedBox(
                        // width: 160.w, // Removed fixed width for better adaptability
                        child: Text(
                          'Email Id: ${request.studentDetails.emailId}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      heightSpacer(8.0),
                      Text('Phone No.: ${request.studentDetails.phoneNumber}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.maxFinite,
            // Removed fixed height: height: 160.h,
            // Let the content determine the height for better flexibility
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Removed Expanded as the parent is a Column, not a Row
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Asked For Section ---
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            // Align items in the row to the top
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
                              const SizedBox(
                                  width: 12), // Space between label and content
                              // Use Expanded to contain the block/room info row
                              Expanded(
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // Using spaceBetween inside an Expanded child can be tricky.
                                  // It's often better to let children size themselves or
                                  // use Spacer() if needed. For now, let them align left.
                                  // crossAxisAlignment is controlled by the parent Row.
                                  children: [
                                    Text(
                                      "Block : ${request.toChangeBlock}",
                                      style: TextStyle(
                                        color: Colors
                                            .pink, // Or AppColors if defined
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    widthSpacer(
                                        20), // Fixed space between Block and Room No
                                    Text(
                                      "Room No : ${request.toChangeRoomNumber}",
                                      // textAlign: TextAlign.center, // Not needed if not centered
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    // If you want the "Room No" part to be pushed to the end:
                                    // const Spacer(),
                                    // Text("Room No : ${request.toChangeRoomNumber}", ...)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          heightSpacer(12),
                          // --- Reason Section ---
                          Row(
                            // Align items in the row to the top
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reason :  ',
                                // textAlign: TextAlign.center, // Not needed for label
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                  width: 12), // Space between label and text
                              // Use Expanded to allow the reason text to wrap within available space
                              Expanded(
                                child: Text(
                                  request.changeReason,
                                  // textAlign: TextAlign.center, // Removed for better wrapping
                                  style: TextStyle(
                                    color: const Color(0xFF333333),
                                    fontSize: 16.sp,
                                    fontFamily:
                                        'Inter', // Ensure font is available or remove
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
                // --- Action Buttons Section ---
                Container(
                  width: double.maxFinite,
                  // Removed fixed height: height: 40.h,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      // --- Reject Button ---
                      Expanded(
                        child: InkWell(
                          // Use the passed callback function
                          onTap: onReject,
                          child: Container(
                            // Removed fixed height: height: double.infinity,
                            // Padding will define the size better
                            padding: const EdgeInsets.all(
                                8), // Increased padding for tap area
                            decoration: ShapeDecoration(
                              color: const Color(
                                  0xFFED6A77), // Red color for reject
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
                              children: [
                                Text(
                                  'Reject',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      widthSpacer(32), // Space between buttons
                      // --- Approve Button ---
                      Expanded(
                        child: InkWell(
                          // Use the passed callback function
                          onTap: onApprove,
                          child: Container(
                            // Removed fixed height: height: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: ShapeDecoration(
                              color: const Color(
                                  0xFF2ECC71), // Green color for approve
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
                              children: [
                                Text(
                                  'Approve',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
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
                heightSpacer(10), // Add some space below the buttons
              ],
            ),
          ),
        ],
      ),
    );
  }
}
