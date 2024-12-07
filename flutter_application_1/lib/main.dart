import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/reservation_service.dart';
import 'package:flutter_application_1/screens/reservation_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Supprime le bandeau "Debug"
      title: 'Covoiturage - Lo7ni M3ak',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Palette de couleurs principale
      ),
      // Passez l'ID d'un utilisateur qui existe dans votre base de données
      home: ReservationPage(
        userId:
            5, // Remplacez par l'ID d'un utilisateur valide dans votre base de données
        reservationService:
            ReservationService(), // Assurez-vous que le service est passé
      ),
    );
  }
}
