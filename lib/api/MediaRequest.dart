import 'package:dio/dio.dart';

import 'ApiConstants.dart';

class MediaRequest {

  static dynamic delete(
      String authorization, String uuid) async {

    final response = await ApiConstants.dioNoLog
        .post('${ApiConstants.baseUrl}/api/v1/media/delete',
            queryParameters: {'uuid':uuid},
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
