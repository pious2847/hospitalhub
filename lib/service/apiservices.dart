import 'package:dio/dio.dart';
import 'package:hospitalhub/.env.dart';
import 'package:hospitalhub/service/general.dart';

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

  Future<Map<String, dynamic>> fetchReport() async {
    try {
      final response = await _dio.get('$APIURL/patients/reports');

      if (response.statusCode == 200) {
        final result = response.data['report'];
        return result;
      } else {
        throw Exception('Failed to load report');
      }
    } catch (e) {
        print("Exception: $e");
      return {
        'message': 'Error: $e',
      };
    }
  }

  Future<void> deletePatient(String patientId) async {
    try {
      final response = await _dio.delete(
        '$APIURL/patients/$patientId',  );

      if (response.statusCode == 200) {
       
     }
       
    } catch (e) {
      print('Error occurred: $e');
   
    }
  }
  
}
