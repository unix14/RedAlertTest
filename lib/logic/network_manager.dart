import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:red_alert_test_android/models/alert_category.dart';

import '../custom/red_alert_logger.dart';
import '../models/alert.dart';
import 'network_manager_repository.dart';

class NetworkManager<T> extends NetworkManagerRepository {

  //todo add PUT DEL and other desired rest api calls

  @override
  Future<List<T>?> makeRequestList(String endpointUrl, Map<String, String>? headers) async {
    try {
      // Replace this URL with the actual API endpoint
      final response = await http.get(Uri.parse(endpointUrl), headers: headers);

      if (response.statusCode == 200) {
        // Decode the response using UTF-8 encoding
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        final cleanedResponse = utf8Decoder.convert(response.body.codeUnits);


        final List<dynamic> jsonList = json.decode(cleanedResponse);
        // final List<AlertModel> alertList = jsonList.map((json) => AlertModel.fromJson(json)).toList();

        return jsonList.map<T>((json) => _fromJson(json)).toList();
        return List.from(jsonList).map<T>((json) => _fromJson(json)).toList();

      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load alert categories');
      }
    } catch (e) {
      RedAlertLogger.logError('Caught Error for network call: $endpointUrl $headers $e');
      return null;
    }
  }

  @override
  Future<T?> makeRequest(String endpointUrl, Map<String, String>? headers) async {
    try {
      // Replace this URL with the actual API endpoint
      final response = await http.get(Uri.parse(endpointUrl), headers: headers);

      if (response.statusCode == 200) {
        // Decode the response using UTF-8 encoding
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        final cleanedResponse = utf8Decoder.convert(response.body.codeUnits);

        final dynamic jsonResponse = json.decode(cleanedResponse);
        return jsonResponse.map<T>((json) => _fromJson(json));
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load alert categories');
      }
    } catch (e) {
      RedAlertLogger.logError('Caught Error for network call: $endpointUrl $headers $e');
      return null;
    }
  }

  T? _fromJson<T>(Map<String, dynamic> json) {
    //todo refactor to convertor
    // Implement logic to convert JSON to the desired type T
    try {
      // Make sure the type T has a proper fromJson method
      if(T is AlertCategory) {
        return AlertCategory.fromJson(json) as T;
      } else if(T is AlertModel) {
        return AlertModel.fromJson(json) as T;
      } else {
        throw UnimplementedError('fromJson method not implemented for type $T');
      }
    } catch (e) {
      RedAlertLogger.logError('Error parsing JSON for type $T: $e');
    }
    return null;
  }
}
