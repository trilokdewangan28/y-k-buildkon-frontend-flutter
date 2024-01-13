import 'package:flutter/material.dart';

class RatingDisplayWidgetTwo extends StatelessWidget {
  final double rating;

  RatingDisplayWidgetTwo({required this.rating});
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    if(rating>3.0){
      color = Colors.green;
    }else{
      color = Colors.orange;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (index) => Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: index < rating.floor() ? color : Colors.grey,
              size: 20,
        ),
      ),
    );
  }
}