import 'dart:convert';

import 'package:dio/dio.dart';

import 'ApiConstants.dart';

class ManagerRequest {
  
  static dynamic approval(
      String authorization, String docId, String status, String comment) async {
    final formData = FormData.fromMap(
        {'document_id': docId, 'status': status, 'comment': comment});

    print(formData.fields);
    final response = await ApiConstants.dioNoLog
        .post('${ApiConstants.baseUrl}/api/v1/manager/document/approval',
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

  static dynamic getDocumentLists(String authorization, String stationid,
      String type, String period) async {
    // final formData = FormData.fromMap({
    //   'station_id': stationid,
    //   'type': type,
    //   'period':period
    // });

    var params = {'station_id': stationid, 'type': type, 'period': period};

    print('ddddd $stationid');
    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/manager/document/list',
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

  static dynamic getDocumentShow(String authorization, String docId) async {
    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/manager/document/show',
            queryParameters: {'document_id': docId},
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
      int stationId,
      String docId,
      String doo,
      String ph,
      String temp,
      String treatedDoo,
      String treatedPh,
      String treatedTemp,
      List<String> file,
      String treatedWater,
      String reportTo,
      String type,
      String comment) async {
    final formData = FormData.fromMap({
      'station_id': stationId,
      'document_id': docId,
      'doo': doo,
      'ph': ph,
      'temp': temp,
      'treated_doo': treatedDoo,
      'treated_ph': treatedPh,
      'treated_temp': treatedTemp,
      'treated_water': treatedWater,
      'files': jsonEncode(file),
      'report_at': reportTo,
      'type': type,
      'comment': comment
    });

    print(formData.fields);
    final response = await ApiConstants.dioNoLog
        .post('${ApiConstants.baseUrl}/api/v1/manager/document/update',
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

  static dynamic revisionMonthlyDocument(
      String authorization,
      int stationId,
      String documentId,
      String bod,
      String cod,
      String ss,
      String fog,
      String totalNitrogen,
      String totalPhosphorous,
      String salt,
      String treated_bod,
      String treated_cod,
      String treated_ss,
      String treated_fog,
      String treated_total_nitrogen,
      String treated_total_phosphorous,
      String treated_salt,
      String electric_unit,
      List<String> file,
      String reportTo,
      String type,
      String comment,
      String location) async {
    final formData = FormData.fromMap({
      'station_id': stationId,
      'document_id': documentId,
      'bod': bod == 'Null' || bod == 'null' ? null : bod,
      'cod': cod == 'Null' || cod == 'null' ? null : cod,
      'ss': ss== 'Null' || ss == 'null' ? null : ss,
      'fog': fog== 'Null' || fog == 'null' ? null : fog,
      'total_nitrogen': totalNitrogen== 'Null' || totalNitrogen == 'null' ? null : totalNitrogen,
      'total_phosphorous': totalPhosphorous== 'Null' || totalPhosphorous == 'null' ? null : totalPhosphorous,
      'salt': salt== 'Null' || salt == 'null' ? null : salt,
      'treated_bod': treated_bod == 'Null' || treated_bod == 'null' ? null : treated_bod,
      'treated_cod': treated_cod == 'Null' || treated_cod == 'null' ? null : treated_cod,
      'treated_ss': treated_ss== 'Null' || treated_ss == 'null' ? null : treated_ss,
      'treated_fog': treated_fog== 'Null' || treated_fog == 'null' ? null : treated_fog,
      'treated_total_nitrogen': treated_total_nitrogen== 'Null' || treated_total_nitrogen == 'null' ? null : treated_total_nitrogen,
      'treated_total_phosphorous': treated_total_phosphorous== 'Null' || treated_total_phosphorous == 'null' ? null : treated_total_phosphorous,
      'treated_salt': treated_salt== 'Null' || treated_salt == 'null' ? null : treated_salt,
      'electric_unit': electric_unit== 'Null' || electric_unit == 'null' ? null : electric_unit,
      'report_at': reportTo== 'Null' || reportTo == 'null' ? null : reportTo,
      'files': jsonEncode(file),
      'type': type,
      'comment': comment,
      'location': location
    });
    print(formData.fields);
    final response = await ApiConstants.dioNoLog
        .post('${ApiConstants.baseUrl}/api/v1/manager/document/update',
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
}
