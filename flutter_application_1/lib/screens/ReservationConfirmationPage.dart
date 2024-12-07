import 'package:flutter/material.dart';
import '../models/DriveModel.dart';

class ReservationConfirmationPage extends StatefulWidget {
  final Drive drive; // Les informations du covoiturage

  const ReservationConfirmationPage({Key? key, required this.drive})
      : super(key: key);

  @override
  _ReservationConfirmationPageState createState() =>
      _ReservationConfirmationPageState();
}

class _ReservationConfirmationPageState
    extends State<ReservationConfirmationPage> {
  int selectedSeats = 1; // Le nombre de sièges sélectionné par le passager
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    // Initialiser le prix total en fonction du nombre de sièges
    totalPrice = widget.drive.price * selectedSeats;
  }

  // Met à jour le prix total en fonction du nombre de sièges
  void _updateTotalPrice(int seats) {
    setState(() {
      selectedSeats = seats;
      totalPrice = widget.drive.price * selectedSeats;
    });
  }

  // Confirmer la réservation
  void _confirmReservation() {
    // Implémenter la logique de confirmation ici (par exemple, appel API, ajout dans la base de données)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Réservation confirmée!')),
    );

    // Naviguer vers une autre page ou afficher un message
    Navigator.pop(
        context); // Fermer la page de confirmation et revenir en arrière
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation de Réservation'),
        backgroundColor:
            Colors.blueAccent, // Changer pour une teinte plus claire
        elevation: 4, // Ombre de l'appbar pour un effet de profondeur
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Pour faire défiler le contenu si nécessaire
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centrer verticalement
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Espacement en haut de la page pour ajuster la position
              const SizedBox(height: 70),

              // Card Widget to wrap the content
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Afficher les détails du trajet
                      Text(
                        '${widget.drive.pickup} -> ${widget.drive.destination}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date et Heure : ${widget.drive.deptime}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                          height: 30), // Espacement entre les éléments

                      // Sélection du nombre de sièges avec des boutons "+"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Flexible(
                            // Wrap Text inside Flexible to allow it to take available space
                            child: Text(
                              'Sélectionnez le nombre de sièges',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          // Wrap the buttons in an Expanded widget to ensure they are resized properly
                          Row(
                            children: [
                              // Bouton "-" avec cercle
                              GestureDetector(
                                onTap: () {
                                  if (selectedSeats > 1) {
                                    _updateTotalPrice(selectedSeats - 1);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.blue, width: 2),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 4.0,
                                        spreadRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              // Affichage du nombre de sièges
                              Text(
                                '$selectedSeats',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // Bouton "+" avec cercle
                              GestureDetector(
                                onTap: () {
                                  if (selectedSeats < widget.drive.seating) {
                                    _updateTotalPrice(selectedSeats + 1);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.blue, width: 2),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 4.0,
                                        spreadRadius: 1.0,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              20), // Espacement après la sélection du nombre de sièges

                      // Affichage du prix total avec style
                      Text(
                        'Prix total: ${totalPrice.toStringAsFixed(2)} MAD',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(
                          height:
                              30), // Espacement avant le bouton de confirmation

                      // Bouton de confirmation avec bord arrondi
                      Center(
                        child: ElevatedButton(
                          onPressed: _confirmReservation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blueAccent, // Couleur du bouton
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Bord arrondi
                            ),
                            shadowColor: Colors
                                .blue, // Ombre pour un effet de profondeur
                            elevation: 6, // Ombre plus prononcée pour effet 3D
                          ),
                          child: const Text(
                            'Confirmer',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
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
