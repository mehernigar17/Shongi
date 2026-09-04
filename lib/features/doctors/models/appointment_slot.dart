class AppointmentSlot {
  final String id;
  final String time;
  final int bookedCount;
  final int totalSlots;

  const AppointmentSlot({
    required this.id,
    required this.time,
    required this.bookedCount,
    required this.totalSlots,
  });

  bool get isFull => bookedCount >= totalSlots;
  int get remaining => totalSlots - bookedCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': time,
        'booked_count': bookedCount,
        'total_slots': totalSlots,
      };
}
