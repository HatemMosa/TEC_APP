import 'package:flutter/material.dart';

import '../core/helper/color_helper.dart';
import 'shared_components/shared_components.dart';
import 'widgets/rounded_button.dart';
import 'widgets/rounded_container.dart';

class NotifyUsersScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration:
          BoxDecoration(gradient:ShareComponents().getBackgroundGradient()),
          child: Column(
            children: [
              SizedBox(
                height: 130,
              ),

              RoundedContainer(
                height: 65,
                width: 350,
                color: ColorHelper.backgroundColor3,
                borderColor: Colors.transparent,
                child: const Center(
                  child: Text(
                    'تنبيه المستخدمين',
                    style: TextStyle(
                      color: ColorHelper.mainFontColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30, // Font size
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              RoundedContainer(
                width: 350,
                height: 400,
                color: ColorHelper.backgroundColor3,borderColor: Colors.transparent,
                child: Column(children:[
                  SizedBox(height: 60,),
                  SizedBox(
                    height: 50,
                    width: 300,
                    child: TextField(decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.cyanAccent.withOpacity(0.2),
                      focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                          ,borderSide: BorderSide(color: Colors.transparent)
                      ) ,
                      enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                          ,borderSide: BorderSide(color: Colors.transparent)
                     ),
                      hintText:"عنوان التنبيه",
                    ),),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    height: 130,
                    width: 300,
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.cyanAccent.withOpacity(0.2),
                      focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                          ,borderSide: BorderSide(color: Colors.transparent)
                      ) ,
                      enabledBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                          ,borderSide: BorderSide(color: Colors.transparent)
                      ),
                      hintText:"ماذا تريد ان تنبه المستخدمين",
                    ),),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(height: 20,),
                  RoundedButton(color: ColorHelper.backgroundColor2,title:"إرسال",onPressed: (){},)

                ],),
              ),
            ],
          ),
        ));
  }

}