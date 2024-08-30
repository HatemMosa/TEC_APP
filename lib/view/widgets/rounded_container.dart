
import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget{

  double height;
  double width;
  dynamic color;
  double radius;
  dynamic borderColor;
  double borderWidth;
  Widget? child;

  RoundedContainer({this.height=100,this.width=400,required this.color, this.radius = 10,
    required this.borderColor, this.borderWidth=2, this.child});


  @override
  Widget build(BuildContext context) {
    return  Container(height: height,width: width,
      decoration:BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius), // Rounded corners
        border: Border.all(
          color: borderColor, // Red border color
          width: borderWidth, // Border width
        ),
      ),
      child:child,);
  }

}