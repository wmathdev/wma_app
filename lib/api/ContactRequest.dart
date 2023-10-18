import 'dart:convert';

import 'package:dio/dio.dart';

import 'ApiConstants.dart';

class Contact {
  static dynamic getAllStationList(String authorization) async {
    final response = await ApiConstants.dioNoLog.request(
      '${ApiConstants.baseUrl}/api/v1/station/list',
      options: Options(
        headers: {
          'Authorization': authorization,
          'Accept': "application/json",
        },
        method: 'GET',
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
    return response.data;
  }

  static dynamic getStationContact(
      String authorization, String stationId) async {
    var params = {"station_id": stationId};
    final response = await ApiConstants.dioNoLog.request(
      '${ApiConstants.baseUrl}/api/v1/station/contact',
      options: Options(
        headers: {
          'Authorization': authorization,
          'Accept': "application/json",
        },
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
