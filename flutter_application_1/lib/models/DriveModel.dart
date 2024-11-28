class Drive {
  final String pickup; // Correspond à "pickup" du backend
  final String destination; // Correspond à "destination" du backend
  final DateTime deptime; // Correspond à "deptime" du backend
  final double price; // Correspond à "price" du backend
  final String driverName; // Correspond à "driverName" du backend
  final int seating; // Correspond à "seating" du backend (places disponibles)

  Drive({
    required this.pickup,
    required this.destination,
    required this.deptime,
    required this.price,
    required this.driverName,
    required this.seating,
  });

  factory Drive.fromJson(Map<String, dynamic> json) {
    return Drive(
      pickup: json['pickup'],
      destination: json['destination'],
      deptime: DateTime.parse(json['deptime']),
      price: (json['price'] as num)
          .toDouble(), // Assurez-vous que le prix est un double
      driverName:
          json['driverName'] ?? 'Nom non disponible', // Gère les valeurs nulles
      seating: json['seating'],
    );
  }

  get description => null;

  get driverId => null;
}
