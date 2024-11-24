import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wma_app/model/doc.dart';
import 'package:wma_app/model/docList.dart';

import 'ApiConstants.dart';

class OfficerRequest {
  static dynamic approval(
      String authorization, String docId, String status, String comment) async {
    int cast = int.parse(docId);
    List<int> docs = [cast];
    final formData = FormData.fromMap({
      'document_ids': jsonEncode(docs),
      'status': status,
      'comment': comment
    });

    print(formData.fields);
    final response = await ApiConstants.dioNoLog
        .post('${ApiConstants.baseUrl}/api/v1/officer/document/approval',
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

  static dynamic approvalSelect(
      String authorization, List<int> docId, String status) async {
    if (docId.isEmpty) {
      return false;
    }
    final formData = FormData.fromMap({
      'document_ids': jsonEncode(docId),
      'status': status,
      'comment': ''
    });


    final response = await ApiConstants.dio
        .post('${ApiConstants.baseUrl}/api/v1/officer/document/approval',
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
    // final formData = FormData.fromMap(
    //     {'station_id': stationid, 'type': type, 'period': period});
    // print('ddddd $formData');
    var params = {'station_id': stationid, 'type': type, 'period': period};
    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/officer/document/list',
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
    final response = await ApiConstants.dioNoLog
        .get('${ApiConstants.baseUrl}/api/v1/officer/document/show',
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

  static dynamic getReportList(String authorization, String type,
      String workflow, String reportAt) async {
    final response = await ApiConstants.dio.get(
        '${ApiConstants.baseUrl}/api/v1/officer/report',
        queryParameters: {
          'type': type,
          'workflow': workflow,
          'report_at': reportAt
        },
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
