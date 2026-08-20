import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shongi/features/health/views/widgets/exercise_modal.dart';
 void showExerciseDetailSheet(BuildContext context,ExerciseModel exercise)
 {
   showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       backgroundColor: Colors.transparent,
       barrierColor: Colors.black.withOpacity(.35),
       builder: (_) => exerciseDetailsSheet(
           exercise: exercise)
   );



 }

class exerciseDetailsSheet extends StatefulWidget {
   final ExerciseModel exercise;
  const exerciseDetailsSheet({super.key , required this.exercise});

  @override
  State<exerciseDetailsSheet> createState() => _exerciseDetailsSheetState();
}

class _exerciseDetailsSheetState extends State<exerciseDetailsSheet> {
   bool isPlaying=false;
   YoutubePlayerController?playerController;//player controller variable which will store object of ytplayer controller
   void startVideo(){
     playerController=YoutubePlayerController(
       initialVideoId: widget.exercise.youtubeId,
       flags: const YoutubePlayerFlags(
         autoPlay: true,
         mute: false,
       )

     );
     setState((){
       isPlaying=true;

     });
   }


   @override
   void dispose() {
     playerController?.dispose();
     super.dispose();
   }

   Widget build(BuildContext context) {


    return DraggableScrollableSheet(
      initialChildSize: .85,
      minChildSize: .5,
      maxChildSize: .95,
        builder: (context,scrollController){
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffFAF7FE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
            children: [
              buildDragHandleandClose(),
              const SizedBox(height: 14),
              buildTitleRow(),
              const SizedBox(height: 4),
              Text(
                widget.exercise.category,
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              buildStateRow(),
              const SizedBox(height: 16),
              buildAboutSection(),
              const SizedBox(height: 16),
              _buildBenefitsSection(),
              const SizedBox(height: 24),
              if (isPlaying) buildVideoPlayer() else _buildWatchTutorialButton(),






            ],

          ),


        );
        }


    );



    }
    Widget buildDragHandleandClose() {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xffE3D6F5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xffEEE4F8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                    Icons.close, size: 18, color: Colors.deepPurple),
              ),
            ),

          )
        ],
      );
    }
     Widget buildTitleRow() {
       return Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Expanded(
             child: Text(
               widget.exercise.title,
               style: GoogleFonts.poppins(
                 fontSize: 24,
                 fontWeight: FontWeight.w700,
                 color: const Color(0xff27247D),
               ),
             ),
           ),
           Container(
             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
             decoration: BoxDecoration(
               color: const Color(0xffD5F2DF),
               borderRadius: BorderRadius.circular(20),
             ),
             child: Text(
               widget.exercise.level,
               style: GoogleFonts.poppins(
                 color: const Color(0xff006B4E),
                 fontWeight: FontWeight.w600,
               ),
             ),
           ),
         ],
       );
     }


     Widget buildStateRow(){

     return Row(
       children: [
         Expanded(child: buildStatCard(
             icon: Icons.access_time_outlined,
             iconColor: Colors.deepPurple,
             label: "Duration",
             value: widget.exercise.duration
         )),
         const SizedBox(width: 14),
         Expanded(child: buildStatCard(
           icon: Icons.local_fire_department_outlined,
           iconColor: Colors.pink,
           label: "Calories",
           value: widget.exercise.calories,
         )),

       ],
     );







     }
   Widget buildStatCard({
     required IconData icon,
     required Color iconColor,
     required String label,
     required String value,
    }){
     return Container(
       padding: const EdgeInsets.all(14),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(16),
         border: Border.all(color: const Color(0xffE9DDF9)),
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               Icon(icon, size: 16, color: iconColor),
               const SizedBox(width: 6),
               Text(
                 label,
                 style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
               ),
             ],
           ),
           const SizedBox(height: 4),
           Text(
             value,
             style: GoogleFonts.poppins(
               fontWeight: FontWeight.w700,
               fontSize: 16,
               color: const Color(0xff27247D),
             ),
           ),
         ],
       ),
     );
   }
   Widget buildAboutSection() {
     return Container(
         width: double.infinity,
         padding: const EdgeInsets.all(16),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(18),
           border: Border.all(color: const Color(0xffE9DDF9)),
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               "ABOUT THIS EXERCISE",
               style: GoogleFonts.poppins(
                 fontSize: 12,
                 fontWeight: FontWeight.w700,
                 color: Colors.deepPurple,
                 letterSpacing: .5,
               ),
             ),
             const SizedBox(height: 8),
             Text(
               widget.exercise.about,
               style: GoogleFonts.poppins(
                 fontSize: 15,
                 color: const Color(0xff27247D),
                 height: 1.5,
               ),
             ),
           ],
         )
         );


   }





   Widget _buildBenefitsSection() {
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(18),
         border: Border.all(color: const Color(0xffE9DDF9)),
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             "KEY BENEFITS",
             style: GoogleFonts.poppins(
               fontSize: 12,
               fontWeight: FontWeight.w700,
               color: Colors.deepPurple,
               letterSpacing: .5,
             ),
           ),
           const SizedBox(height: 10),
           ...widget.exercise.benefits.map((benefit) => Padding(
             padding: const EdgeInsets.only(bottom: 8),
             child: Row(
               children: [
                 const Icon(Icons.star_border, size: 18, color: Colors.deepPurple),
                 const SizedBox(width: 8),
                 Text(
                   benefit,
                   style: GoogleFonts.poppins(
                     fontSize: 15,
                     color: const Color(0xff27247D),
                   ),
                 ),
               ],
             ),
           )),
         ],
       ),
     );
   }

   Widget _buildWatchTutorialButton() {
     return SizedBox(
       width: double.infinity,
       child: ElevatedButton(
         onPressed: startVideo,
         style: ElevatedButton.styleFrom(
           elevation: 0,
           backgroundColor: const Color(0xffE6312E),
           foregroundColor: Colors.white,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(16),
           ),
         ),
         child: Padding(
           padding: const EdgeInsets.symmetric(vertical: 16),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.smart_display_rounded, size: 22),
               const SizedBox(width: 10),
               Text(
                 "Watch Tutorial on YouTube",
                 style: GoogleFonts.poppins(
                   fontSize: 16,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

   Widget buildVideoPlayer() {
     return ClipRRect(
       borderRadius: BorderRadius.circular(18),
       child: YoutubePlayer(
         controller: playerController!,
         showVideoProgressIndicator: true,
         progressIndicatorColor: Colors.deepPurple,
       ),
     );
   }





 }





















