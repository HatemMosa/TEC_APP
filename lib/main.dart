import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teams_academy/view/home_screen.dart';
import 'package:teams_academy/view/login_screen.dart';
import 'package:teams_academy/view/root_screen.dart';
import 'package:teams_academy/view/verification_screen.dart';
import 'package:teams_academy/viewmodel/home_view_model.dart';
import 'package:teams_academy/viewmodel/local_auth_view_model.dart';
import 'core/helper/keys_helper.dart';
import 'firebase_options.dart';
import 'viewmodel/login_view_model.dart';


late SharedPreferences appSharedPreferences;
String adminPhoneNumber = "+97338338792";

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await _initMain();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ChangeNotifierProvider(create: (context) => LocalAuthViewModel()),
    ],
    child: const MyApp(),
  ));
}

Future<void> _initMain()async{

  appSharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _saveDeviceToken();

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  print("Handling a background message: ${message.messageId}");
}

Future<void> _saveDeviceToken() async {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print('Device Token: $token');
  appSharedPreferences.setString(KeysHelper.deviceTokenKey,token ?? "");

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    SystemChannels.lifecycle.setMessageHandler((msg)async{
      print('SystemChannels> $msg');

      if(msg==AppLifecycleState.resumed.toString()){

        var loginProvider = Provider.of<LoginViewModel>(context,listen: false);
        if(loginProvider.isLoggedIn()){

          if(Provider.of<LocalAuthViewModel>(context,listen: false).isAppResumedBecauseOfLocalAuth == false){
          Provider.of<LocalAuthViewModel>(context,listen: false).authWithBiometrics();
          }else{
          Provider.of<LocalAuthViewModel>(context,listen: false).isAppResumedBecauseOfLocalAuth = false;
          }

        }
      }
    });

    print("rebuild");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مركز تيمز التعليمي',
      theme: ThemeData(
        colorScheme:ColorScheme.fromSeed(seedColor:Colors.deepPurple),
        useMaterial3: true,
      ),
      home:RootScreen(),
    );
  }
}
