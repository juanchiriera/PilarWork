import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:http/http.dart' as http;

class TimePickerModal extends StatelessWidget {
  final DateTime? selectedDay;
  final String? espacioId;

  const TimePickerModal({super.key, this.selectedDay, this.espacioId});

  Future<List<Reserva>> fetchEspacios() async {
    final Map<String, String> queryParams = {
      if (espacioId != null) 'espacio': espacioId!,
      if (selectedDay != null) 'fecha': selectedDay!.toIso8601String(),
    };

    final uri = Uri.parse('http://localhost:3000/api/reservas')
        .replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return Reserva.fromJsonList(json.decode(response.body));
      }
      throw Exception('Error HTTP: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al cargar los espacios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              selectedDay != null
                  ? 'Reservas para el día: ${DateFormat('dd/MM/yyyy').format(selectedDay!)}'
                  : 'Seleccione una fecha',
            ),
            Expanded(
              child: FutureBuilder<List<Reserva>>(
                future: fetchEspacios(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final reservas = snapshot.data ?? [];

                  return reservas.isEmpty
                      ? const Center(
                          child: Text('No hay reservas para este día'))
                      : ListView.builder(
                          itemCount: reservas.length,
                          itemBuilder: (context, index) {
                            final reserva = reservas[index];
                            return ListTile(
                              title: Text(reserva.espacio),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Inicio: ${DateFormat('HH:mm').format(reserva.startTime)}'),
                                  Text(
                                      'Fin: ${DateFormat('HH:mm').format(reserva.endTime)}'),
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
