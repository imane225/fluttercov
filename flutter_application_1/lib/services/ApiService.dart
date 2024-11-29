import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/v1/drives'; // Update with your backend URL

  // Fetch all drives (you can implement pagination as needed)
  Future<List<dynamic>> fetchAllDrives() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Return list of all drives
    } else {
      throw Exception('Failed to load drives');
    }
  }
}
