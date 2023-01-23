import 'package:dio/dio.dart';
import '/core/constants/app_constants.dart';

class CurrencyApiClient {
  final Dio _dio;
  final String? _baseUrl;


  CurrencyApiClient(this._dio, this._baseUrl) {
    _dio
      ..options.baseUrl = _baseUrl ?? ''
      ..options.connectTimeout = AppConsts.connectionTimeout
      ..options.receiveTimeout = AppConsts.receiveTimeout
      ..options.headers = <String, dynamic>{}
      ..options.responseType = ResponseType.json;
  }
  // Get:-----------------------------------------------------------------------
  Future<Map<String, dynamic>> get(
      String url, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      final errorResponse = <String, dynamic>{};
      errorResponse['error'] = e.response?.data['error'];
      errorResponse['statusCode'] = e.response?.statusCode;
      return errorResponse;
    }
  }
}
