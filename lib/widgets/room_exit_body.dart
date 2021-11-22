import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget roomExitBody(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 100),
      Center(
        child: Text(
          'Room Exit',
          style: GoogleFonts.montserrat(
            fontSize: MediaQuery.of(context).size.width * 0.1,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(offset: Offset(1, 2), blurRadius: 3, color: Colors.black)
            ]
          ),
        ),
      ),
      SizedBox(height: 20),
      Center(
        child: Text(
          '방탈출 게임',
          style: GoogleFonts.montserrat(
              fontSize: MediaQuery.of(context).size.width * 0.08,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(offset: Offset(1, 2), blurRadius: 3, color: Colors.black)
              ]
          ),
        ),
      ),
    ],
  );
}