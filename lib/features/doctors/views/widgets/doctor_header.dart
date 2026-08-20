import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorHeader extends StatelessWidget {
  const DoctorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("HealthCare Partners",
          style:TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1B4B),
          ) ,



        ),
        SizedBox(height: 3,),
        Text("Trusted specialists for PCOS support",
              style:TextStyle (
                fontWeight: FontWeight.w300,
                fontSize:13,
                color: Colors.grey[600]

              ),),
        SizedBox(height: 4),
      ],

    );
  }
}
