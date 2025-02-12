import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pilarwork_app/model/espacio_model.dart';
import 'package:pilarwork_app/styles/pages/date_picker_page.dart';
import 'package:intl/intl.dart';

class EspaciosPage extends StatefulWidget {
  const EspaciosPage({super.key});

  @override
  EspaciosPageState createState() => EspaciosPageState();
}

class EspaciosPageState extends State<EspaciosPage> {
  List<Espacio> espacios = [];
  DateTime _focusedDay = DateTime.now();
  bool _isRangeSelected = false;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    fetchEspacios().then((data) {
      setState(() {
        espacios = data;
      });
    });
  }

  Future<List<Espacio>> fetchEspacios() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/api/espacios'));
    if (response.statusCode == 200) {
      // setState(() {
      var espaciosList = Espacio.fromJsonList(json.decode(response.body));
      return espaciosList;
      // });
    } else {
      throw Exception('Error al cargar los espacios');
    }
  }

//  void _showCalendarDialog(BuildContext context, String espacioId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               insetPadding: const EdgeInsets.all(10),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width * 0.95,
//                   maxHeight: MediaQuery.of(context).size.height * 0.8,
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       _buildCalendarHeader(setState),
//                       const Divider(),
//                       Expanded(
//                         child: TableCalendar(
//                         firstDay: DateTime.now(),
//                         lastDay: DateTime.now().add(const Duration(days: 365)),
//                         focusedDay: _focusedDay,
//                         selectedDayPredicate: (day) => !_isRangeSelected && _isSameDay(_selectedDay, day),
//                         rangeStartDay: _isRangeSelected ? _rangeStart : null,
//                         rangeEndDay: _isRangeSelected ? _rangeEnd : null,
//                         calendarStyle: CalendarStyle(
//                           selectedDecoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                           ),
//                           rangeHighlightColor: Colors.blue[100]!,
//                           rangeStartDecoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                           ),
//                           rangeEndDecoration: BoxDecoration(
//                             color: Colors.blue,
//                             shape: BoxShape.circle,
//                           ),
//                           withinRangeDecoration: BoxDecoration(
//                             color: Colors.blue[50],
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         onDaySelected: (selectedDay, focusedDay) {
//                           setState(() {
//                             if (_isRangeSelected) {
//                               if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
//                                 _rangeStart = selectedDay;
//                                 _rangeEnd = null;
//                               } else {
//                                 _rangeEnd = selectedDay;
//                               }
//                             } else {
//                               _selectedDay = selectedDay;
//                             }
//                             _focusedDay = focusedDay;
//                           });
//                           },
//                           onPageChanged: (focusedDay) {
//                             setState(() => _focusedDay = focusedDay);
//                           },
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildSelectedDatesPreview(),
//                       const SizedBox(height: 16),
//                       _buildDialogActions(context, espacioId),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

  Widget _buildSelectedDatesPreview() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child:
          _isRangeSelected ? _buildRangePreview() : _buildSingleDatePreview(),
    );
  }

  Widget _buildSingleDatePreview() {
    return Text(
      _selectedDay != null
          ? 'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}'
          : 'Seleccione una fecha',
      style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.w500),
    );
  }

  Widget _buildRangePreview() {
    return Column(
      children: [
        if (_rangeStart != null)
          Text(
            'Desde: ${DateFormat('dd/MM/yyyy').format(_rangeStart!)}',
            style: TextStyle(color: Colors.blue[800]),
          ),
        if (_rangeEnd != null)
          Text(
            'Hasta: ${DateFormat('dd/MM/yyyy').format(_rangeEnd!)}',
            style: TextStyle(color: Colors.blue[800]),
          ),
        if (_rangeStart == null || _rangeEnd == null)
          Text(
            'Seleccione el rango de fechas',
            style: TextStyle(color: Colors.grey[600]),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildDialogActions(BuildContext context, String espacioId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _handleDateConfirmation(context, espacioId),
          child: Text('Confirmar'),
        ),
      ],
    );
  }

  void _handleDateConfirmation(BuildContext context, String espacioId) {
    // Validar selección de fechas
    if (_isRangeSelected) {
      if (_rangeStart == null || _rangeEnd == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione un rango válido')),
        );
        return;
      }

      // Para rangos: usar fechas completas sin hora
      final fechaInicio = DateTime(
        _rangeStart!.year,
        _rangeStart!.month,
        _rangeStart!.day,
      );

      final fechaFin = DateTime(
        _rangeEnd!.year,
        _rangeEnd!.month,
        _rangeEnd!.day,
        23,
        59,
        59,
      );

      Navigator.pop(context);
      _showPersonasDialog(context, espacioId, fechaInicio, fechaFin);
    } else {
      if (_selectedDay == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seleccione una fecha')),
        );
        return;
      }

      // Para fecha única: mostrar selector de hora
      Navigator.pop(context); // Cerrar diálogo de calendario primero
      _showTimeDialog(context, espacioId, _selectedDay!);
    }
  }

  void _showTimeDialog(
      BuildContext context, String espacioId, DateTime selectedDate) async {
    final startController = TextEditingController();
    final endController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar horario'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTimeInputField(
                  label: 'Hora de inicio',
                  controller: startController,
                  example: 'Ej: 09:00',
                ),
                const SizedBox(height: 20),
                _buildTimeInputField(
                  label: 'Hora de fin',
                  controller: endController,
                  example: 'Ej: 17:30',
                ),
                const SizedBox(height: 10),
                Text(
                  'Formato de 24 horas (HH:mm)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, {
                    'start': startController.text,
                    'end': endController.text
                  });
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      final startTime = _parseTime(result['start']);
      final endTime = _parseTime(result['end']);

      if (startTime == null || endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Formato de hora inválido')),
        );
        return;
      }

      if (endTime.hour < startTime.hour ||
          (endTime.hour == startTime.hour &&
              endTime.minute <= startTime.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La hora final debe ser posterior')),
        );
        return;
      }

      final fechaInicio = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startTime.hour,
        startTime.minute,
      );

      final fechaFin = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        endTime.hour,
        endTime.minute,
      );

      _showPersonasDialog(context, espacioId, fechaInicio, fechaFin);
    }
  }

  Widget _buildTimeInputField({
    required String label,
    required TextEditingController controller,
    required String example,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: example,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Campo requerido';
              if (_parseTime(value) == null) return 'Formato inválido';
              return null;
            },
          ),
        ),
      ],
    );
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuestros Espacios'),
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
                    title: Text(espacio.name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DatePickerPage(espacio: espacio)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

void _showPersonasDialog(BuildContext context, String espacioId,
    DateTime fechaInicio, DateTime fechaFin) async {
  final personas = await showDialog<String>(
    context: context,
    builder: (context) {
      String input = '';
      return AlertDialog(
        title: const Text('Quien va a venir'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Nombres separados por comas',
          ),
          onChanged: (value) => input = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, input),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );

  if (personas != null && personas.isNotEmpty && context.mounted) {
    createReserva(
      espacioId,
      fechaInicio,
      fechaFin,
      personas,
      context,
    );
  } else if (personas != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debe ingresar al menos un nombre')),
    );
  }
}

// void _showCalendarDialog(
//     BuildContext context, dynamic espacio, Function(DateTime) onDateSelected) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return CalendarDialog(onDateSelected: onDateSelected);
//     },
//   );
// }

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
