import 'package:flutter/material.dart';


const Color bluishClr = const Color.fromARGB(255, 13, 70, 155);
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;


const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);

const primaryColor = bluishClr;
const primaryColorLight = whiteColor;
const primaryColorDark = blackColor;
const successColor = Colors.green;
const errorColor = Colors.red;

class Themes{

  static final light = ThemeData(
    primaryColor: bluishClr,
    primaryColorLight: whiteColor,
    primaryColorDark: blackColor,
    brightness: Brightness.light,
    useMaterial3: true,
  );

  static final dark =  ThemeData(
    primaryColor: darkGreyClr,
    primaryColorLight: Colors.white70,
    primaryColorDark: Colors.black,
    brightness: Brightness.dark,
    useMaterial3: true,
  );

}
