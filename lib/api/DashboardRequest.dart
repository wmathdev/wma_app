import 'package:dio/dio.dart';

import 'ApiConstants.dart';

class DashboardRequest {
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

  static dynamic getStatistic() async {
    final response =
        await ApiConstants.dio.get('${ApiConstants.baseUrl}/api/v1/statistic',
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
        .get('${ApiConstants.baseUrl}/api/v1/statistic/treated-water',
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



  static dynamic getQualityStation(
      String  status) async {
    var params = {'status': status};

    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/statistic/quality/stations',
            queryParameters: params,
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
