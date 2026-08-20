import 'package:flutter/material.dart';
import 'package:shongi/features/doctors/views/widgets/doctor_pdf_file.dart';
import 'package:shongi/features/doctors/views/widgets/doctor_header.dart';
import 'package:shongi/features/doctors/views/widgets/report_preview.dart';
import 'package:shongi/features/doctors/views/widgets/Recommended_Doctor.dart';
class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {












  final List<Doctor> doctor = [

    Doctor(
      name: "Dr Sarah Ahmed",
      speciality: "Gynecologist",
      clinic: "City Hospital",
      rating: "4.8",
      time: "Tomorrow , 10:00 AM",
      tags: ["PCOS", "Hormones" ,"jfnj"],
    ),

    Doctor(
      name: "Dr Emily",
      speciality: "Nutritionist",
      clinic: "Care Clinic",
      rating: "4.7",
      time: "Tommorrow , 1:00 PM",
      tags: ["Diet", "Weight Loss"],
    ),

    Doctor(
      name: "Dr John",
      speciality: "Dermatologist",
      clinic: "Skin Center",
      rating: "4.9",
      time: "Tommorow , 3:30 PM",
      tags: ["Acne", "Skin Care"],
    ),
  ];










  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              SizedBox(height: 10),
              DoctorHeader(),
              SizedBox(height: 20),
              DoctorPdfFile(),
              SizedBox(height: 20),
              ReportPrevieweport(),
              SizedBox(height: 28),
              RecommendedDoctor( doctor: doctor,),
              const SizedBox(height: 100),



            ],
          ),
        ),
      ),
      ),
    );
  }
}
