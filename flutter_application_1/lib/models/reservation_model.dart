import 'package:flutter_application_1/models/DriveModel.dart';
import 'package:flutter_application_1/models/user_model.dart';

class Reservation {
  final int id;
  final int seats;
  late final String status;
  late Drive drive; // Associated Drive
  late User user; // Associated User

  Reservation({
    required this.id,
    required this.seats,
    required this.status,
    required this.drive,
    required this.user,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      seats: json['reservedSeats'] ?? 0,
      status: json['status'] ?? '',
      drive: Drive.fromJson(json['drive'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}
