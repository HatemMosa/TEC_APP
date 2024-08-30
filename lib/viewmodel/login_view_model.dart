import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:local_auth/local_auth.dart';

import '../core/helper/keys_helper.dart';
import '../main.dart';

class LoginViewModel extends ChangeNotifier {

  String selectedCountryCode = "";
  String selectedDialCode = "";
  String selectedCountryName = "" ;
  TextEditingController searchCountryController = TextEditingController();
  List<Country> filteredCountries = [];
  String languageCode = 'ar';
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String verificationCode = "";
  late LocalAuthentication localAuth ;
  bool isSupportedDevice = false;

  LoginViewModel(){

    firebaseAuth.setLanguageCode('ar');
    selectStartCounty();
    List<int> index = [];
    String wantedCountries = "الإمارات العربية المتحدة السعودية قطر عمان الكويت البحرين";
    filteredCountries.addAll(countries.where((element) => wantedCountries.contains(element.localizedName("ar"))));
    localAuth = LocalAuthentication();
    localAuth.isDeviceSupported().then((value) {
      isSupportedDevice = value;
      notifyListeners();
    });


  }

  selectStartCounty(){

    int selectedIndex = 17;
    selectedCountryCode =  countries[selectedIndex].code;
    selectedDialCode = countries[selectedIndex].dialCode;
    selectedCountryName = countries[selectedIndex].localizedName('ar');

  }

  filterCountries(String query){

    filteredCountries = [];

    if(query.isNotEmpty){

      filteredCountries = countries.where((country){
       return  country.localizedName(languageCode).contains(query);
      }).toList();

    }else{
      filteredCountries.addAll(countries);
    }

    notifyListeners();
  }

  changeSelectedCountry(int index){

      selectedCountryCode =  filteredCountries[index].code;
      selectedDialCode = filteredCountries[index].dialCode;
      selectedCountryName = filteredCountries[index].localizedName('ar');

      notifyListeners();
  }

  bool isLoggedIn(){
    return firebaseAuth.currentUser != null;
  }

  String getCurrentUserId(){

    if(isLoggedIn()){
      return firebaseAuth.currentUser!.uid;
    }else{
      return "";
    }

  }

  getCurrentUserPhone(){
    return appSharedPreferences.get(KeysHelper.phoneNumberKey);
  }

  verifyPhoneNumber(String phoneNumber,onError,Function completion)async{

    print("verifyPhoneNumber");
    print(phoneNumber);
    this.phoneNumber = phoneNumber;

    if(phoneNumber.isEmpty) return;

    firebaseAuth.verifyPhoneNumber(
        phoneNumber:"+$phoneNumber",
        verificationCompleted: (phoneAuthCredential){},
        verificationFailed: (error){
          print("error ////////////// verifyPhoneNumber verificationFailed: (error) here");
          print(error);
          onError();
        },
        codeSent: (String verificationId,forceResendingToken){
          print("verificationId");
          print(verificationId);
          verificationCode = verificationId;
          completion();
        },codeAutoRetrievalTimeout: (verificationId){});
  }

  login(String smsCode,Function(bool,String) completion)async{

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: smsCode,
      );

      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      String userId = userCredential.user!.uid;
      String? deviceToken = appSharedPreferences.getString(KeysHelper.deviceTokenKey);

      firestore.collection('users').doc(userId).set({'userPhone':"$phoneNumber","userId":userId});

      if(deviceToken != null){
        if(deviceToken.isNotEmpty){
          firestore.collection('users').doc(userId).update({'device_tokens': FieldValue.arrayUnion([deviceToken])});
        }
      }

      appSharedPreferences.setString(KeysHelper.phoneNumberKey,phoneNumber);
      appSharedPreferences.setString(KeysHelper.userIDKey,userId);

      completion(true,"تم تسجيل الدخول بنجاح");

    }catch(e){
      completion(false,e.toString());
    }
  }

  logout(Function(bool,String) completion)async{

    try{

      await firebaseAuth.signOut();
      completion(true,"logout successfully!");

      String? userId = appSharedPreferences.getString(KeysHelper.userIDKey);
      if(userId != null){
        if(userId.isNotEmpty){

          String? deviceToken = appSharedPreferences.getString(KeysHelper.deviceTokenKey);
          if(deviceToken != null){
            if(deviceToken.isNotEmpty){
              firestore.collection('users').doc(userId).update({'device_tokens':FieldValue.arrayRemove([deviceToken])});
            }
          }
        }
      }

      appSharedPreferences.remove(KeysHelper.phoneNumberKey);
      appSharedPreferences.remove(KeysHelper.userIDKey);

    }catch(e){
      print(e);
      completion(false,e.toString());
    }
  }

}