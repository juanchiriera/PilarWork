import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NuevaReservaView extends StatefulWidget {
  const NuevaReservaView(this.date, {super.key});
  final DateTime? date;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Reserva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un título';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Fecha y hora de inicio'),
                subtitle: Text(_startDate != null && _startTime != null
                    ? '${DateFormat('dd/MM/yyyy').format(_startDate!)} ${_startTime!.format(context)}'
                    : 'Seleccione fecha y hora'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _startDate = pickedDate;
                        _startTime = pickedTime;
                      });
                    }
                  }
                },
              ),
              ListTile(
                title: Text('Fecha y hora de fin'),
                subtitle: Text(_endDate != null && _endTime != null
                    ? '${DateFormat('dd/MM/yyyy').format(_endDate!)} ${_endTime!.format(context)}'
                    : 'Seleccione fecha y hora'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _endDate = pickedDate;
                        _endTime = pickedTime;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process the reservation data
                    // You can send the data to your backend or perform other actions here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reserva creada')),
                    );
                  }
                },
                child: Text('Crear Reserva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
