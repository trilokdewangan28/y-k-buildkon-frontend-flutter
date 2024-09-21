import 'package:flutter/material.dart';
import 'package:get/get.dart';

const Color bluishClr = Color.fromARGB(255, 15, 80, 132);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryColor = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);


class Themes{

  static final light = ThemeData(
    primaryColor: primaryColor,
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.black,
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: const ColorScheme(
      primary: primaryColor,
      primaryContainer: bluishClr,
      secondary: yellowClr,
      secondaryContainer: yellowClr,
      surface: Color.fromARGB(255, 245, 245, 245),
      background: Color.fromARGB(255, 245, 245, 245),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );

  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.black,
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: const ColorScheme(
      primary: darkGreyClr,
      primaryContainer: darkHeaderColor,
      secondary: yellowClr,
      secondaryContainer: yellowClr,
      surface: darkGreyClr,
      background: darkGreyClr,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
      brightness: Brightness.dark,
    ),
  );

}

// Define a function to provide the background color
Color getBackgroundColor(BuildContext context) {
  return Theme.of(context).scaffoldBackgroundColor;
}

TextStyle get subHeadingStyle{
  return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.grey[400] : Colors.grey
  );
}

TextStyle get headingStyle{
  return TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Get.isDarkMode ? Colors.white : Colors.black
  );
}

TextStyle get titleStyle{
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black
  );
}

TextStyle get appbartitlestyle{
  return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Get.isDarkMode ? Colors.white : Colors.black
  );
}

TextStyle get subTitleStyle{
  return  TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Get.isDarkMode ? Colors.grey[100]: Colors.grey[600],
  );
}
