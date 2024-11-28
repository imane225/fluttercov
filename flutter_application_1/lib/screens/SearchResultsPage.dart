import 'package:flutter/material.dart';
import '../models/DriveModel.dart';
import '../services/ApiService.dart';
import 'DriveDetailsPage.dart';

class SearchResultsPage extends StatefulWidget {
  final String startLocation;
  final String endLocation;
  final DateTime date;
  final int seats;

  const SearchResultsPage({
    required this.startLocation,
    required this.endLocation,
    required this.date,
    required this.seats,
    Key? key,
  }) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ApiService _apiService = ApiService();
  List<Drive> _drives = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDrives();
  }

  Future<void> _fetchDrives() async {
    try {
      print(
          "Fetching drives for: ${widget.startLocation} -> ${widget.endLocation}");
      List<dynamic> drives = await _apiService.searchDrives(
        widget.startLocation,
        widget.endLocation,
        widget.date,
        widget.seats,
      );

      setState(() {
        _drives = drives.map((drive) => Drive.fromJson(drive)).toList();
        print("Drives received in Flutter: $_drives");
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching drives: $error');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Une erreur est survenue lors de la récupération des données.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _drives.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun trajet trouvé pour cette recherche.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _drives.length,
                  itemBuilder: (context, index) {
                    final drive = _drives[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trajet Details
                          ListTile(
                            title: Text(
                              '${drive.pickup} -> ${drive.destination}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${drive.price.toStringAsFixed(2)} MAD',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                              ),
                            ),
                            onTap: () {
                              // Navigation vers la page des détails
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DriveDetailsPage(drive: drive),
                                ),
                              );
                            },
                          ),
                          const Divider(),
                          // Bouton Réserver
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigation vers la page de paiement (à implémenter)
                                  print(
                                      'Navigation vers la page de paiement pour le trajet: ${drive.pickup} -> ${drive.destination}');
                                  // Navigator.push(...); // Page de paiement à implémenter
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Réserver',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
