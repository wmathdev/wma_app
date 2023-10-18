import 'dart:convert';

import 'package:dio/dio.dart';

import 'ApiConstants.dart';

class Application{

 static dynamic forceUpdate(
      String authorization, String appVersion) async {
    var params = {"app_version": appVersion};
    final response = await ApiConstants.dioNoLog.request(
      '${ApiConstants.baseUrl}/api/application/force-update',
      options: Options(
        // headers: {
        //   'Authorization': authorization,
        //   'Accept': "application/json",
        // },
        method: 'GET',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
      data: jsonEncode(params),
    );
    return response.data;
  }

}