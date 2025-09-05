import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';


class ProductRating extends StatelessWidget {
  const ProductRating({super.key, required this.rating, this.iconSize = 18.0,this.avgRating});

  final int rating;
  final double? avgRating;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: avgRating?? rating.toDouble(),
      itemCount: 5,
      itemSize: 18.0,
      glow: false,
      tapOnlyMode: true,
      updateOnDrag: false,
      ignoreGestures: true,
      allowHalfRating: true,
      itemBuilder: (context, index) {
        return  const Icon(Icons.star,color: primaryColor);
      },
      onRatingUpdate: (double? rate) {},
    );
  }
}
