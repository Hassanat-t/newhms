import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/student/screen/change_room_screen.dart';

// Temporary room model (mock structure matching your previous API model)
class Room {
  final String roomNumber;
  final String block;
  final int roomCapacity;
  final int roomCurrentCapacity;
  final String roomType;

  Room({
    required this.roomNumber,
    required this.block,
    required this.roomCapacity,
    required this.roomCurrentCapacity,
    required this.roomType,
  });
}

class RoomAvailabilityScreen extends StatelessWidget {
  const RoomAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyRoomList = [
      Room(
        roomNumber: '101',
        block: 'A',
        roomCapacity: 5,
        roomCurrentCapacity: 3,
        roomType: 'Standard',
      ),
      Room(
        roomNumber: '202',
        block: 'B',
        roomCapacity: 5,
        roomCurrentCapacity: 5,
        roomType: 'Deluxe',
      ),
    ];

    return Scaffold(
      appBar: buildAppBar(context, 'Room Availabilities'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: dummyRoomList.length,
          itemBuilder: (context, index) {
            final room = dummyRoomList[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: RoomCard(room: room),
            );
          },
        ),
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: ShapeDecoration(
                      color: room.roomCurrentCapacity == room.roomCapacity
                          ? Colors.amber
                          : const Color(0xFF2ECC71),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 8,
                          offset: Offset(1, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: room.roomCurrentCapacity == room.roomCapacity
                          ? Text(
                              'Unavailable',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : InkWell(
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
