import 'package:flutter/material.dart';
import 'package:JAY_BUILDCON/config/Constant.dart';

class RatingDisplayWidgetTwo extends StatelessWidget {
  final double rating;

  RatingDisplayWidgetTwo({super.key, required this.rating});
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    double fontSizeScaleFactor = MyConst.deviceWidth(context)/MyConst.referenceWidth;
    if(rating>3.0){
      color = Colors.green;
    }else{
      color = Colors.orange;
    }
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
              (index) => Icon(
            index < rating.floor() ? Icons.star : Icons.star_border,
            color: index < rating.floor() ? color : Colors.grey,
            size: MyConst.mediumTextSize*fontSizeScaleFactor,
          ),
        ),
      ),
    );
  }
}