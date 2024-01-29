import 'package:flutter/widgets.dart';

class MyConst {
  static double deviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double deviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }


  static const double referenceWidth = 375.0;
  static const double smallTextSize = 14;
  static const double mediumSmallTextSize = 16;
  static const double mediumTextSize = 18;
  static const double mediumLargeTextSize = 20;
  static const double largeTextSize = 22;
  static const double extraLargeTextSize = 24;





}