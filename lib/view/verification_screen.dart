import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/helper/color_helper.dart';
import '../viewmodel/home_view_model.dart';
import '../viewmodel/login_view_model.dart';
import 'home_screen.dart';
import 'shared_components/shared_components.dart';
import 'widgets/rounded_button.dart';
import 'widgets/rounded_container.dart';

class VerificationScreen extends StatefulWidget {

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();

}

class _VerificationScreenState extends State<VerificationScreen> {


  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late LoginViewModel loginViewModel;
  String smsCode = "";

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _nextField(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {

    loginViewModel = Provider.of<LoginViewModel>(context,listen:false);

    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration:
          BoxDecoration(gradient: ShareComponents().getBackgroundGradient()),
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 80,),
              // Row(children: [
              //   SizedBox(width: 15,),
              //   IconButton(onPressed: (){
              //     Navigator.of(context).pop();
              //   },icon: Icon(Icons.cancel,color: Colors.black,),)
              // ],),
              SizedBox(height: 40,),
            
              CircleAvatar(
                backgroundColor: ColorHelper.backgroundColor3,
                radius: 80,
                backgroundImage:AssetImage('assets/images/logo/teamsAcademyLogo.png'), // Ensure you have a user_icon.png in your assets
              ),
            
              SizedBox(height: 63,),
              RoundedContainer(
                  width: 360,
                  height: 350,
                  child:Column(children: [
                  
                    SizedBox(height: 40,),
                    Text(
                      'مركز تيمز التعليمي',
                      style: TextStyle(
                        color: ColorHelper.mainFontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 35, // Font size
                      ),
                    ),
                  
                    SizedBox(height: 40,),
                    Text(
                      'يرجي ادخال رمز التحقق',
                      style: TextStyle(
                        color: Colors.brown.withOpacity(0.9),
                        fontSize: 15, // Font size
                      ),
                    ),
                    SizedBox(height: 40,),
                    SizedBox(
                      width: 280,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return Container(
                            color: ColorHelper.textfieldColor,
                            width: 35,
                            height: 35,
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: InputDecoration(enabledBorder: InputBorder.none,counterText: '',),
                              onChanged: (value) => _nextField(value, index),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 40,),
                    RoundedButton(color:ColorHelper.backgroundColor2,height: 52,width: 290,title:"تأكيد",onPressed: ()=>login(context),)
                  ],) ,
                  color: ColorHelper.backgroundColor3, borderColor: Colors.transparent),
            ],),
          ),
        ));
  }

  login(BuildContext context){

    showLoading(context);

    _controllers.forEach((element) {
      smsCode += element.text ;
    });

    loginViewModel.login(smsCode,(success,msg){


      if(success){

        Provider.of<HomeViewModel>(context,listen: false).getOrders(loginViewModel.phoneNumber);
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder:(_)=>HomeScreen()));

      }else{

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }

    });
  }

  showLoading(context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 120,
            width: 80,
            child: Column(
              children: [
                Text("جاري التحقق من الرقم الذي ادخلته برجاء الانتظار",textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                SizedBox(height: 12,),
                Center(child: CircularProgressIndicator(
                  strokeWidth: 8,
                  color: ColorHelper.backgroundColor2,
                )),
              ],
            ),
          ),
        );
      },
    );
  }

}




