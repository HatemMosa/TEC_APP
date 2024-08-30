
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum LocalAuthState{
start,
failed,
success
}

class LocalAuthViewModel extends ChangeNotifier{

  late LocalAuthentication localAuth ;
  bool isLocalAuthenticated = false;
  bool isAppResumedBecauseOfLocalAuth = false;
  LocalAuthState localAuthState = LocalAuthState.start;

  LocalAuthViewModel(){
    localAuth =LocalAuthentication();
  }

  Future<void> getAvailableBiometrics()async{

    final List<BiometricType> availableBiometrics =
    await localAuth.getAvailableBiometrics();

    print("availableBiometrics :$availableBiometrics");

  }

  Future<void> authWithBiometrics()async{

    localAuthState = LocalAuthState.start;
    String message = "";

    if (Platform.isAndroid) {
      message = "الدخول باستخدام بصمة الاصبع";
    } else if (Platform.isIOS) {
      message = "الدخول باستخدام الوجه";
    }

    try {

      final bool didAuthenticate = await localAuth.authenticate(
          localizedReason: message,options: const AuthenticationOptions(stickyAuth:true,biometricOnly: true));
      print("didAuthenticate: $didAuthenticate");
      isLocalAuthenticated = didAuthenticate;

      if(!isLocalAuthenticated){
        localAuthState = LocalAuthState.failed;
      }

    } on PlatformException catch(e) {
      print(e.message);
    }

    isAppResumedBecauseOfLocalAuth = true;
    notifyListeners();
  }


}