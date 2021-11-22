import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget loginButton(context, image, title, tColor, bColor, oColor) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: oColor),
      color: bColor,
      boxShadow: [
        BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.black12)
      ]
    ),
    width: MediaQuery.of(context).size.width * 0.8,
    height: MediaQuery.of(context).size.height * 0.05,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.023,
          child: Image(image: AssetImage(image,))
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: tColor,
            // fontWeight: FontWeight.bold,
            fontSize: 20
          )
        ),
      ],
    )
  );
}

Widget userIdLoginButton(context, title, tColor, bColor, oColor) {
  return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: oColor),
          color: bColor,
          boxShadow: [
            BoxShadow(offset: Offset(1, 1), blurRadius: 5, color: Colors.white24)
          ]
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 10),
          Text(
              title,
              style: GoogleFonts.montserrat(
                  color: tColor,
                  // fontWeight: FontWeight.bold,
                  fontSize: 20
              )
          ),
        ],
      )
  );
}
