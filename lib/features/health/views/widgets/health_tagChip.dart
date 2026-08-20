import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthTagchip extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback ontap;

  const HealthTagchip({
    super.key,
    required this.text,
    required this.icon,
    required this.isSelected,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: FilterChip(
        avatar: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.deepPurple,
          size: 18,
        ),
        label: Text(
          text,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.deepPurple,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => ontap(),
        showCheckmark: false,
        selectedColor: Colors.deepPurple,
        backgroundColor: const Color(0xFFF5EDFF),
        side: BorderSide(
          color: isSelected ? Colors.deepPurple : const Color(0xFFF5EDFF),
          width: 2,
        ),
      ),
    );
  }
}