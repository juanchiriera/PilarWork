import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:http/http.dart' as http;

class TimePickerModal extends StatelessWidget {
  final DateTime? selectedDay;

  const TimePickerModal({super.key, this.selectedDay});

  Future<List<Reserva>> fetchEspacios() async {
    //TODO: Agregar filtro de espacio y fecha para las reservas
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/reservas'));
    if (response.statusCode == 200) {
      // setState(() {
      var espaciosList = Reserva.fromJsonList(json.decode(response.body));
      return espaciosList;
      // });
    } else {
      return [
        Reserva(
            id: "1",
            name: "prueba",
            startTime: DateTime.now(),
            endTime: DateTime.now().add(Duration(hours: 1)))
      ];
      // throw Exception('Error al cargar los espacios');
    }
  }

  //TODO: Make this widget syncronous
  List<Widget> buildReservas() {
    List<Widget> reservas = [];
    fetchEspacios().then((value) {
      value.forEach((element) {
        reservas.add(
          ListTile(
            title: Text(element.name),
            subtitle: Text(
                'Inicio: ${element.startTime.toString()} - Fin: ${element.endTime.toString()}'),
          ),
        );
      });
    });
    return reservas;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text('Reservas para el dia: ${selectedDay!.toString()}'),
            ...buildReservas(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
