import 'package:flutter/material.dart';

import 'package:shongi/core/theme/app_colors.dart';

class StatsRangeChips extends StatelessWidget {
  final int selectedIndex;

  const StatsRangeChips({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        _chip(
          title: "7 Days",
          selected: selectedIndex == 0,
        ),

        const SizedBox(width: 8),

        _chip(
          title: "1 Month",
          selected: selectedIndex == 1,
        ),

        const SizedBox(width: 8),

        _chip(
          title: "3 Months",
          selected: selectedIndex == 2,
        ),
      ],
    );
  }

  Widget _chip({
    required String title,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: selected
            ? accentColor
            : Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: selected
              ? accentColor
              : const Color(0xFFE7DCF8),
        ),
      ),

      child: Text(
        title,
        style: TextStyle(
          color: selected
              ? Colors.white
              : textColor.withOpacity(0.65),

          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
