import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class TagChip extends StatelessWidget {
  final String text;


  const TagChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF6B4BA3),
        ),
      ),

      backgroundColor: const Color(0xFFF5EDFF),

     side: const BorderSide(
      color: Color(0xFFF5EDFF),
       width: 1,
      ),
    );
  }
}
