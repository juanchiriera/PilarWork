import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pilarwork_app/model/espacio_model.dart';
import 'package:pilarwork_app/rest_services/espacios_service.dart';
import 'package:pilarwork_app/widgets/espacio_list_tile.dart';

class EspaciosPage extends StatefulWidget {
  const EspaciosPage({super.key});

  @override
  EspaciosPageState createState() => EspaciosPageState();
}

class EspaciosPageState extends State<EspaciosPage> {
  List<Espacio> espacios = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    EspaciosService.fetchEspacios().then((data) {
      setState(() {
        espacios = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elegi tu espacio para la reserva'),
      ),
      body: espacios.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: espacios.length,
              itemBuilder: (context, index) {
                final espacio = espacios[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: EspacioListTile(espacio: espacio),
                );
              },
            ),
    );
  }
}

Future<void> createReserva(
  String espacioId,
  //String clienteId,
  DateTime fechaInicio,
  DateTime fechaFin,
  String personas,
  BuildContext context,
) async {
  final url = Uri.parse('http://localhost:3000/api/reservas');
  final body = json.encode({
    'fechaInicio': fechaInicio.toIso8601String(),
    'fechaFin': fechaFin.toIso8601String(),
    'espacioId': espacioId,
    'personas': personas.split(','),
    //'clienteId': clienteId, falta agregar con el login de usuarios
  });

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (!context.mounted) return;

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reserva creada exitosamente')),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al crear la reserva')),
    );
  }
}
