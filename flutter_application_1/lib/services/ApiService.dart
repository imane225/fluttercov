import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/drives';

  Future<List<dynamic>> searchDrives(
      String pickup, String destination, DateTime deptime, int seats) async {
    final String url =
        '$baseUrl/search?pickup=$pickup&destination=$destination&seats=$seats&deptime=${deptime.toIso8601String()}';

    print("Request URL: $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("Response: ${response.body}");
      return jsonDecode(response.body);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      throw Exception('Failed to fetch drives');
    }
  }

  getDriverDetails(int driverId) {}
}
