import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NuevaReservaView extends StatefulWidget {
  final DateTime? date;
  const NuevaReservaView(this.date, {super.key});

  @override
  _NuevaReservaViewState createState() => _NuevaReservaViewState();
}

class _NuevaReservaViewState extends State<NuevaReservaView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_startDate == null || _startTime == null || 
        _endDate == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione las fechas y horas')),
      );
      return;
    }

    final DateTime startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final DateTime endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );
    
    // TODO arreglar los datos enviados al back para crear correctamente la reserva

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/reservas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'fechaInicio': startDateTime.toIso8601String(),
          'fechaFin': endDateTime.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reserva creada exitosamente')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Error en la creación');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error creando reserva')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Reserva')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value?.isEmpty ?? true 
                    ? 'Ingrese un título' 
                    : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value?.isEmpty ?? true 
                    ? 'Ingrese una descripción' 
                    : null,
              ),
              _DateTimeSection(
                label: 'Fecha de inicio',
                date: _startDate,
                time: _startTime,
                onDatePressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (date != null) setState(() => _startDate = date);
                },
                onTimePressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) setState(() => _startTime = time);
                },
              ),
              _DateTimeSection(
                label: 'Fecha de fin',
                date: _endDate,
                time: _endTime,
                onDatePressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (date != null) setState(() => _endDate = date);
                },
                onTimePressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) setState(() => _endTime = time);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Crear Reserva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTimeSection extends StatelessWidget {
  final String label;
  final DateTime? date;
  final TimeOfDay? time;
  final VoidCallback onDatePressed;
  final VoidCallback onTimePressed;

  const _DateTimeSection({
    required this.label,
    required this.date,
    required this.time,
    required this.onDatePressed,
    required this.onTimePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(label, style: Theme.of(context).textTheme.titleMedium),
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Fecha'),
                subtitle: Text(date != null 
                    ? DateFormat('dd/MM/yyyy').format(date!) 
                    : 'Seleccionar fecha'),
                onTap: onDatePressed,
                trailing: const Icon(Icons.calendar_today),
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Hora'),
                subtitle: Text(time != null 
                    ? time!.format(context) 
                    : 'Seleccionar hora'),
                onTap: onTimePressed,
                trailing: const Icon(Icons.access_time),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
