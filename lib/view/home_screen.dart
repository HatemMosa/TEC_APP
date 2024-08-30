import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/helper/color_helper.dart';
import '../main.dart';
import '../viewmodel/home_view_model.dart';
import '../viewmodel/login_view_model.dart';
import 'login_screen.dart';
import 'shared_components/shared_components.dart';
import 'widgets/rounded_button.dart';
import 'widgets/rounded_container.dart';
import 'widgets/rounded_icon_button.dart';
import 'widgets/screen_size.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    double sharedWidth = ScreenSize.width(context) * 0.945;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:
            BoxDecoration(gradient: ShareComponents().getBackgroundGradient()),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 65,
              ),
              RoundedContainer(
                height: 65,
                width: sharedWidth,
                color: ColorHelper.backgroundColor3,
                borderColor: Colors.transparent,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Text("")),
                      const Text(
                        'مركز تيمز التعليمي',
                        style: TextStyle(
                          color: ColorHelper.mainFontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30, // Font size
                        ),
                      ),
                      Expanded(child: Text("")),
                      InkWell(child:Icon(Icons.logout),onTap:(){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context)=>LoginScreen()), (route) => false);
                      },),
                      SizedBox(width: 10,),
                    ],
                  ),
                ),
              ),
              Consumer<HomeViewModel>(builder: (context,provider,_){
                if(provider.orderFetchState != FetchState.loading) return Text(" ");

                return Column(
                  children: [
                    SizedBox(height: 25,),
                    CircularProgressIndicator(
                      strokeWidth: 8,
                      color: ColorHelper.backgroundColor2,
                    ),
                  ],
                );

              }),
              SizedBox(height: 15,),
              Consumer<HomeViewModel>(builder:(context,provider,_){

                if(provider.orders.isEmpty && provider.orderFetchState != FetchState.loading){
                  return Container(height:ScreenSize.height(context)*0.50,width: sharedWidth,child:Column(children: [
                    Container(height:ScreenSize.height(context)*0.30,width: sharedWidth,child: Lottie.asset(fit: BoxFit.cover,'assets/animations/noResultLottie.json')),
                    Spacer(),
                    RoundedContainer(
                      height: 58,
                      width: sharedWidth,
                      color: ColorHelper.backgroundColor3,
                      borderColor: Colors.transparent,
                      child: const Center(
                        child: Text(
                          'لم يتم العثور على أي طلبات',
                          style: TextStyle(
                            color: ColorHelper.mainFontColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 28, // Font size
                          ),
                        ),
                      ),
                    )
                  ]),);
                }

                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding:EdgeInsets.only(top: 0),itemCount: provider.orders.length,itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 0,bottom: 15),
                    child: RoundedContainer(
                        height: 150,
                        color: ColorHelper.backgroundColor3,
                        borderColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  SizedBox(height: 4,),
                                   Text(provider.orders[index].price,
                                      style: TextStyle(
                                        color: ColorHelper.mainFontColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24, // Font size
                                      )),
                                  SizedBox(height: 40,),
                                  getStage(provider.orders[index].stage),
                                ],
                              ),
                              Expanded(child: Text(""),),
                              Padding(
                                padding: const EdgeInsets.only(right:16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(height:8,),
                                    Row(
                                      children: [
                                        Text(provider.orders[index].fullId, style:TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14, // Font size
                                        )),
                                        Text(" : "+"رقم الطلب", style:TextStyle(
                                          color: ColorHelper.mainFontColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14, // Font size
                                        )),
                                      ],
                                    ),
                                    SizedBox(height: 12,),
                                    Text(provider.orders[index].createDate,style:TextStyle(
                                      color: Colors.brown.withOpacity(0.9),
                                      fontSize: 15, // Font size
                                    )),
                                    SizedBox(height: 15,),
                                    RoundedContainer(
                                      height: 33,
                                      width: 180,
                                      color: Colors.grey.withOpacity(0.2),borderColor: Colors.grey.withOpacity(0.2)
                                      ,child:Center(
                                        child: Text(
                                        "${provider.orders[index].submissionDate}"+" : "+"تاريخ التسليم",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.brown.withOpacity(0.9),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13, // Font size
                                        ),
                                        ),
                                      ) ,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                });
              }),
              SizedBox(height: 20,),
              Consumer<HomeViewModel>(builder: (context,provider,_){

                if(provider.orderFetchState == FetchState.loading) return Text(" ");
                return RoundedIconButton(icon:FaIcon(FontAwesomeIcons.rotateRight,size:25,
                    color:Colors.white) ,color: ColorHelper.backgroundColor2,titleSize: 20,width:sharedWidth,title:"تحديث قائمة الطلبات",onPressed: (){

                  LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context,listen: false);
                  HomeViewModel homeViewModel = Provider.of<HomeViewModel>(context,listen: false);
                  homeViewModel.getOrders(loginViewModel.getCurrentUserPhone());

                });
              }),

              SizedBox(height: 15,),
              Consumer<HomeViewModel>(builder: (context,provider,_){

                if(provider.orderFetchState == FetchState.loading) return Text(" ");
                return RoundedIconButton(width:sharedWidth,color: Colors.lightGreen,icon:const FaIcon(FontAwesomeIcons.whatsapp,size: 25,
                  color:Colors.white,),
                  titleSize: 20,
                  title: "طلب جديد",
                  onPressed: ()async{

                    final phone = adminPhoneNumber; // The phone number you want to send the message to
                    final message = 'السلام عليكم ، اريد طلب جديد'; // The message you want to send
                    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
                    Uri whatsapp = Uri.parse(url);

                    if (await canLaunchUrl(whatsapp)) {
                      await launchUrl(whatsapp);
                    } else {
                      throw 'Could not launch $url';
                    }

                  },);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget getStage(String stage){

    dynamic color;
    dynamic borderColor;
    dynamic textColor;

    if(stage.contains("طلب مغلق")){

      color = Colors.grey.withOpacity(0.2);
      borderColor = Colors.grey.withOpacity(0.2);
      textColor = Colors.brown.withOpacity(0.9);

    }else if(stage.contains("طلب جاهز للتسليم")){

      color = Colors.red.withOpacity(0.3);
      borderColor = Colors.red.withOpacity(0.8);
      textColor = borderColor ;

    }else{

      color = Colors.blue.withOpacity(0.3);
      borderColor = Colors.blue;
      textColor = borderColor ;

    }

    return RoundedContainer(
      height: 33,
      width: 100,
      color: color,borderColor: borderColor
      ,child:Center(
      child: Text(
        stage,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14, // Font size
        ),
      ),
    ) ,
    );

  }

}
