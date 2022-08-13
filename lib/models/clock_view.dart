


import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:timer_builder/timer_builder.dart';

import '../network/attendance_status_http_request.dart';
import '../screen/attendance/user_check_in_screen.dart';
import '../widget/calendar widgets/clock_widget.dart';
import '../widget/calendar widgets/time_widget.dart';

class ClockView extends StatefulWidget {
  @override
  _ClockViewState createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {


  @override
  void  initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 250,
          height: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 7.0, color: Color(0xffa7a9af))
              ]),
          child: CircleAvatar(
            minRadius: 50,
            maxRadius: 50,
            backgroundColor: checkStatus == 0
                ? Colors.blueAccent
                : Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                inProgress == true
                    ?Lottie.asset('assets/lottie/fingerprint.json', height: 180)
                    : const Icon(
                  Icons.fingerprint_rounded,
                  size: 180,
                  color: Colors.white,
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Text(
                  checkStatus == 0 ? "Clock In" : "clock Out",
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 250,
          height: 250,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(),
            ),
          ),
        ),


      ],
    );
  }
}

class ClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  //60 sec - 360, 1 sec - 6degree
  //12 hours  - 360, 1 hour - 30degrees, 1 min - 0.5degrees

  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var icon = Icons.fingerprint_rounded;

    var fillBrush = Paint()..color = Colors.transparent;
    var outlineBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16;

    var centerFillBrush = Paint()..color = Color(0xFF444974);

    var secHandBrush = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    var minHandBrush = Paint()
      ..shader = RadialGradient(colors: [ Colors.teal, Color(0xFF77DDFF)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 8;

    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: [Colors.redAccent, Color(0xFFC279FB)])
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 12;

    var dashBrush = Paint()
      ..color = Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 5, outlineBrush);
    var hourHandX = centerX +
        70 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerX +
        70 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + 85 * cos(dateTime.minute * 6 * pi / 180);
    var minHandY = centerX + 85 * sin(dateTime.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + 90 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerX + 90 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 12, centerFillBrush);

    var outerCircleRadius = radius;
    var innerCircleRadius = radius - 14;
    for (double i = 0; i < 360; i += 12) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerX + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + innerCircleRadius * cos(i * pi / 180);
      var y2 = centerX + innerCircleRadius * sin(i * pi / 180);
      // canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}