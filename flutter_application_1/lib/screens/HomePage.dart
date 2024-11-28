import 'package:flutter/material.dart';
import 'SearchResultsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  DateTime? _selectedDate;
  int _seats = 1;

  void _searchDrives() {
    final startLocation = _startController.text.trim();
    final endLocation = _endController.text.trim();

    if (startLocation.isEmpty ||
        endLocation.isEmpty ||
        _seats <= 0 ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs correctement.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to SearchResultsPage with the user inputs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          startLocation: startLocation,
          endLocation: endLocation,
          date: _selectedDate!,
          seats: _seats,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Couleur de fond
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Center(
                child: Text(
                  'Offres',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0075FD), // Titre bleu
                  ),
                ),
              ),
              const SizedBox(height: 40), // Plus d'espace après le titre

              // Ville de départ
              TextField(
                controller: _startController,
                decoration: InputDecoration(
                  labelText: 'Ville de départ',
                  prefixIcon: const Icon(Icons.location_on,
                      color: Color(0xFF0075FD)), // Icône bleue
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF0075FD), width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre les champs

              // Ville d'arrivée
              TextField(
                controller: _endController,
                decoration: InputDecoration(
                  labelText: 'Ville d’arrivée',
                  prefixIcon: const Icon(Icons.location_on,
                      color: Color(0xFF0075FD)), // Icône bleue
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xFF0075FD), width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Espace entre les champs

              // Sélection du nombre de sièges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nombre de sièges',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black, // Texte noir
                    ),
                  ),
                  Row(
                    children: [
                      // Bouton de diminution
                      GestureDetector(
                        onTap: () {
                          if (_seats > 1) {
                            setState(() {
                              _seats--;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF0075FD), width: 2),
                          ),
                          child: const Icon(
                            Icons.remove,
                            color: Color(0xFF0075FD), // Icône bleue
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Nombre de sièges
                      Text(
                        '$_seats',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Bouton d'augmentation
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _seats++;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF0075FD), width: 2),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF0075FD), // Icône bleue
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30), // Espace après les sièges

              // Sélection de la date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Date'
                        : 'Date : ${_selectedDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today,
                        color: Color(0xFF0075FD)), // Icône bleue
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 50), // Grand espace avant le bouton

              // Bouton de recherche
              Center(
                child: ElevatedButton.icon(
                  onPressed: _searchDrives,
                  icon: const Icon(Icons.search,
                      color: Colors.white), // Icône blanche
                  label: const Text(
                    'Rechercher',
                    style: TextStyle(color: Colors.white), // Texte blanc
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF0075FD), // Couleur bleu pour le bouton
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
