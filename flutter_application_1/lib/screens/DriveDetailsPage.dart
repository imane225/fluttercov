import 'package:flutter/material.dart';
import '../models/DriveModel.dart';
import 'DriverDetailsPage.dart'; // Import de DriverDetailsPage

class DriveDetailsPage extends StatelessWidget {
  final Drive drive;

  const DriveDetailsPage({Key? key, required this.drive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservation Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DetailItem(
              title: drive.pickup,
              subtitle: 'Departure City',
            ),
            const SizedBox(height: 10),
            DetailItem(
              title: drive.destination,
              subtitle: 'Arrival City',
            ),
            const SizedBox(height: 10),
            DetailItem(
              title: drive.deptime.toLocal().toString(),
              subtitle: 'Date & Time',
            ),
            const SizedBox(height: 10),
            DetailItem(
              title: '${drive.seating}',
              subtitle: 'Seats',
            ),
            const SizedBox(height: 10),
            DetailItem(
              title: '${drive.price.toStringAsFixed(2)} MAD',
              subtitle: 'Price',
            ),
            const SizedBox(height: 10),
            DetailItem(
              title: drive.description ?? 'No description available',
              subtitle: 'Description',
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Navigation vers DriverDetailsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DriverDetailsPage(driverId: drive.driverId),
                  ),
                );
              },
              child: DetailItem(
                title: drive.driverName ?? 'Unknown Driver',
                subtitle: 'Driver Name',
                isClickable: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isClickable;

  const DetailItem({
    Key? key,
    required this.title,
    required this.subtitle,
    this.isClickable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: isClickable
            ? const Icon(Icons.arrow_forward_ios, color: Colors.grey)
            : null,
        onTap: isClickable
            ? () {
                // Action pour les éléments cliquables
                if (subtitle == 'Driver Name') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Navigating to Driver Details...'),
                    ),
                  );
                }
              }
            : null,
      ),
    );
  }
}
