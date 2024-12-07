import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1';

  // Fetch all drives
  Future<List<dynamic>> fetchAllDrives() async {
    final response = await http.get(Uri.parse('$baseUrl/drives'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load drives');
    }
  }

  // Fetch driver details by ID
  Future<Map<String, dynamic>> fetchDriverById(int driverId) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$driverId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return driver details
    } else {
      throw Exception('Failed to load driver details');
    }
  }
}
