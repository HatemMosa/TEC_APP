
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/home_view_model.dart';
import '../viewmodel/login_view_model.dart';
import 'local_auth_screen.dart';
import 'login_screen.dart';

class RootScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    print("rebuild RootScreen");

    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context,listen: false);
    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context,listen: false);

    if(loginViewModel.isLoggedIn()){
      print("is logged");
      homeViewModel.getOrders(loginViewModel.getCurrentUserPhone());
      return LocalAuthScreen();

    }else{
      return LoginScreen();
    }

  }

}