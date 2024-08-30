
import 'package:flutter/material.dart';

import '../../core/helper/color_helper.dart';

class RoundedIconButton extends StatelessWidget{

  double width;
  double height;
  dynamic color;
  String title;
  dynamic titleColor;
  double titleSize;
  double radius;
  Function()? onPressed;
  Widget icon;
  MainAxisAlignment alignment;

  RoundedIconButton({this.width = 365, this.height = 45,required this.color, this.title = "click",
    this.titleColor = ColorHelper.subMainFontColor, this.titleSize = 15, this.radius = 10, required this.onPressed,required this.icon,this.alignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {

    return SizedBox(height: height,width: width,child: ElevatedButton(onPressed:onPressed,child:Row(mainAxisAlignment: alignment,children: [
      icon,
      SizedBox(width: 8,),
      Text(title,
        style: TextStyle(color:
        titleColor,fontWeight: FontWeight.bold,fontSize: titleSize),)
    ],)
      ,style:ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)
          )
      ) ,),);
  }

}