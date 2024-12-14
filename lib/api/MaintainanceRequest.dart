import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wma_app/api/ApiConstants.dart';

class Maintainancerequest {
  static dynamic getTypeEqList(String authorization, int stationid) async {
    var params = {'station_id': stationid};

    final response = await ApiConstants.dioNoLog
        .get('${ApiConstants.baseUrl}/api/v1/maintenance/station',
            queryParameters: params,
            options: Options(
              headers: {
                'Authorization': authorization,
                'Accept': "application/json",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return response.data;
  }

  static dynamic revisionDocument(
    String authorization,
    int docId,
    String detail,
    List<String> file,
  ) async {
    final formData = FormData.fromMap({
      'id': docId,
      'detail': detail,
      'files': jsonEncode(file),
    });

    print(formData.fields);
    final response = await ApiConstants.dioNoLog
        .post('${ApiConstants.baseUrl}/api/v1/maintenance/update',
            data: formData,
            options: Options(
              headers: {
                'Authorization': authorization,
                'Accept': "application/json",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return response.data;
  }

  static dynamic getStationlist(String authorization) async {
    final response = await ApiConstants.dioNoLog
        .get('${ApiConstants.baseUrl}/api/v1/maintenance/list',
            options: Options(
              headers: {
                'Authorization': authorization,
                'Accept': "application/json",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return response.data;
  }

  static dynamic getMaintainance(String authorization, int id) async {
    var params = {'id': id};
    final response = await ApiConstants.dioNoLog
        .get('${ApiConstants.baseUrl}/api/v1/maintenance/show',
            queryParameters: params,
            options: Options(
              headers: {
                'Authorization': authorization,
                'Accept': "application/json",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return response.data;
  }
}
