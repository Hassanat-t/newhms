import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/student/screen/change_room_screen.dart';
import 'package:newhms/models/room_firestore_model.dart';
import 'package:newhms/services/firebase_room_availability_service.dart';

class RoomAvailabilityScreen extends StatefulWidget {
  const RoomAvailabilityScreen({super.key});

  @override
  State<RoomAvailabilityScreen> createState() => _RoomAvailabilityScreenState();
}

class _RoomAvailabilityScreenState extends State<RoomAvailabilityScreen> {
  final FirebaseRoomAvailabilityService _roomService = FirebaseRoomAvailabilityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Room Availabilities'),
      body: StreamBuilder<QuerySnapshot>(
        stream: _roomService.getRoomAvailabilityStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Availability"),
            );
          } else {
            final rooms = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  final roomDoc = rooms[index];
                  final roomData = roomDoc.data() as Map<String, dynamic>;
                  final room = RoomFirestoreModel.fromMap(roomData, roomDoc.id);
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: RoomCard(room: room),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final RoomFirestoreModel room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final isAvailable = room.roomCurrentCapacity < room.roomCapacity;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xFF007B3B)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
            bottomLeft: Radius.circular(30.r),
          ),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x4C007B3B),
            blurRadius: 8,
            offset: Offset(1, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Image.asset(
                AppConstants.bed,
                height: 70.h,
                width: 70.w,
              ),
              Text(
                'Room no. - ${room.roomNumber}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          widthSpacer(15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Block ${room.block}',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                ),
              ),
              heightSpacer(5),
              Text(
                'Capacity: ${room.roomCapacity}',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                ),
              ),
              heightSpacer(5),
              Text(
                'Current Capacity: ${room.roomCurrentCapacity}',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                ),
              ),
              heightSpacer(5),
              if (room.roomType != null)
                Text(
                  'Type: ${room.roomType}',
                  style: TextStyle(
                    color: const Color(0xFF333333),
                    fontSize: 16.sp,
                  ),
                ),
              heightSpacer(5),
              Row(
                children: [
                  Text(
                    'Status: ',
                    style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 16.sp,
                    ),
                  ),
                  Container(
                    height: 30.h,
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 5),
                    decoration: ShapeDecoration(
                      color: isAvailable
                          ? const Color(0xFF2ECC71)
                          : Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 8,
                          offset: Offset(1, 3),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: isAvailable
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const ChangeRoomScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Available',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : Text(
                            'Unavailable',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}