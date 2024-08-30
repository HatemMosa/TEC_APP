import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teams_academy/view/login_screen.dart';

import '../core/helper/color_helper.dart';
import '../viewmodel/local_auth_view_model.dart';
import 'home_screen.dart';

class LocalAuthScreen extends StatelessWidget {
  const LocalAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Provider.of<LocalAuthViewModel>(context,listen: false).authWithBiometrics();

    return Consumer<LocalAuthViewModel>(builder: (context,provider,_){

      if(provider.isLocalAuthenticated){
        return HomeScreen();
      }else{
        if(provider.localAuthState == LocalAuthState.failed){
          Future.delayed(Duration(milliseconds: 150),(){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>LoginScreen()), (route) => false);
          });
        }

        return Scaffold(body: Center(child: CircularProgressIndicator(
          strokeWidth: 8,
          color: ColorHelper.backgroundColor2,
        ),),);
      }

    },);

  }
}
