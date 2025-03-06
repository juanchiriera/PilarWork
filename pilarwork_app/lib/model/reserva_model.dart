class Reserva {
  final String id;
  final String espacio;
  final DateTime startTime;
  final DateTime endTime;
  final String descripcion;
  final String titulo;

  Reserva({
    required this.id,
    required this.espacio,
    required this.startTime,
    required this.endTime,
    this.descripcion = '',
    this.titulo = '',
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      startTime: DateTime.parse(json['fechaInicio']).toLocal(),
      endTime: DateTime.parse(json['fechaFin']).toLocal(),
      espacio: json['espacio'],
      descripcion: json['descripcion'] ?? '',
      titulo: json['titulo'] ?? '',
    );
  }

  static List<Reserva> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Reserva.fromJson(json)).toList();
  }
}
