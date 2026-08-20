import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class WorkoutPlan{
  final IconData icon;
  final String title;
  final List<String>item;
  const WorkoutPlan({
  required this.icon,
  required this.title,
  required this.item,





}) ;


}


class PersonalizedplanHealthpage extends StatelessWidget {


  const PersonalizedplanHealthpage({super.key});
  static const List < WorkoutPlan> plans=[
    WorkoutPlan(icon: Icons.balance, title:"Balance and Tone" , item:["Vinyasa Flow", "Dance Cardio", "Full Body Strength"], ),
    WorkoutPlan(icon: Icons.tune, title:"Flexibility & Mindfulness", item: ["Sun Salutation", "Hip & Lower Back Stretch", "Yin Yoga"],)

  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF7C5CBF),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header here
          Text(
            "YOUR PERSONALIZED PLAN",
            style: GoogleFonts.poppins(

              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16,),
          Text(
            "Maintain your healthy physique with balanced workouts",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: plans.length,
              itemBuilder: (context, index) {
                return PlanCard(plan: plans[index]);
              },
            ),
          ),




        ],
      ),



    );
  }
}


class PlanCard extends StatelessWidget{

final WorkoutPlan plan ;

const PlanCard({required this.plan});
@override
Widget build(BuildContext context) {
  return Container(
    width: 180,
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.only(right: 10),
    decoration: BoxDecoration(
        color: const Color(0xFF9B7FD4).withOpacity(0.5),
      borderRadius: BorderRadius.circular(14),

    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //icon
        Icon(
          plan.icon,
          color: Colors.white,

        ),
        //title
        Text(
          plan.title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        //listof items
        const SizedBox(height: 8),

        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: plan.item.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Text(
                      "• ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        plan.item[index],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

      ],
    ),




  );


}
}
