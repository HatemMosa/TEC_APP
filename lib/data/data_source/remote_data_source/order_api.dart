
import 'dart:convert';
import '../../../core/networking/dio_api_caller.dart';
import '../../model/order.dart';

class OrderApi{

  Future<List<Order>> fetchOrders(String phoneNumber)async{

    final dio = DioApiCaller.instance;
    final url = "https://core.qntrl.com/blueprint/api/teamsacademy/customfunction/executefunction/26619000004202364?auth_type=apikey&zapikey=1001.b46bb5d9b523be24305fd8b48c896d55.74fb77c51bc73258082d3096755b99d9";
    final postData = {"Mobile": phoneNumber};

    //json.decode(response.body)

    try {

      final response = await dio.post(url,data:postData);
      print('Response status: ${response.statusCode}');
      print(response.data);
      List<String> resultData = [];
      resultData.add(response.data["result"]['output']);
      List<dynamic> ordersInJson =  json.decode("[${resultData[0]}]");
      return ordersInJson.map((e){return Order.fromJson(e);}).toList();


    } catch (e) {
      print('Error:$e');
      return [];
    }
  }
}