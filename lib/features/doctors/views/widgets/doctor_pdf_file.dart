import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class DoctorPdfFile extends StatefulWidget {
  const DoctorPdfFile({super.key});

  @override
  State<DoctorPdfFile> createState() => _DoctorPdfFileState();
}

class _DoctorPdfFileState extends State<DoctorPdfFile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,

     child:
     Container(

      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
        begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:[
              Color(0xFF2E0854),
              Color(0xFF6A1B9A),
              Color(0xFFBA68C8),
            ],
             )



      ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(

             padding:  EdgeInsets.only(left: 15, top: 15, right: 15),
             child: Row(
             children: [
               Container(
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.2),
                   borderRadius: BorderRadius.circular(10),
                 ),
                 //child: Icon(Icons.description,size: 37,color: Colors.white,),
                  child:  Padding(
                     padding: EdgeInsets.all(8),
                     child: Icon(
                       Icons.description,
                       size: 37,
                       color: Colors.white,
                     ),
                   )
               ),
               SizedBox(width: 15,),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("Health Report",
                   style:GoogleFonts.poppins(
                       fontSize: 22,
                       fontWeight: FontWeight.bold,
                        color: Colors.white

                   ),),
                   Text("Share With Your Doctor",
                     style: GoogleFonts.poppins(
                         fontWeight: FontWeight.w300,
                         fontSize:13,
                         color: Colors.white70

                     ),)
                 ]

               )
             ],

           ),
           ),
           SizedBox(height: 13),
           Center(
          child:  SizedBox(
             width: 350,
             height: 40,

             child: Container(
               padding: EdgeInsets.all(5),
               alignment: Alignment.center,
               decoration: BoxDecoration(
                 color: Colors.white.withOpacity(0.18),
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(
                   color: Colors.white,
                   width: 1,
                 ),
               ),

               child:  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(
                       Icons.download,
                       color: Colors.white,
                       size: 24,
                     ),
                     SizedBox(width: 4),
                     Text("Generate Pdf Report",
                       style: GoogleFonts.poppins(
                           fontSize: 12,
                           fontWeight: FontWeight.bold,
                           color: Colors.white
                       ),
                     ),
                   ]
               ),

             ),
           )
           ),

         ],
       ),
      ),
    );

  }
}
