import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'ApiConstants.dart';

class Authentication {
  static dynamic login(
      String email,
      String password,
      String notiToken,
      String deviceToken,
      String osType,
      String osVersion,
      String appVersion,
      String userAgent) async {
    final formData = FormData.fromMap({
      'email': email,
      'password': password,
      'noti_token': notiToken,
      'device_token': deviceToken,
      'os_type': osType,
      'os_version': osVersion,
      'app_version': appVersion,
      'user_agent': userAgent,
    });
    final response =
        await ApiConstants.dio.post('${ApiConstants.baseUrl}/api/v1/auth/login',
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              },
            ),
            data: formData);
    return response.data;
  }

  static dynamic logout(String authorization) async {
    final response = await ApiConstants.dioNoLog.request(
      '${ApiConstants.baseUrl}/api/v1/auth/logout',
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
    return response;
  }

  static dynamic forceUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print('my version : $version');
    final response = await ApiConstants.dioNoLog
        .get('${ApiConstants.baseUrl}/api/application/force-update',
            queryParameters: {'app_version': version},
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

  static dynamic checkin(String authorization, String location) async {
    final formData = FormData.fromMap({'location': location});

    final response = await ApiConstants.dioNoLog
        .post('${ApiConstants.baseUrl}/api/v1/account/check-in',
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
    print(response.data);
    return response.data;
  }
}
