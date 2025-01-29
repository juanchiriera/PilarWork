import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

class EspaciosPage extends StatefulWidget {
  const EspaciosPage({super.key});

  @override
  EspaciosPageState createState() => EspaciosPageState();
}

class EspaciosPageState extends State<EspaciosPage> {
  List<dynamic> espacios = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    fetchEspacios();
  }

  Future<void> fetchEspacios() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/espacios'));
    if (response.statusCode == 200) {
      setState(() {
        espacios = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar los espacios');
    }
  }

  Future<String?> _showPersonasInputDialog(BuildContext context) async {
  String? personas;
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Quien va a venir'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Ingrese los nombres'),
          onChanged: (value) {
            personas = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );
  return personas;
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

 void _showCalendarDialog(BuildContext context, String espacioId) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Selecciona una fecha"),
        content: SizedBox(
          width: double.maxFinite,
          child: TableCalendar(
            firstDay: DateTime.utc(2025, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              final personas = await _showPersonasInputDialog(context);

              if (!mounted) return;

              if (personas == null || personas.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Debe ingresar los nombres de las personas')),
                );
                return;
              }
              final fechaInicio = selectedDay;
              final fechaFin = selectedDay.add(Duration(days: 1)); // Example: 1-day reservation
              createReserva(espacioId, fechaInicio, fechaFin, personas, context); // Pass personas to createReserva

              Navigator.of(context).pop();
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cerrar", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Espacios Disponibles'),
      ),
      body: espacios.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
            itemCount: espacios.length,
            itemBuilder: (context, index) {
              final espacio = espacios[index];
              return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(espacio['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(espacio['description'] ?? 'Sin descripción'),
                onTap: () {
                _showCalendarDialog(context, espacio['_id']);
              },
            ),
          );
        },
      ),
    );
  }
}