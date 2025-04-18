class Espacio {
  final String id;
  final String name;
  final int quantity;
  final bool available;
  final List<String> elementos;
  final List<String> reservas;

  Espacio({
    required this.id,
    required this.name,
    required this.quantity,
    required this.available,
    required this.elementos,
    required this.reservas,
  });

  factory Espacio.fromJson(Map<String, dynamic> json) {
    return Espacio(
      id: json['_id'],
      name: json['name'],
      quantity: json['quantity'],
      available: json['available'],
      elementos: json['elementos'] != null
          ? List<String>.from(json['elementos'].map((x) => x.toString()))
          : [],
      reservas: json['reservas'] != null
          ? List<String>.from(json['reservas'].map((x) => x.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'quantity': quantity,
      'available': available,
      'elementos': List<dynamic>.from(elementos.map((x) => x)),
      'reservas': List<dynamic>.from(reservas.map((x) => x)),
    };
  }

  static List<Espacio> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Espacio.fromJson(json)).toList();
  }
}
