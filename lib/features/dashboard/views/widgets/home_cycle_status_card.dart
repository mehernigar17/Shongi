import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shongi/core/theme/app_colors.dart';

class HomeCycleStatusCard extends StatelessWidget {
  const HomeCycleStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: cardBackground,

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: const Color(0xFFE9DDF8),
        ),

        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.water_drop_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),

                    const SizedBox(width: 8),
                    const Text(
                      "Cycle Status",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Text(
                  "Your Cycle\nProgress",
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Next period in ~7 days",
                  style: TextStyle(
                    color: textColor.withOpacity(0.58),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 92,
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [

                SizedBox(
                  width: 92,
                  height: 92,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 9,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),

                const SizedBox(
                  width: 92,
                  height: 92,
                  child: CircularProgressIndicator(
                    value: 18 / 28,
                    strokeWidth: 9,
                    strokeCap: StrokeCap.round,
                    color: accentColor,
                  ),
                ),

                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    shape: BoxShape.circle,
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        "18",
                        style: GoogleFonts.poppins(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),

                      Text(
                        "days",
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
