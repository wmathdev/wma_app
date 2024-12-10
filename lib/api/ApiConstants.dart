import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiConstants {
  static final dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
   static String baseUrl = 'https://wma-clearwater.com';
   //static String baseUrl = 'https://sandbox.wma-clearwater.com';

  static final dioNoLog = Dio();
  


}
