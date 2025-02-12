class Reserva {
  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;

  Reserva({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      name: json['name'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  static List<Reserva> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Reserva.fromJson(json)).toList();
  }
}
