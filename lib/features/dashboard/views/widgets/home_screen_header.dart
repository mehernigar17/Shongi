import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreenHeader extends StatelessWidget {
  final String name;

  const HomeScreenHeader({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good evening,",
                style: GoogleFonts.poppins(
                  fontSize: 13, // Smaller, sleeker greeting
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 22, // Tighter, bold name
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A24), // Deeper, softer dark tone
                ),
              ),
            ],
          ),

          // Notification Button
          Container(
            padding: const EdgeInsets.all(8), // Reduced padding
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.withOpacity(0.2), // Subtle border instead of heavy shadow
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF1A1A24),
              size: 22, // Smaller icon
            ),
          ),
        ],
      ),
    );
  }
}