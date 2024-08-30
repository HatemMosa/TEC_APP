import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/helper/color_helper.dart';


class RoundedButton extends StatelessWidget{

  double width;
  double height;
  dynamic color;
  String title;
  dynamic titleColor;
  double titleSize;
  double radius;
  Function()? onPressed;

  RoundedButton({this.width = 260, this.height = 40, required this.color , this.title = "click",
    this.titleColor = ColorHelper.subMainFontColor, this.titleSize = 15, this.radius = 10, this.onPressed});

  @override
  Widget build(BuildContext context) {

    return SizedBox(height:height,width:width,child: ElevatedButton(onPressed:onPressed,child: Text(title,style: TextStyle(color: titleColor,fontSize: titleSize),)
      ,style:ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius)
        )
      ) ,),);
  }

}