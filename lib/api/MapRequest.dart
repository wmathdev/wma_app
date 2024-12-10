import 'package:dio/dio.dart';

import 'ApiConstants.dart';

class MapRequest {
  static dynamic getDocumentShow() async {
    final response =
        await ApiConstants.dioNoLog.get('${ApiConstants.baseUrl}/api/v1/map/',
            options: Options(
              headers: {
                'Accept': "application/json",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return response.data;
  }

  static dynamic getTreatedWater() async {
    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/map/treated-water',
            options: Options(
              headers: {
                'Accept': "application/json",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return response.data;
  }

  static dynamic getMapStation(String stationId) async {
    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/map/station',
            queryParameters: {"station_id": stationId},
            options: Options(
              headers: {
                'Accept': "application/json",
              },
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ));
    return response.data;
  }

  static dynamic getStationStatistic(
      String stationId, String measure, String period) async {
    final response = await ApiConstants.dioNoLog.get(
        '${ApiConstants.baseUrl}/api/v1/map/station/statistic',
        queryParameters: {
          "station_id": stationId,
          "measure": measure,
          "period": period
        },
        options: Options(
          headers: {
            'Accept': "application/json",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    return response.data;
  }

  static dynamic getQualityOverview() async {
    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/statistic/quality',
            options: Options(
              headers: {
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
