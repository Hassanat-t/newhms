import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/app_bar.dart';
import 'package:newhms/common/constants.dart';
import 'package:newhms/common/spacing.dart';
import 'package:newhms/features/student/screen/change_room_screen.dart';

class RoomAvailabilityScreen extends StatefulWidget {
  const RoomAvailabilityScreen({super.key});

  @override
  State<RoomAvailabilityScreen> createState() => _RoomAvailabilityScreenState();
}

class _RoomAvailabilityScreenState extends State<RoomAvailabilityScreen> {
  // Dummy data for now
  final List<Map<String, dynamic>> rooms = [
    {
      'roomNo': '101',
      'block': 'Block A',
      'capacity': 2,
      'currentCapacity': 1,
      'type': '2 man room'
    },
    {
      'roomNo': '102',
      'block': 'Block B',
      'capacity': 3,
      'currentCapacity': 3,
      'type': '3 man room'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, 'Room Availabilities'),
      body: Column(
        children: [
          heightSpacer(20),
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return RoomCard(room: rooms[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    bool isAvailable = room['currentCapacity'] < room['capacity'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                'Room no. - ${room['roomNo']}',
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
                room['block'],
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                ),
              ),
              heightSpacer(5),
              Text(
                'Capacity: ${room['capacity']}',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                ),
              ),
              heightSpacer(5),
              Text(
                'Current Capacity: ${room['currentCapacity']}',
                style: TextStyle(
                  color: const Color(0xFF333333),
                  fontSize: 16.sp,
                ),
              ),
              heightSpacer(5),
              Text(
                'Type: ${room['type']}',
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: ShapeDecoration(
                      color:
                          isAvailable ? const Color(0xFF2ECC71) : Colors.amber,
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
