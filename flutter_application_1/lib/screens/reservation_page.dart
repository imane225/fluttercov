import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/reservation_model.dart'; // Import Reservation and Drive models
import 'package:flutter_application_1/services/reservation_service.dart';

class ReservationPage extends StatefulWidget {
  final int userId;
  final ReservationService reservationService;

  ReservationPage({required this.userId, required this.reservationService});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  List<Reservation> _reservationsList = []; // Initialize empty reservation list

  @override
  void initState() {
    super.initState();
    _loadReservations(); // Load reservations when the page is initialized
  }

  // Fetch reservations from the service
  void _loadReservations() {
    setState(() {
      _reservationsList = []; // Reset the list to show a loading indicator
    });

    widget.reservationService
        .getReservations(widget.userId)
        .then((reservations) {
      setState(() {
        _reservationsList = reservations; // Populate list with fetched data
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des réservations: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes Réservations")),
      body: _reservationsList.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loader if empty
          : ListView.builder(
              itemCount: _reservationsList.length,
              itemBuilder: (context, index) {
                var reservation = _reservationsList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  color: _getStatusColor(reservation.status),
                  child: ListTile(
                    title: Text(
                      '${reservation.drive.pickup} → ${reservation.drive.destination}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Date: ${reservation.drive.deptime.toLocal().toString().substring(0, 16)}\nSeats: ${reservation.seats}\nTotal Price: MAD ${reservation.drive.price * reservation.seats}\nStatus: ${reservation.status}',
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: reservation.status == 'PENDING'
                        ? ElevatedButton(
                            onPressed: () {
                              _showCancelDialog(reservation);
                            },
                            child: Text('Cancel'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.orange),
                            ),
                          )
                        : reservation.status == 'ACCEPTED'
                            ? ElevatedButton(
                                onPressed: () {
                                  _proceedToPayment(reservation);
                                },
                                child: Text('Pay'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                              )
                            : null,
                    tileColor: _getStatusColor(reservation.status),
                  ),
                );
              },
            ),
    );
  }

  // Define colors based on reservation status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACCEPTED':
        return Colors.green.withOpacity(0.2);
      case 'REFUSED':
        return Colors.red.withOpacity(0.2);
      case 'PENDING':
        return Colors.orange.withOpacity(0.2);
      case 'CANCELED':
        return Colors.grey.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  // Show confirmation dialog for canceling a reservation
  void _showCancelDialog(Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Annuler la réservation'),
        content: Text('Êtes-vous sûr de vouloir annuler cette réservation?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Non'),
          ),
          TextButton(
            onPressed: () {
              widget.reservationService
                  .cancelReservation(reservation.id)
                  .then((_) {
                Navigator.pop(context); // Close the dialog
                _loadReservations(); // Reload the reservations
              }).catchError((error) {
                Navigator.pop(context); // Close the dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Échec de l\'annulation: $error'),
                    backgroundColor: Colors.red,
                  ),
                );
              });
            },
            child: Text('Oui'),
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(Reservation reservation) {
    print("Proceeding to payment for reservation ID: ${reservation.id}");
  }
}
