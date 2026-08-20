import 'package:flutter/material.dart';
import 'package:shongi/core/theme/app_colors.dart';

class LogCard extends StatelessWidget {
  const LogCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8F3FF),
            Color(0xFFF1E7FF),
          ],
        ),

        borderRadius: BorderRadius.circular(30),

        border: Border.all(
          color: accentColor.withOpacity(0.2),
        ),

        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.edit_note_rounded,
                  color: accentColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Log Your Day",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Track symptoms, mood, food & sleep",
                      style: TextStyle(
                        color: textColor.withOpacity(0.58),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: const [
              _CategoryButton(
                icon: Icons.bedtime_rounded,
                label: "Sleep",
              ),
              _CategoryButton(
                icon: Icons.sentiment_satisfied_alt_rounded,
                label: "Mood",
              ),
              _CategoryButton(
                icon: Icons.restaurant_rounded,
                label: "Food",
              ),
              _CategoryButton(
                icon: Icons.favorite_border_rounded,
                label: "Health",
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                print("Start Logging");
              },

              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: accentColor,
                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    "Start Logging",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(width: 6),

                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),

        padding: const EdgeInsets.symmetric(vertical: 13),

        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.72),

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: Colors.white.withOpacity(0.9),
          ),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              color: accentColor,
              size: 18,
            ),

            const SizedBox(height: 6),

            Text(
              label,
              style: TextStyle(
                color: textColor.withOpacity(0.78),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
