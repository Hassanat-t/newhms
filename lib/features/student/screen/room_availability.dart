import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newhms/common/custom_text.dart';
import 'package:newhms/theme/colors.dart';

class RoomAvailabilityScreen extends StatelessWidget {
  const RoomAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        title: const CustomText(
          text: 'Room Availability',
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .orderBy('block')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No rooms found'));
          }

          final roomDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: roomDocs.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final room = roomDocs[index];
              final data = room.data() as Map<String, dynamic>;

              final String block = data['block'] ?? 'N/A';
              final String roomNumber = data['roomNumber'] ?? 'N/A';
              final int capacity = data['capacity'] ?? 0;
              final int occupied = data['occupied'] ?? 0;
              final int available = capacity - occupied;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.bedroom_child, color: primaryColor),
                  title: Text('Room $roomNumber - Block $block'),
                  subtitle: Text('Available: $available / $capacity'),
                  trailing: Icon(
                    available > 0 ? Icons.check_circle : Icons.cancel,
                    color: available > 0 ? Colors.green : Colors.red,
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
