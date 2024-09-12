import 'package:dio/dio.dart';
import 'package:hospitalhub/.env.dart';
import 'package:hospitalhub/service/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio;

  ApiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<Map<String, dynamic>> getProfile() async {
    final userdata = await getUserDataFromLocalStorage();
    final doctorId = userdata["userId"];

    try {
      final response = await _dio.get('$APIURL/doctor/$doctorId');
      print("Response:  $response");

      if (response.statusCode == 200) {
        final result = response.data;
        return result;
      } else {
        print("Error: ${response.statusCode} - ${response.statusMessage}");
        return {
          'message':
              'Error: ${response.statusCode} - ${response.statusMessage}',
        };
      }
    } catch (e) {
      print("Exception: $e");
      return {
        'message': 'Error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getHealthRecommendation(String condition) async {
    try {
      final response = await _dio.get(
        'https://healthy-api.p.rapidapi.com/symptom-checker',
        queryParameters: {
          'symptom': condition, // Pass the patient's condition or diagnosis
        },
        options: Options(
          headers: {
            'X-RapidAPI-Host': 'healthy-api.p.rapidapi.com',
            'X-RapidAPI-Key': '', // No API key required for this API
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final title = data['name'] ?? 'Unknown';
        final summary = data['description'] ?? 'No summary available';
        final url = data['link'] ?? '';

        return {
          'title': title,
          'summary': summary,
          'url': url,
          'recommendation':
              'Based on the information about $title, it is recommended to consult with a healthcare professional for proper diagnosis and treatment. For more details, visit: $url',
        };
      } else {
        return {
          'title': 'No information found',
          'summary': 'No summary available for the given condition.',
          'url': '',
          'recommendation':
              'Please consult with a healthcare professional for accurate information about your condition.',
        };
      }
    } catch (e) {
      print('Error occurred: $e');
      return {
        'title': 'Error',
        'summary':
            'Failed to load health information. Please check your internet connection.',
        'url': '',
        'recommendation':
            'Please consult with a healthcare professional for accurate information.',
      };
    }
  }
}
