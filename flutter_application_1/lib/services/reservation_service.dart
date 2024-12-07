import 'dart:convert';
import 'package:flutter_application_1/models/DriveModel.dart';
import 'package:flutter_application_1/models/reservationDto.dart';
import 'package:flutter_application_1/models/reservation_model.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String baseUrl =
      'http://10.0.2.2:8080/api/v1'; // Ensure this URL is correct for your environment

  Future<List<Reservation>> fetchReservationsByUserId(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/reservations/user/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> reservationsData = jsonDecode(response.body);
        List<Reservation> reservations = [];

        for (var reservationData in reservationsData) {
          ReservationDto reservationDto =
              ReservationDto.fromJson(reservationData);

          final driveResponse = await http.get(Uri.parse(
              '$baseUrl/drives/findDriveById/${reservationDto.driveId}'));
          Drive? drive;

          if (driveResponse.statusCode == 200) {
            drive = Drive.fromJson(jsonDecode(driveResponse.body));
          } else {
            print(
                'Failed to load drive details for driveId: ${reservationDto.driveId}');
          }

          final userResponse = await http
              .get(Uri.parse('$baseUrl/user/${reservationDto.userId}'));
          User? user;

          if (userResponse.statusCode == 200) {
            user = User.fromJson(jsonDecode(userResponse.body));
          } else {
            print(
                'Failed to load user details for userId: ${reservationDto.userId}');
            user = User(
                id: 0,
                firstName: 'Unknown',
                name: 'User',
                email: 'N/A',
                phone: 'N/A',
                role: 'Unknown',
                reviews: []);
          }

          Reservation reservation = Reservation(
            id: reservationDto.id,
            seats: reservationDto.seats,
            status: reservationDto.status,
            drive: drive ??
                Drive(
                    id: 0,
                    pickup: 'Unknown',
                    destination: 'Unknown',
                    deptime: DateTime.now(),
                    price: 0.0,
                    seating: 0,
                    description: 'No description',
                    user: user),
            user: user,
          );

          reservations.add(reservation);
        }

        return reservations;
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      throw Exception('Failed to load reservations');
    }
  }

  Future<List<Reservation>> getReservations(int userId) async {
    try {
      return await fetchReservationsByUserId(userId);
    } catch (e) {
      throw Exception('Failed to load reservations');
    }
  }

  Future<void> cancelReservation(int reservationId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/reservations/$reservationId/cancel'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to cancel reservation');
    }
  }
}
