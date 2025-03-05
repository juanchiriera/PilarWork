import 'dart:convert';

import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:http/http.dart' as http;

class ReservasService {
  static Future<List<Reserva>> fetchReservations(DateTime startDate,
      [DateTime? endDate]) async {
    final String url;
    if (endDate != null) {
      url =
          '/api/reservas?fechaInicio=${startDate.toIso8601String()}&fechaFin=${endDate.toIso8601String()}';
    } else {
      url = '/api/reservas?fechaSeleccionada=${startDate.toIso8601String()}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Reserva.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reservations');
    }
  }
}
