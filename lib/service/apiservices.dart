import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> getRecommendation(String disease) async {
    try {
      final response = await _dio.get(
        'https://tools.cdc.gov/api/v2/resources/media',
        queryParameters: {'topic': disease},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'Failed to load data: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('DioException occurred: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error occurred: $e');
      throw Exception('Failed to get recommendation: $e');
    }
  }
}