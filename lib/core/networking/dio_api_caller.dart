import 'package:dio/dio.dart';

class DioApiCaller{

  DioApiCaller._();
  static Dio? _dio;

  static Dio get instance {
    if(_dio == null){
      _dio = Dio();
      return _dio!;
    }else{
      return _dio!;
    }
  }

}