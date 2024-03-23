// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
//
// class PieChartSample3 extends StatefulWidget {
//   final List<DataItemPieChart> data;
//
//   const PieChartSample3({Key? key, required this.data}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => PieChartSample3State();
// }
//
// class PieChartSample3State extends State<PieChartSample3> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   int touchedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.data.isEmpty) {
//       return SizedBox(
//         height: 400,
//         width: 400,
//         child: Center(
//           child: Tooltip(
//             message: "Chưa có dữ liệu cho mốc thời gian này!",
//             child: noDataImage,
//           ),
//         ),
//       );
//     }
//     return AspectRatio(
//       aspectRatio: 1,
//       child: AspectRatio(
//         aspectRatio: 1,
//         child: Column(
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: PieChart(
//                 PieChartData(
//                   pieTouchData: PieTouchData(
//                     touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                       setState(() {
//                         if (!event.isInterestedForInteractions ||
//                             pieTouchResponse == null ||
//                             pieTouchResponse.touchedSection == null) {
//                           touchedIndex = -1;
//                           return;
//                         }
//                         touchedIndex = pieTouchResponse
//                             .touchedSection!.touchedSectionIndex;
//                       });
//                     },
//                   ),
//                   borderData: FlBorderData(
//                     show: false,
//                   ),
//                   sectionsSpace: 0,
//                   centerSpaceRadius: 0,
//                   sections: showingSections(),
//                 ),
//               ),
//             ),
//             marginTop20,
//             widget.data.isNotEmpty
//                 ? SizedBox(
//                     height: 200,
//                     child: ListView.builder(
//                         itemCount: widget.data.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             dense: true,
//                             title: Row(
//                               children: [
//                                 Container(
//                                     color: widget.data[index].color,
//                                     height: 20,
//                                     width: 20),
//                                 marginRight5,
//                                 Marquee(
//                                   direction: Axis.horizontal,
//                                   textDirection: TextDirection.ltr,
//                                   animationDuration: const Duration(seconds: 1),
//                                   backDuration:
//                                       const Duration(milliseconds: 4000),
//                                   pauseDuration:
//                                       const Duration(milliseconds: 1000),
//                                   directionMarguee:
//                                       DirectionMarguee.TwoDirection,
//                                   child: Text(
//                                     widget.data[index].title,
//                                     style: textStyleLabel14,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             trailing: Text(
//                               Utils.formatCurrency(widget.data[index].value),
//                               style: textStyleLabel14,
//                             ),
//                           );
//                         }),
//                   )
//                 : const SizedBox(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<PieChartSectionData> showingSections() {
//     return List.generate(widget.data.length, (i) {
//       final isTouched = i == touchedIndex;
//       final fontSize = isTouched ? 20.0 : 16.0;
//       final radius = isTouched ? 110.0 : 100.0;
//       final widgetSize = isTouched ? 55.0 : 40.0;
//       const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
//
//       return PieChartSectionData(
//         color: widget.data[i].color,
//         value: widget.data[i].value.toDouble(),
//         title: widget.data[i].title,
//         radius: radius,
//         titleStyle: TextStyle(
//           fontSize: fontSize,
//           fontWeight: FontWeight.bold,
//           color: const Color(0xffffffff),
//           shadows: shadows,
//         ),
//         badgeWidget: widget.data[i].icon != ""
//             ? _Badge(
//                 widget.data[i].icon,
//                 size: widgetSize,
//                 borderColor: AppColors.contentColorBlack,
//               )
//             : const SizedBox(),
//         badgePositionPercentageOffset: .98,
//       );
//     });
//   }
// }
//
// class _Badge extends StatelessWidget {
//   const _Badge(
//     this.image, {
//     required this.size,
//     required this.borderColor,
//   });
//   final String image;
//   final double size;
//   final Color borderColor;
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: PieChart.defaultDuration,
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: borderColor,
//           width: 2,
//         ),
//         boxShadow: <BoxShadow>[
//           BoxShadow(
//             color: Colors.black.withOpacity(.5),
//             offset: const Offset(3, 3),
//             blurRadius: 3,
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.all(2),
//       child: Center(
//         child: image != ""
//             ? CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.black,
//                 backgroundImage: NetworkImage(image),
//               )
//             : CircleAvatar(
//                 child: Image.asset(
//                   defaultFoodImageString,
//                   width: 20,
//                   height: 20,
//                 ),
//               ),
//       ),
//     );
//   }
// }
//
// class DataItemPieChart {
//   Color color;
//   double value;
//   String title;
//   String icon;
//   String id;
//
//   DataItemPieChart(
//       {required this.color,
//       required this.value,
//       required this.title,
//       required this.id,
//       required this.icon});
// }
