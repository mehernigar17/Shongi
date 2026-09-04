import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';

class TimeSlotModel {
  final String id;
  final String time;
  final int bookedCount;
  final int totalSlots;

  const TimeSlotModel({
    required this.id,
    required this.time,
    required this.bookedCount,
    required this.totalSlots,
  });

  bool get isFull => bookedCount >= totalSlots;
  int get remaining => totalSlots - bookedCount;

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id']?.toString() ?? '',
      time: json['time'] as String,
      bookedCount: json['booked_count'] as int,
      totalSlots: json['total_slots'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time,
    'booked_count': bookedCount,
    'total_slots': totalSlots,
  };
}

class AppointmentDayModel {
  final DateTime date;
  final List<TimeSlotModel> slots;

  const AppointmentDayModel({
    required this.date,
    required this.slots,
  });
}

abstract class AppointmentRepository {
  Future<List<TimeSlotModel>> fetchSlots(String doctorId, DateTime date);
  Future<bool> bookSlot(String doctorId, DateTime date, String slotId);
}

class MockAppointmentRepository implements AppointmentRepository {
  @override
  Future<List<TimeSlotModel>> fetchSlots(String doctorId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockSlots;
  }

  @override
  Future<bool> bookSlot(String doctorId, DateTime date, String slotId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return true;
  }

  static const List<TimeSlotModel> _mockSlots = [
    TimeSlotModel(id: 's1', time: '9:00 AM', bookedCount: 3, totalSlots: 3),
    TimeSlotModel(id: 's2', time: '9:30 AM', bookedCount: 2, totalSlots: 3),
    TimeSlotModel(id: 's3', time: '10:00 AM', bookedCount: 1, totalSlots: 3),
    TimeSlotModel(id: 's4', time: '10:30 AM', bookedCount: 0, totalSlots: 3),
    TimeSlotModel(id: 's5', time: '11:00 AM', bookedCount: 3, totalSlots: 3),
    TimeSlotModel(id: 's6', time: '11:30 AM', bookedCount: 1, totalSlots: 3),
    TimeSlotModel(id: 's7', time: '2:00 PM', bookedCount: 0, totalSlots: 3),
    TimeSlotModel(id: 's8', time: '2:30 PM', bookedCount: 2, totalSlots: 3),
    TimeSlotModel(id: 's9', time: '3:00 PM', bookedCount: 0, totalSlots: 3),
    TimeSlotModel(id: 's10', time: '3:30 PM', bookedCount: 1, totalSlots: 3),
    TimeSlotModel(id: 's11', time: '4:00 PM', bookedCount: 0, totalSlots: 3),
    TimeSlotModel(id: 's12', time: '4:30 PM', bookedCount: 2, totalSlots: 3),
  ];
}

class BookAppointment extends StatefulWidget {
  final String doctorName;
  final AppointmentRepository repository;

  BookAppointment({
    super.key,
    required this.doctorName,
    AppointmentRepository? repository,
  }) : repository = repository ?? MockAppointmentRepository();

  @override
  State<BookAppointment> createState() => BookAppointmentState();
}

class BookAppointmentState extends State<BookAppointment> {
  late DateTime selectedDate;
  TimeSlotModel? selectedSlot;
  late List<DateTime> dateList;

  List<TimeSlotModel> slots = [];
  bool isLoadingSlots = false;
  bool isBooking = false;

  static const List<String> kDayNames = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];
  static const List<String> kMonthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dateList = List.generate(30, (i) => DateTime.now().add(Duration(days: i)));
    loadSlots();
  }

  Future<void> loadSlots() async {
    setState(() => isLoadingSlots = true);
    final result = await widget.repository.fetchSlots(widget.doctorName, selectedDate);
    if (!mounted) return;
    setState(() {
      slots = result;
      isLoadingSlots = false;
    });
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      selectedSlot = null;
    });
    loadSlots();
  }

  Future<void> onConfirmBooking() async {
    if (selectedSlot == null) return;
    setState(() => isBooking = true);
    final success = await widget.repository.bookSlot(
      widget.doctorName,
      selectedDate,
      selectedSlot!.id,
    );
    if (!mounted) return;
    setState(() => isBooking = false);
    if (success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: greenBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle_rounded, color: greenAccent, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Confirmed!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          content: Text(
            'Appointment booked with ${widget.doctorName} on ${kMonthNames[selectedDate.month - 1]} ${selectedDate.day} at ${selectedSlot!.time}.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'Done',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [accentColor, accentColorDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  'Back',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Book Appointment',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.doctorName,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionLabel({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: accentColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget buildDateCard(DateTime date) {
    final isSelected = date.day == selectedDate.day &&
        date.month == selectedDate.month &&
        date.year == selectedDate.year;

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 58,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : cardBorderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: accentColor.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  kDayNames[date.weekday - 1],
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.8)
                        : textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  kMonthNames[date.month - 1],
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.8)
                        : textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionLabel(
          icon: Icons.calendar_today_outlined,
          label: 'Select Date',
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dateList.length,
            itemBuilder: (context, index) => buildDateCard(dateList[index]),
          ),
        ),
      ],
    );
  }

  Widget buildTimeSlotCard(TimeSlotModel slot) {
    final isSelected = selectedSlot?.id == slot.id;

    Color borderColor;
    Color bgColor;
    Color timeColor;
    Color subColor;

    if (slot.isFull) {
      borderColor = cardBorderColor;
      bgColor = const Color(0xFFF7F7FA);
      timeColor = textSecondary.withValues(alpha: 0.5);
      subColor = const Color(0xFFE53935);
    } else if (isSelected) {
      borderColor = accentColor;
      bgColor = chipBackground;
      timeColor = accentColor;
      subColor = accentColor;
    } else {
      borderColor = cardBorderColor;
      bgColor = Colors.white;
      timeColor = textColor;
      subColor = textSecondary;
    }

    return GestureDetector(
      onTap: slot.isFull ? null : () => setState(() => selectedSlot = slot),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isSelected ? 1.5 : 1),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slot.time,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: timeColor,
                ),
              ),
              const SizedBox(height: 4),
              slot.isFull
                  ? Text(
                      'Full',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: subColor,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people_outline_rounded, size: 11, color: subColor),
                        const SizedBox(width: 2),
                        Text(
                          '${slot.remaining}/${slot.totalSlots}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: subColor,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionLabel(
          icon: Icons.access_time_rounded,
          label: 'Select Time',
        ),
        const SizedBox(height: 14),
        isLoadingSlots
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: accentColor),
                ),
              )
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.3,
                ),
                itemCount: slots.length,
                itemBuilder: (context, index) => buildTimeSlotCard(slots[index]),
              ),
      ],
    );
  }

  Widget buildSlotInfo() {
    if (selectedSlot == null) return const SizedBox.shrink();

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 250),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFBFDBFE)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFDBEAFE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                size: 18,
                color: Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slot Information',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${selectedSlot!.bookedCount} '
                    '${selectedSlot!.bookedCount == 1 ? 'person has' : 'people have'} '
                    'already booked this slot. '
                    'Only ${selectedSlot!.remaining} '
                    'slot${selectedSlot!.remaining == 1 ? '' : 's'} remaining!',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF3B82F6),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: selectedSlot == null || isBooking ? null : onConfirmBooking,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          disabledBackgroundColor: accentColorLight.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isBooking
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                'Confirm Booking',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildDatePicker(),
                  const SizedBox(height: 24),
                  buildTimeGrid(),
                  const SizedBox(height: 20),
                  buildSlotInfo(),
                  const SizedBox(height: 24),
                  buildConfirmButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}