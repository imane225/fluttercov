import 'package:flutter/material.dart';
import 'screens/HomePage.dart';

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
      home: HomePage(), // Écran d'accueil
    );
  }
}
