import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.starSize = 20,
    this.spacing = 10,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center
    });

  final double rating;
  final double starSize;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override 
  Widget build(BuildContext context)
  {
    List<Widget> stars = [];

    int ratingProxy = (rating*2).round() - 1;
    for (int starIdx = 0 ; starIdx < 9 ; starIdx = ++starIdx)
    {
      if (starIdx % 2 == 0)
      {
        stars.add(Icon(
          starIdx > ratingProxy ? Icons.star_border_rounded : starIdx == ratingProxy ? Icons.star_half_rounded : Icons.star_rounded,
          size: starSize,
        ));
      }
      else
      {
        stars.add(SizedBox(width: spacing,));
      }

    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: stars,
    );
  }
}