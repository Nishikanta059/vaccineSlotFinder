// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// class CountDownTimer extends StatefulWidget {
//   @override
//   _CountDownTimerState createState() => _CountDownTimerState();
// }
//
// class _CountDownTimerState extends State<CountDownTimer>
//     with TickerProviderStateMixin {
//   AnimationController controller;
//
//   String get timerString {
//     Duration duration = controller.duration * controller.value;
//     return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 5),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ThemeData themeData = Theme.of(context);
//     return Scaffold(
//       backgroundColor: Colors.white10,
//       body: AnimatedBuilder(
//           animation: controller,
//           builder: (context, child) {
//             return Stack(
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     color: Colors.blue,
//                     height:
//                         controller.value * MediaQuery.of(context).size.height,
//                   ),
//                 ),
//                 // Image.asset("assets/images/hourglasss.png"),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       AnimatedBuilder(
//                           animation: controller,
//                           builder: (context, child) {
//                             return FloatingActionButton.extended(
//                                 onPressed: () {
//                                   if (controller.isAnimating)
//                                     controller.stop();
//                                   else {
//                                     controller.reverse(
//                                         from: controller.value == 0.0
//                                             ? 1.0
//                                             : controller.value);
//                                   }
//                                 },
//                                 icon: Icon(controller.isAnimating
//                                     ? Icons.pause
//                                     : Icons.play_arrow),
//                                 label: Text(
//                                     controller.isAnimating ? "Pause" : "Play"));
//                           }),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }),
//     );
//   }
// }
