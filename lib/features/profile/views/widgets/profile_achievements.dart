import 'package:flutter/material.dart';

class AchievementsCard extends StatelessWidget {
  const AchievementsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xffE7D8F4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "🏆 Achievements",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff442266),
            ),
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [

              AchievementBadge(
                icon: Icons.local_fire_department,
                iconColor: Colors.orange,
                title: "2-week streak",
              ),

              AchievementBadge(
                icon: Icons.edit_note,
                iconColor: Color(0xffA678D5),
                title: "30 logs",
              ),

              AchievementBadge(
                icon: Icons.favorite,
                iconColor: Colors.deepPurple,
                title: "Self-care pro",
              ),

              AchievementBadge(
                icon: Icons.local_florist,
                iconColor: Color(0xffF6AFC5),
                title: "3-month member",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AchievementBadge extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  const AchievementBadge({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      child: Column(
        children: [

          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(0xffF4EEF8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xff8D7BA8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}