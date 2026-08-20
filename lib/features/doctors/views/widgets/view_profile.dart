import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/features/doctors/views/widgets/BookingPage.dart';

class DoctorModel {
  final String name;
  final String specialty;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final String location;
  final double feePerVisit;
  final List<String> tags;
  final String about;
  final String nextSlot;
  final String? avatarAsset;

  const DoctorModel({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.location,
    required this.feePerVisit,
    required this.tags,
    required this.about,
    required this.nextSlot,
    this.avatarAsset,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'],
      specialty: json['specialty'],
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'],
      experienceYears: json['experience_years'],
      location: json['location'],
      feePerVisit: (json['fee_per_visit'] as num).toDouble(),
      tags: List<String>.from(json['tags']),
      about: json['about'],
      nextSlot: json['next_slot'],
      avatarAsset: json['avatar_asset'],
    );
  }
}

final List<DoctorModel> sampleDoctors = [
  DoctorModel(
    name: 'Dr. Sarah Mitchell',
    specialty: 'Gynecologist & PCOS Specialist',
    rating: 4.9,
    reviewCount: 312,
    experienceYears: 12,
    location: 'Nearby',
    feePerVisit: 85,
    tags: ['PCOS', 'Hormones', 'Fertility'],
    about:
    'Dr. Mitchell specializes in PCOS management and hormonal imbalances. '
        'She takes a holistic approach combining lifestyle interventions with '
        'evidence-based medicine.',
    nextSlot: 'Today, 3:00 PM',
  ),
  DoctorModel(
    name: 'Dr. James Patel',
    specialty: 'Cardiologist & Heart Failure Specialist',
    rating: 4.7,
    reviewCount: 198,
    experienceYears: 18,
    location: '2.4 km away',
    feePerVisit: 120,
    tags: ['Heart Failure', 'Hypertension', 'ECG'],
    about:
    'Dr. Patel is a board-certified cardiologist with expertise in advanced '
        'heart failure management and interventional procedures.',
    nextSlot: 'Tomorrow, 10:00 AM',
  ),
  DoctorModel(
    name: 'Dr. Ayesha Rahman',
    specialty: 'Dermatologist & Skin Care Specialist',
    rating: 4.8,
    reviewCount: 245,
    experienceYears: 9,
    location: '1.1 km away',
    feePerVisit: 95,
    tags: ['Acne', 'Eczema', 'Skin Care'],
    about:
    'Dr. Rahman focuses on medical and cosmetic dermatology. She is known '
        'for her patient-centered care and expertise in chronic skin conditions.',
    nextSlot: 'Today, 5:30 PM',
  ),
];


class ViewProfile extends StatelessWidget {
  final DoctorModel doctor;
  final ScrollController? scrollController;

  const ViewProfile({
    super.key,
    required this.doctor,
    this.scrollController,
  });


  Widget _buildAvatar() {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFEADDFF),
      ),
      clipBehavior: Clip.hardEdge,
      child: doctor.avatarAsset != null
          ? Image.asset(doctor.avatarAsset!, fit: BoxFit.cover)
          : Center(
        child: Text(
          doctor.name.split(' ').map((e) => e[0]).take(2).join(),
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B4BA3),
          ),
        ),
      ),
    );
  }


  Widget _buildStars(double rating) {
    return Row(
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return const Icon(Icons.star, size: 14, color: Color(0xFFFFC107));
        } else if (i < rating) {
          return const Icon(Icons.star_half, size: 14, color: Color(0xFFFFC107));
        }
        return const Icon(Icons.star_border, size: 14, color: Color(0xFFD0D0D0));
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
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                doctor.specialty,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _buildStars(doctor.rating),
                  const SizedBox(width: 6),
                  Text(
                    '${doctor.rating} (${doctor.reviewCount})',
                    style: GoogleFonts.poppins(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
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
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, size: 16, color: Colors.black54),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EDFF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF6B4BA3)),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _StatsRow() {
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.access_time_rounded,
          label: 'Experience',
          value: '${doctor.experienceYears} years',
        ),
        _buildStatCard(
          icon: Icons.location_on_outlined,
          label: 'Location',
          value: doctor.location,
        ),
        _buildStatCard(
          icon: Icons.shield_outlined,
          label: 'Fee',
          value: '\$${doctor.feePerVisit.toStringAsFixed(0)}/visit',
        ),
      ],
    );
  }


  Widget _buildTagsRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: doctor.tags
          .map(
            (tag) => Chip(
          label: Text(
            tag,
            style: GoogleFonts.poppins(
              color: const Color(0xFF6B4BA3),
              fontSize: 12,
            ),
          ),
          backgroundColor: const Color(0xFFF5EDFF),
          side: const BorderSide(color: Color(0xFFF5EDFF), width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      )
          .toList(),

    );
  }


  Widget _About() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          doctor.about,
          style: GoogleFonts.poppins(
            fontSize: 13,
            height: 1.6,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }


  Widget _NextSlot() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFD6F5E8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time_rounded,
              size: 18, color: Color(0xFF2EAA6E)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Next available slot',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2EAA6E),
                ),
              ),
              Text(
                doctor.nextSlot,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _Actions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {

            },
            icon: const Icon(Icons.chat_bubble_outline,
                size: 16, color: Color(0xFF6B4BA3)),
            label: Text(
              'Message',
              style: GoogleFonts.poppins(
                color: const Color(0xFF6B4BA3),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Color(0xFFD0B8FF), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
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
                   // id: doctor.id,
                    doctorName: doctor.name,

                  ),
                ),
              );


            },
            icon: const Icon(Icons.phone_outlined, size: 16),
            label: Text(
              'Book Now',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4BA3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _DragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: ListView(
        controller: scrollController,
        shrinkWrap: true,
        children: [
          _DragHandle(),
          _buildHeader(context),
          const SizedBox(height: 20),
          _StatsRow(),
          const SizedBox(height: 16),
          _buildTagsRow(),
          const SizedBox(height: 20),
          _About(),
          const SizedBox(height: 16),
          _NextSlot(),
          const SizedBox(height: 20),
          _Actions(context),
        ],
      ),
    );
  }
}