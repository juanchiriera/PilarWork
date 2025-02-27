class Reserva {
  final String id;
  final String espacio;
  final DateTime startTime;
  final DateTime endTime;

  Reserva({
    required this.id,
    required this.espacio,
    required this.startTime,
    required this.endTime,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      // name: json['name'],
      startTime: DateTime.parse(json['fechaInicio']),
      endTime: DateTime.parse(json['fechaFin']),
      espacio: json['espacio'],
    );
  }

  static List<Reserva> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Reserva.fromJson(json)).toList();
  }
}
