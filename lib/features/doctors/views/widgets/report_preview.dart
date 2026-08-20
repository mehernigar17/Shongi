import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPrevieweport extends StatefulWidget {
  const ReportPrevieweport({super.key});

  @override
  State<ReportPrevieweport> createState() => _ReportPrevieweportState();
}

class _ReportPrevieweportState extends State<ReportPrevieweport> {
  @override
  Widget build(BuildContext context) {











    return SizedBox(
      width: double.infinity,
     //height: 400,


     child:  Container(

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow:[
          BoxShadow(
          color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
            offset:Offset (0,8)

        ),


         ]
      ),

         child: Padding(
           padding: EdgeInsets.symmetric(
             horizontal: 20,
             vertical: 20,
           ),
       child:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
       children: [
       Row(


       children: [
         Icon(Icons.summarize
         ,color:Color(0xFF6B4BA3)
           ,),
         SizedBox(width: 9,),
         Text("Report Preview",
         style: TextStyle(
           color: Color(0xFF1E1B4B),
           fontSize: 14,
           fontWeight: FontWeight.bold,
         ),),
         SizedBox(width: 65,),
         Container(
           padding: EdgeInsets.symmetric(
             horizontal: 10,
             vertical: 4,
           ),
           height: 20,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(10),
             color:Color(0xFFF5EDFF),

           ),
         child: Text("Last Updated Today",
         style: TextStyle(
           fontSize: 10,
           fontWeight: FontWeight.w300,
           color: Color( 0xFF6B21A8)
         ),
         ),
         ),




       ],
       ),
         SizedBox(height: 20),
         // CARD 1
         buildReportCard(
           "Cycle History",
           "Irregular — avg 30 days",
            Icons.sync,
         ),

         SizedBox(height: 12),

         // CARD 2
         buildReportCard(
           "Main Symptoms",
           "Fatigue, mood swings",
           Icons.notes,
         ),

         SizedBox(height: 12),

         // CARD 3
         buildReportCard(
           "Lifestyle",
           "Moderate activity, avg 7.1h sleep",
           Icons.nature,
         ),

         SizedBox(height: 12),

         // CARD 4
         buildReportCard(
           "Last 30 Days",
           "28 logs completed",
           Icons.bar_chart,
         ),












       ]
       )

    )




     ),
















    );


  }
  //REUSABLE CARD WIDGET
  Widget buildReportCard(
      String title,
      String value,
      IconData icon,
      ){
    return Container(
      padding: EdgeInsets.all(14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:Color(0xFFF5EDFF),

      ),













      child: Row(
        children: [

          // ICON BOX
          Container(
            height: 42,
            width: 42,
            alignment: Alignment.center,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              size: 18,
              color: Color(0xFF6B4BA3),
            ),
          ),

          SizedBox(width: 12),

          // TEXT SECTION
          Expanded(
            child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFF2D3142),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          )
        ],

      ),
    );
  }



  }

