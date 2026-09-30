import 'package:flutter/material.dart';
import '../../../subscriptions/subscription_gate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/doctors/models/doctor.dart';
import 'package:shongi/features/doctors/repositories/appointment_repository.dart';
import 'package:shongi/features/doctors/views/widgets/BookingPage.dart';
import 'package:shongi/features/doctors/views/widgets/doctor_message_sheet.dart';

typedef DoctorModel = Doctor;

class ViewProfile extends StatelessWidget {
  final Doctor doctor;
  final ScrollController? scrollController;
  final AppointmentRepository? appointmentRepository;

  const ViewProfile({
    super.key,
    required this.doctor,
    this.scrollController,
    this.appointmentRepository,
  });

  Widget _buildAvatar() {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFB67BFF), accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          doctor.name.split(' ').where((w) => w.isNotEmpty && !w.startsWith('Dr')).isNotEmpty
              ? doctor.name.split(' ').where((w) => w.isNotEmpty && !w.startsWith('Dr')).map((e) => e[0]).take(2).join()
              : 'DR',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatar(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                doctor.specialty,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: chipBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close_rounded, size: 18, color: accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildBringList() {
    if (doctor.bring.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Worth having ready",
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 10),
        ...doctor.bring.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  size: 15,
                  color: greenAccent,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.4,
                      color: textSecondary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: doctor.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: chipBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cardBorderColor),
          ),
          child: Text(
            tag,
            style: GoogleFonts.poppins(
              color: accentColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAbout() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cardBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            doctor.about,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              height: 1.55,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestNote() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: greenBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greenAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: greenAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Picking a time saves this as a request in your account. '
              'Confirm the actual appointment with your clinic.',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: textColor.withValues(alpha: 0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => showDoctorMessageSheet(context, doctor),
            icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16, color: accentColor),
            label: Text(
              'Message',
              style: GoogleFonts.poppins(
                color: accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: accentColorLight, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookAppointment(
                    doctorId: doctor.id,
                    doctorName: doctor.name,
                    doctorSpecialty: doctor.specialty,
                    repository: appointmentRepository,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.calendar_today_rounded, size: 16, color: Colors.white),
            label: Text(
              'Book Now',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: cardBorderColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SubscriptionGate(builder: _buildContent, autoPresent: false);
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: ListView(
        controller: scrollController,
        shrinkWrap: true,
        children: [
          _buildDragHandle(),
          _buildHeader(context),
          const SizedBox(height: 18),
          _buildTagsRow(),
          const SizedBox(height: 16),
          _buildAbout(),
          const SizedBox(height: 18),
          _buildBringList(),
          const SizedBox(height: 18),
          _buildRequestNote(),
          const SizedBox(height: 20),
          _buildActions(context),
        ],
      ),
    );
  }
}