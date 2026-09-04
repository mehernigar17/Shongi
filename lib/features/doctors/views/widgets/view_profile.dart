import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/core/theme/app_colors.dart';
import 'package:shongi/features/doctors/models/doctor.dart';
import 'package:shongi/features/doctors/views/widgets/BookingPage.dart';

typedef DoctorModel = Doctor;

final List<Doctor> sampleDoctors = [
  const Doctor(
    id: 'doc1',
    name: 'Dr. Sarah Mitchell',
    specialty: 'Gynecologist & PCOS Specialist',
    clinic: 'City Women\'s Hospital',
    rating: 4.9,
    reviewCount: 312,
    experienceYears: 12,
    location: 'Nearby',
    feePerVisit: 85,
    tags: ['PCOS', 'Hormones', 'Fertility'],
    about:
        'Dr. Mitchell specializes in PCOS management and hormonal imbalances. She takes a holistic approach combining lifestyle interventions with evidence-based medicine.',
    nextSlot: 'Today, 3:00 PM',
  ),
];

class ViewProfile extends StatelessWidget {
  final Doctor doctor;
  final ScrollController? scrollController;

  const ViewProfile({
    super.key,
    required this.doctor,
    this.scrollController,
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

  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return const Icon(Icons.star_rounded, size: 16, color: amberAccent);
        } else if (i < rating) {
          return const Icon(Icons.star_half_rounded, size: 16, color: amberAccent);
        }
        return const Icon(Icons.star_border_rounded, size: 16, color: Color(0xFFD0D0D0));
      }),
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
              const SizedBox(height: 6),
              Row(
                children: [
                  _buildStars(doctor.rating),
                  const SizedBox(width: 6),
                  Text(
                    '${doctor.rating.toStringAsFixed(1)} (${doctor.reviewCount})',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorderColor),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: accentColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10.5,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.access_time_rounded,
          label: 'Experience',
          value: '${doctor.experienceYears} yrs',
        ),
        _buildStatCard(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: doctor.location,
        ),
        _buildStatCard(
          icon: Icons.payments_outlined,
          label: 'Fee',
          value: '\$${doctor.feePerVisit.toStringAsFixed(0)}/visit',
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

  Widget _buildNextSlot() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: greenBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: greenAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded, size: 18, color: greenAccent),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next available slot',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: greenAccent,
                ),
              ),
              Text(
                doctor.nextSlot,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat with ${doctor.name} coming soon!'),
                  backgroundColor: accentColor,
                ),
              );
            },
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
                    doctorName: doctor.name,
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: ListView(
        controller: scrollController,
        shrinkWrap: true,
        children: [
          _buildDragHandle(),
          _buildHeader(context),
          const SizedBox(height: 18),
          _buildStatsRow(),
          const SizedBox(height: 14),
          _buildTagsRow(),
          const SizedBox(height: 16),
          _buildAbout(),
          const SizedBox(height: 14),
          _buildNextSlot(),
          const SizedBox(height: 20),
          _buildActions(context),
        ],
      ),
    );
  }
}