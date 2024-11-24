import 'package:dio/dio.dart';
import 'package:wma_app/api/ApiConstants.dart';

class NotificationRequest {
  static dynamic getNotificationList(String authorization) async {
    final response = await ApiConstants.dio
        .get('${ApiConstants.baseUrl}/api/v1/notifications',
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



  static dynamic getNotificationDetial(String authorization,String id) async {
    final response = await ApiConstants.dioNoLog.request(
      '${ApiConstants.baseUrl}/api/v1/notifications/read',
      queryParameters: {'id':id},
      options: Options(
        headers: {
          'Authorization': authorization,
          'Accept': "application/json",
        },
        method: 'GET',
      ),
    );
    return response.data;
  }
}
