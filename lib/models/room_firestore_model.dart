class RoomFirestoreModel {
  final String id;
  final String roomNumber;
  final String block;
  final int roomCapacity;
  final int roomCurrentCapacity;
  final String? roomType;
  final String status;

  RoomFirestoreModel({
    required this.id,
    required this.roomNumber,
    required this.block,
    required this.roomCapacity,
    required this.roomCurrentCapacity,
    this.roomType,
    required this.status,
  });

  factory RoomFirestoreModel.fromMap(Map<String, dynamic> data, String id) {
    return RoomFirestoreModel(
      id: id,
      roomNumber: data['roomNumber'] ?? 'Unknown',
      block: data['block'] ?? 'Unknown',
      roomCapacity: data['roomCapacity'] ?? 0,
      roomCurrentCapacity: data['roomCurrentCapacity'] ?? 0,
      roomType: data['roomType'],
      status: data['status'] ?? 'available',
    );
  }
}