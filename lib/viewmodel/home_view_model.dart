import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../core/helper/keys_helper.dart';
import '../data/data_source/remote_data_source/order_api.dart';
import '../data/model/order.dart';
import '../main.dart';

enum FetchState{
  start,
  loading,
  success,
  failed,
}
class HomeViewModel extends ChangeNotifier{

  List<Order> orders = [];
  FetchState orderFetchState  = FetchState.start;

  HomeViewModel(){

    initFirebaseNotifications();
    //var order =  Order(createDate: "createDate", stage: "stage", fullId: "fullId", price: "price", submissionDate: "submissionDate");
    //orders.add(order);
    //getOrders("97366333390");

  }

  initFirebaseNotifications()async{

    print("init");
    await _requestNotificationPermissions();
    _onMessageForeground();

  }

  getOrders(String phoneNumber)async{

    orderFetchState = FetchState.loading;
    orders = await OrderApi().fetchOrders(phoneNumber);

    int flag = 0;
    if(orders.isNotEmpty){

      orders.forEach((element) {
        if(element.phoneNumber != getCurrentUserPhone()){
          flag = 1;
        }

      });

      print(flag);

      if(flag == 1 && canStopCallApi() == false){
        orders = [];
        await getOrders(phoneNumber);
      }else if(flag == 1){
        orders = [];
      }

    }

    appSharedPreferences.remove(KeysHelper.apiCallForOrder);
    orderFetchState = FetchState.success;
    notifyListeners();
  }

  _onMessageForeground(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

   Future<void> _requestNotificationPermissions()async{

    try {

      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else
      if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

    }catch(e){
      print(e.toString());
    }
  }

  getCurrentUserPhone(){
    return appSharedPreferences.get(KeysHelper.phoneNumberKey);
  }

  bool canStopCallApi(){

    var apiCallVal = appSharedPreferences.getInt(KeysHelper.apiCallForOrder);
    if(apiCallVal == null){
      appSharedPreferences.setInt(KeysHelper.apiCallForOrder,1);
      return false;
    }else{
      if(apiCallVal < 5){
        apiCallVal++;
        appSharedPreferences.setInt(KeysHelper.apiCallForOrder,apiCallVal);
        return false;
      }else{
        appSharedPreferences.remove(KeysHelper.apiCallForOrder);
        return true;
      }
    }

  }
}