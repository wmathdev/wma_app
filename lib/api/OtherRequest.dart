import 'package:dio/dio.dart';

import 'ApiConstants.dart';

class OtherRequest {
  static dynamic news() async {
    final response = await ApiConstants.dioNoLog.request(
      'https://wma.or.th/wp-json/wp/v2/posts?categories=10,11&per_page=100',
      options: Options(
        headers: {
          'Accept': "application/json",
        },
        method: 'GET',
      ),
    );
    return response.data;
  }

  static dynamic newsImage(String url) async {
    final response = await ApiConstants.dioNoLog.request(
      url,
      options: Options(
        headers: {
          'Accept': "application/json",
        },
        method: 'GET',
      ),
    );
    return response.data;
  }

  static dynamic statistic(String period) async {
    
    final response = await ApiConstants.dioNoLog.request(
      '${ApiConstants.baseUrl}/api/v1/statistic',
      queryParameters: {'period':period},
      options: Options(
        headers: {
          'Accept': "application/json",
        },
        method: 'GET',
      ),
    );
    return response.data;
  }
}
