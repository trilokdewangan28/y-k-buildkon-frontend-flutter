import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
class RatingDisplayWidget extends StatelessWidget {
  final double rating;
  RatingDisplayWidget({required this.rating});
  Color color = Colors.grey;

  @override
  Widget build(BuildContext context) {
    if(rating<=2.0){
      color = Colors.red;
    }else if(rating>2.0 && rating <4.0){
      color = Colors.orange;
    }else{
      color = Colors.green;
    }
    return GestureDetector(
      child: RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: color,
          ),
          onRatingUpdate:(rating){},
      ),
    );
  }
}
