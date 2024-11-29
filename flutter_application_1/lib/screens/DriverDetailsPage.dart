import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DriverDetailsPage extends StatelessWidget {
  final int driverId;

  const DriverDetailsPage({Key? key, required this.driverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchDriverDetails(driverId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Driver Info")),
            body: Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final driver = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text("Driver Info"),
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    driver['profilePictureUrl'] ??
                        'https://via.placeholder.com/150',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  driver['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rating: ${driver['rating']} ⭐',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text("Full Name"),
                  subtitle: Text("${driver['firstName']} ${driver['name']}"),
                ),
                ListTile(
                  title: const Text("Phone Number"),
                  subtitle: Text(driver['phone']),
                ),
                ListTile(
                  title: const Text("Email"),
                  subtitle: Text(driver['email']),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Map<String, dynamic>> fetchDriverDetails(int driverId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/v1/user/$driverId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch driver details');
    }
  }
}
