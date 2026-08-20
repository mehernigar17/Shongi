import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shongi/features/onboarding/models/user_profile.dart';
import 'package:shongi/app/app_shell_view.dart';
import 'package:shongi/app/app_dependencies.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.dependencies});
  final AppDependencies dependencies;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final UserOnboardingData userData = UserOnboardingData();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController(text: "18");

  final TextEditingController weightController = TextEditingController(
    text: "60",
  );

  final TextEditingController heightController = TextEditingController(
    text: "165",
  );

  final TextEditingController medicationController = TextEditingController();

  final List<String> skinTypes = ["Dry", "Oily", "Combination", "Sensitive"];

  final List<String> weekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun",
  ];

  void nextPage() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xFF2D1457),
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: controller,
          keyboardType: keyboard,
          decoration: inputDecoration("Enter $title"),
        ),
      ],
    );
  }

  Widget buildChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6B4BA3) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF6B4BA3) : const Color(0xFFE7DCF8),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : const Color(0xFF6B4BA3),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF2D1457),
      ),
    );
  }

  Widget pageOne() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          Text(
            "Let’s personalize\nyour wellness ",
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D1457),
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Help us understand your body better",
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 35),

          buildTextField(title: "Name", controller: nameController),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: buildTextField(
                  title: "Age",
                  controller: ageController,
                  keyboard: TextInputType.number,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: buildTextField(
                  title: "Weight (kg)",
                  controller: weightController,
                  keyboard: TextInputType.number,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          buildTextField(
            title: "Height (cm)",
            controller: heightController,
            keyboard: TextInputType.number,
          ),

          const SizedBox(height: 22),

          buildSectionTitle("Skin Type"),

          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skinTypes.map((skin) {
              return buildChip(
                title: skin,
                selected: userData.skinType == skin,
                onTap: () {
                  setState(() {
                    userData.skinType = skin;
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          buildSectionTitle("Cycle Regularity"),

          const SizedBox(height: 12),

          Row(
            children: [
              buildChip(
                title: "Regular",
                selected: userData.cycleType == "Regular",
                onTap: () {
                  setState(() {
                    userData.cycleType = "Regular";
                  });
                },
              ),

              const SizedBox(width: 10),

              buildChip(
                title: "Irregular",
                selected: userData.cycleType == "Irregular",
                onTap: () {
                  setState(() {
                    userData.cycleType = "Irregular";
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pageTwo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),

          Text(
            "Your lifestyle ",
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D1457),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "We’ll use this to personalize recommendations",
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 35),

          buildTextField(
            title: "Previous Medications",
            controller: medicationController,
          ),

          const SizedBox(height: 22),

          buildSectionTitle("Last Period Start Date"),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );

              if (picked != null) {
                setState(() {
                  userData.lastPeriodStart = picked;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                userData.lastPeriodStart == null
                    ? "Select start date"
                    : userData.lastPeriodStart.toString().split(" ")[0],
              ),
            ),
          ),

          const SizedBox(height: 18),

          buildSectionTitle("Last Period End Date"),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );

              if (picked != null) {
                setState(() {
                  userData.lastPeriodEnd = picked;
                });
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                userData.lastPeriodEnd == null
                    ? "Select end date"
                    : userData.lastPeriodEnd.toString().split(" ")[0],
              ),
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              buildSectionTitle("Choose Your Self-Care Day"),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What is a Self-Care Day?",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2D1457),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "Your self-care day is a dedicated day each week "
                              "where we’ll encourage you to focus on wellness, "
                              "rest, emotional health, skincare, exercise, and "
                              "healthy routines ",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                height: 1.7,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: weekDays.map((day) {
              return buildChip(
                title: day,
                selected: userData.selfCareDay == day,
                onTap: () {
                  setState(() {
                    userData.selfCareDay = day;
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget resultPage() {
    userData.name = nameController.text;
    userData.age = int.tryParse(ageController.text) ?? 18;
    userData.weight = double.tryParse(weightController.text) ?? 60;
    userData.height = double.tryParse(heightController.text) ?? 165;
    userData.medications = medicationController.text;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF3ECFF),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFF6B4BA3),
              size: 55,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Your Wellness Snapshot ",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D1457),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "We’ve personalized your experience based on your lifestyle and wellness goals.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 13,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          buildResultCard(
            title: "BMI",
            value:
                "${userData.bmi.toStringAsFixed(1)} (${userData.bmiCategory})",
          ),

          buildResultCard(title: "Skin Type", value: userData.skinType),

          buildResultCard(title: "Cycle Status", value: userData.cycleType),

          buildResultCard(title: "Self-Care Day", value: userData.selfCareDay),

          SizedBox(height: 5),

          Text(
            "You can always edit these details later from your profile settings.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Widget buildResultCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          Text(
            value,
            style: GoogleFonts.poppins(
              color: const Color(0xFF2D1457),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          if (currentPage != 0)
            Expanded(
              child: OutlinedButton(
                onPressed: previousPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: Color(0xFFDCC8FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  "Back",
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF6B4BA3),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          if (currentPage != 0) const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (currentPage == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                  return;
                }
                nextPage();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4BA3),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                currentPage == 2 ? "Done" : "Continue",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget pageIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: currentPage == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: currentPage == index
                  ? const Color(0xFF6B4BA3)
                  : const Color(0xFFDCC8FF),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FC),

      body: SafeArea(
        child: Column(
          children: [
            pageIndicator(),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [pageOne(), pageTwo(), resultPage()],
              ),
            ),

            bottomButtons(),
          ],
        ),
      ),
    );
  }
}
