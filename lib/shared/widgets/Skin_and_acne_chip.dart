import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class tagchip extends StatelessWidget {
  final String text;


  final bool isSelected;
  final VoidCallback onTap;


  const tagchip({super.key,
  required this.text,
  required this.isSelected,
  required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FilterChip(label:
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.deepPurple,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onSelected: (_)=>onTap(),
        backgroundColor: const Color(0xFFF5EDFF),
        selectedColor: Colors.deepPurple,
        showCheckmark: false,
        side: BorderSide(
          color: isSelected ? Colors.deepPurple : const Color(0xFFF5EDFF),
          width: 2,
        ),

      ),
    );

  }
}
