import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:teams_academy/view/local_auth_screen.dart';
import 'package:teams_academy/view/root_screen.dart';
import 'package:teams_academy/view/widgets/screen_size.dart';
import '../core/helper/color_helper.dart';
import '../viewmodel/home_view_model.dart';
import '../viewmodel/login_view_model.dart';
import 'shared_components/shared_components.dart';
import 'verification_screen.dart';
import 'widgets/rounded_button.dart';
import 'widgets/rounded_container.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context,listen: false);
    double height = ScreenSize.height(context);
    double width = ScreenSize.width(context);

    return Scaffold(
        body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:
        BoxDecoration(gradient: ShareComponents().getBackgroundGradient()),
        child: SingleChildScrollView(
          child: Column(children: [

            SizedBox(height: ScreenSize.height(context)*0.1,),
            CircleAvatar(
              backgroundColor: ColorHelper.backgroundColor3,
              radius: 100,
              backgroundImage:AssetImage('assets/images/logo/teamsAcademyLogo.png'), // Ensure you have a user_icon.png in your assets
            ),
          
            SizedBox(height: 40,),
            RoundedContainer(
              width: 360,
              height: 430,
              color: ColorHelper.backgroundColor3, borderColor: Colors.transparent,
              child:Column(children: [
          
                SizedBox(height: 30,),
                Text(
                  'مركز تيمز التعليمي',
                  style: TextStyle(
                    color: ColorHelper.mainFontColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 35, // Font size
                  ),
                ),
          
                SizedBox(height: 22,),
                Text(
                  'يرجي اختيار الدولة ورقم الهاتف',
                  style: TextStyle(
                    color: Colors.brown.withOpacity(0.9),
                    fontSize: 15, // Font size
                  ),
                ),
                SizedBox(height: 30,),
                InkWell(
                  onTap: (){
                    showCustomCountriesList(context);
                  },
                  child: RoundedContainer(width: 285,height: 68,color: ColorHelper.textfieldColor, borderColor: Colors.transparent,
                    child:Consumer<LoginViewModel>(
                      builder:(context,provider,_) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Text("+${provider.selectedDialCode}",style:TextStyle(
                            color:ColorHelper.mainFontColor,
                            fontSize:18, // Font size
                          ),),
                          SizedBox(width:5,),
                          SizedBox(width: 55,child: Text(provider.selectedCountryName,overflow: TextOverflow.ellipsis,)),
                          SizedBox(width:10,),
                          SizedBox(
                          height:50,
                          width:50,
                          child:CountryFlag.fromCountryCode(
                            provider.selectedCountryCode,
                            shape:const Circle(),
                          ),
                        ),
                        ],),
                    ),),
                ),
                SizedBox(height: 14,),
                RoundedContainer(width:285,height:68,color:ColorHelper.textfieldColor,borderColor:Colors.transparent,
                child:Consumer<LoginViewModel>(
                  builder:(context,provider,_) => TextField(
                  controller: provider.phoneController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: getMaxLength(context),
                  cursorColor:ColorHelper.backgroundColor2,
                  decoration:InputDecoration(
                    enabledBorder:InputBorder.none,
                    focusedBorder:UnderlineInputBorder(borderSide:BorderSide(color:ColorHelper.backgroundColor2))
          
                  ),
                )),),
                SizedBox(height: 16,),
                RoundedButton(color: ColorHelper.backgroundColor2,height: 52,width: 285,title:"متابعة",onPressed: (){

                  showLoading(context);

                  final dialCode = loginViewModel.selectedDialCode;
                  final phoneNumber = loginViewModel.phoneController.text;

                  if(loginViewModel.isLoggedIn()){

                    loginViewModel.logout((success,msg){
                      if(success){

                        loginViewModel.verifyPhoneNumber("$dialCode$phoneNumber",(){
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ في تسجيل الدخول حاول مجددا لاحقا",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));

                        },(){

                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder:(_)=>VerificationScreen()));
                        });

                      }
                    });
                  }else{

                    loginViewModel.verifyPhoneNumber("$dialCode$phoneNumber",(){
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("خطأ في تسجيل الدخول حاول مجددا لاحقا",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));

                    },(){

                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder:(_)=>VerificationScreen()));
                    });

                  }


                },)
          
              ],)),


            SizedBox(height: ScreenSize.height(context)*0.05,),
            Material(
                elevation:0.1,
                shadowColor: Colors.cyanAccent.withOpacity(0.3),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: (){

                    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context,listen: false);
                    HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context,listen: false);

                    if(loginViewModel.isLoggedIn()){

                      homeViewModel.getOrders(loginViewModel.getCurrentUserPhone());
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>RootScreen()));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("يجب تسجيل الدخول برقم الهاتف اول مرة",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,));
                    }
                  },
                  child: RoundedContainer(width: 300,height: 55,color: ColorHelper.fingerPrintBackgroundColor, borderColor: Colors.transparent,
                  child:Center(
                    child: Row(children: [
                      SizedBox(width: 13,),
                      Icon(Icons.fingerprint,color: Colors.white,size: 20,),
                      SizedBox(width: 5,),
                      Text("تفعيل الدخول بإستخدام البصمة",style: TextStyle(
                        color: ColorHelper.subMainFontColor,
                        fontSize: 20, // Font size
                      ))
                    ],),
                  ),
                  ),
                ))

            ],),
        ),
        ));
  }


  getMaxLength(context){
    Country country =  countries.firstWhere((element) => element.dialCode == Provider.of<LoginViewModel>(context,listen: false).selectedDialCode);
    print(country.maxLength);
    return country.maxLength;
  }
  
  showCustomCountriesList(BuildContext context){

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CountryListBottomSheet();
      },
    );

  }

  showLoading(context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Container(
            height: 80,
            width: 50,
            child:Column(
              children: [
                Text("جاري ارسال رقم التحقق برجاء الانتظار",style: TextStyle(color: Colors.black),),
                SizedBox(height: 5,),
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


class CountryListBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      color: ColorHelper.textfieldColor,
      child: Column(
        children: [
          // SizedBox(height: 15,),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     controller: Provider.of<LoginViewModel>(context,listen: false).searchCountryController,
          //     onChanged: Provider.of<LoginViewModel>(context,listen: false).filterCountries,
          //     decoration: InputDecoration(
          //       labelText: 'Search',
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //   ),
          // ),

          Consumer<LoginViewModel>(

            builder:(context,provider,_) => Expanded(
              child: ListView.builder(
                shrinkWrap: true,
              itemCount: provider.filteredCountries.length,
              itemBuilder: (context, index) {

                String selectedCountryCode =  provider.filteredCountries[index].code;
                String selectedDialCode = provider.filteredCountries[index].dialCode;
                String selectedCountryName = provider.filteredCountries[index].localizedName('ar');

                return InkWell(
                  onTap: (){
                    print(index);
                    provider.changeSelectedCountry(index);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: ColorHelper.textfieldColor,
                    height: 68,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text("+${selectedDialCode}",style: TextStyle(
                          color:ColorHelper.mainFontColor,
                          fontSize:18, // Font size
                        ),),
                        SizedBox(width:5,),
                        SizedBox(width: 55,child: Text(selectedCountryName,overflow: TextOverflow.ellipsis,)),
                        SizedBox(width:10,),
                        SizedBox(
                          height:50,
                          width:50,
                          child:CountryFlag.fromCountryCode(
                            selectedCountryCode,
                            shape:const Circle(),
                          ),
                        ),
                      ],),
                  ),
                );
              },
                      ),
            ),),
        ],
      ),
    );
  }

}

