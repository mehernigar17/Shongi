import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shongi/features/doctors/views/widgets/view_profile.dart';
import 'package:shongi/shared/widgets/tag_chip.dart';

class Doctor {
  final String name;
  final String speciality;
  final String clinic;
  final String rating;
  final String time;
  final List<String> tags;

  Doctor({
    required this.name,
    required this.speciality,
    required this.clinic,
    required this.rating,
    required this.time,
    required this.tags,
  });
}

class RecommendedDoctor extends StatelessWidget {
  final List<Doctor> doctor;

  const RecommendedDoctor({super.key, required this.doctor});

  void _openProfile(BuildContext context, Doctor doc) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.98,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ViewProfile(
                doctor: sampleDoctors[0],
                scrollController: scrollController,
              ),
                     );
          },
                 );
      },
              );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(blurRadius: 10, color: Colors.black12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 25),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E1B4B),
                      ),
                    ),
                    Text(
                      doc.speciality,
                      style:  GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.grey.shade600),
                        const SizedBox(width: 5),
                        Text(
                          doc.clinic,
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                                 ),
                        ),
                                 ],
                    ),
                  ],
                       ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.orange),
                  Text(doc.rating),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 7,
            children: doc.tags.map((tag) => TagChip(text: tag)).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                          ),
                child: Text(
                  doc.time,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF166534)),
                ),
              ),
              TextButton(
                onPressed: () => _openProfile(context, doc),
                child: const Row(
                  children: [
                    Text(
                      "View profile",
                      style: TextStyle(color: Color(0xFF6B4BA3)),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 14),
                           ],
                ),
                     ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommended Specialist",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF1E1B4B),
          ),
        ),
        const SizedBox(height: 16),


        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctor.length,
          itemBuilder: (context, index) =>
              _buildDoctorCard(context, doctor[index]),
        ),
      ],
    );
  }
}
