import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/ApiService.dart';
import 'SearchResultsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  String? _selectedStartCity;
  String? _selectedEndCity;
  DateTime? _selectedDate;
  int _seats = 1;
  List<String> _startCities = [];
  List<String> _endCities = [];

  @override
  void initState() {
    super.initState();
    _fetchCities();
  }

  Future<void> _fetchCities() async {
    try {
      final drives = await _apiService.fetchAllDrives();
      setState(() {
        // Extraire les villes de départ et d'arrivée uniques
        _startCities = drives
            .map((drive) => drive['pickup'])
            .toSet()
            .cast<String>()
            .toList();

        _endCities = drives
            .map((drive) => drive['destination'])
            .toSet()
            .cast<String>()
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _searchDrives() {
    if (_selectedStartCity == null ||
        _selectedEndCity == null ||
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
          startLocation: _selectedStartCity!,
          endLocation: _selectedEndCity!,
          date: _selectedDate!,
          seats: _seats,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Offres',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0075FD),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Ville de départ
              DropdownButtonFormField<String>(
                value: _selectedStartCity,
                items: _startCities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStartCity = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Ville de départ',
                  prefixIcon:
                      const Icon(Icons.location_on, color: Color(0xFF0075FD)),
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
              const SizedBox(height: 20),

              // Ville d’arrivée
              DropdownButtonFormField<String>(
                value: _selectedEndCity,
                items: _endCities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEndCity = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Ville d’arrivée',
                  prefixIcon:
                      const Icon(Icons.location_on, color: Color(0xFF0075FD)),
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
              const SizedBox(height: 20),

              // Sélection du nombre de sièges
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nombre de sièges',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
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
                            color: Color(0xFF0075FD),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$_seats',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
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
                            color: Color(0xFF0075FD),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

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
                        color: Color(0xFF0075FD)),
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
              const SizedBox(height: 50),

              // Bouton de recherche
              Center(
                child: ElevatedButton.icon(
                  onPressed: _searchDrives,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: const Text(
                    'Rechercher',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0075FD),
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
