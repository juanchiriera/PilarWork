import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pilarwork_app/model/espacio_model.dart';

class NuevaReservaView extends StatefulWidget {
  final DateTime? date;
  final Espacio espacio;

  const NuevaReservaView(this.date, this.espacio,
      {super.key, required TimeOfDay horaInicio, required TimeOfDay horaFin});

  @override
  State createState() => _NuevaReservaViewState();
}

class _NuevaReservaViewState extends State<NuevaReservaView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _hasConflict = false;
  bool _isPastDate = false;
  bool _hasInvalidRange = false;

  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _startDate = widget.date ?? DateTime.now();
    _endDate = widget.date?.add(Duration(hours: 1)) ??
        DateTime.now().add(Duration(hours: 1));
    _startTime = TimeOfDay.fromDateTime(_startDate!);
    _endTime = TimeOfDay.fromDateTime(_endDate!);
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    if (!endDateTime.isAfter(startDateTime)) {
      setState(() => _hasInvalidRange = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha final debe ser posterior a la fecha inicial'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (startDateTime.isBefore(now)) {
      setState(() => _isPastDate = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pueden seleccionar fechas/horas pasadas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (endDateTime.isBefore(now)) {
      setState(() => _isPastDate = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha/hora final no puede ser en el pasado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_startDate == null ||
        _startTime == null ||
        _endDate == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione las fechas y horas')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/reservas'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'titulo': _titleController.text,
          'descripcion': _descriptionController.text,
          'fechaInicio': startDateTime.toIso8601String(),
          'fechaFin': endDateTime.toIso8601String(),
          'elementos': widget.espacio.elementos,
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

  void _resetErrors() {
    if (_hasConflict || _isPastDate || _hasInvalidRange) {
      setState(() {
        _hasConflict = false;
        _isPastDate = false;
        _hasInvalidRange = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 22.0, right: 22.0, bottom: 8.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Text(
              'Reservar ${widget.espacio.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _titleController,
                decoration:
                    const InputDecoration(labelText: 'Título de mi reserva'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ingrese un título' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'Descripción', disabledBorder: InputBorder.none),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ingrese una descripción' : null,
              ),
            ),
            _DateTimeSection(
              label: 'Fecha de inicio',
              date: _startDate,
              time: _startTime,
              onDatePressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (date != null) setState(() => _startDate = date);
              },
              onTimePressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _startTime ??
                      TimeOfDay.fromDateTime(_startDate ?? DateTime.now()),
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
                  initialDate: _endDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (date != null) setState(() => _endDate = date);
              },
              onTimePressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _endTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  _resetErrors();
                  setState(() => _endTime = time);
                }
              },
            ),
            if (_hasConflict || _isPastDate || _hasInvalidRange)
              _buildErrorMessage(),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                // primary: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _handleSubmit,
              child: Text(
                'Crear Reserva',
                style: TextStyle(color: Theme.of(context).cardColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    String message;
    if (_isPastDate) {
      message = 'No se permiten reservas en fechas pasadas';
    } else if (_hasInvalidRange) {
      message = 'La fecha final debe ser posterior a la inicial';
    } else {
      message = 'El horario seleccionado está ocupado';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 14),
        textAlign: TextAlign.center,
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
                title: Text(
                    time != null ? time!.format(context) : 'Seleccionar hora'),
                onTap: onTimePressed,
                trailing: const Icon(Icons.access_time),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(date != null
                    ? DateFormat('dd/MM/yyyy').format(date!)
                    : 'Seleccionar fecha'),
                onTap: onDatePressed,
                trailing: const Icon(Icons.calendar_today),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
