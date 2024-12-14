import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wma_app/Utils/FileDownloaderHelper.dart';

import 'ApiConstants.dart';

class Reportdownloadrequest {
  static dynamic getReportDownloadList(
      String authorization, int stationid, String year) async {
    var params = {'station_id': stationid, 'year': year};

    final response = await ApiConstants.dioNoLog
        .get('${ApiConstants.baseUrl}/api/v1/utils/report/document/list',
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

  static dynamic getReportDownload(
      String authorization, int stationid, String date, String mimes) async {
    var params = {'station_id': stationid, 'started_at': date, 'mimes': mimes};
    var response;
    try {
      String directory;
      if (Platform.isIOS) {
        directory = (await getDownloadsDirectory())?.path ??
            (await getTemporaryDirectory()).path;
      } else {
        directory = '/storage/emulated/0/Download/';
        var dirDownloadExists = true;
        dirDownloadExists = await Directory(directory).exists();
        if (!dirDownloadExists) {
          directory = '/storage/emulated/0/Downloads/';
          dirDownloadExists = await Directory(directory).exists();
          if (!dirDownloadExists) {
            directory = (await getTemporaryDirectory()).path;
          }
        }
      }

      response = await ApiConstants.dioNoLog.download(
          '${ApiConstants.baseUrl}/api/v1/utils/report/document/download',
          mimes == 'xlsx'
              ? '${directory}report$date.xlsx'
              : '${directory}report$date.pdf',
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
    } catch (e) {
      print(e);
    }
    return 'response.data';
  }

}
