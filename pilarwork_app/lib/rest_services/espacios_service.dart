import 'dart:convert';

import 'package:pilarwork_app/model/espacio_model.dart';
import 'package:http/http.dart' as http;

class EspaciosService {
  static Future<List<Espacio>> fetchEspacios() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/espacios'));
    if (response.statusCode == 200) {
      // setState(() {
      var jsonBody = json.decode(response.body);
      var espaciosList = Espacio.fromJsonList(jsonBody);
      return espaciosList;
      // });
    } else {
      throw Exception('Error al cargar los espacios');
    }
  }
}
