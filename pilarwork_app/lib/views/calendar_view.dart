import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/espacio_model.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:http/http.dart' as http;
import 'package:pilarwork_app/views/nueva_reserva_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarDisplay extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Espacio espacio;

  const CalendarDisplay(
      {super.key, required this.onDateSelected, required this.espacio});

  @override
  State<CalendarDisplay> createState() => _CalendarDisplayState();
}

class _CalendarDisplayState extends State<CalendarDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona una fecha'),
      ),
      body: FutureBuilder<List<Reserva>>(
        future: _fetchReservas(widget.espacio),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hubo un error al cargar las reservas.'));
          } else {
            return SfCalendar(
              view: CalendarView.workWeek,
              dataSource: ReservationsDataSource(snapshot.data!),
              showCurrentTimeIndicator: true,
              onSelectionChanged: (details) {
                showModalBottomSheet(
                  context: context,
                  enableDrag: true,
                  showDragHandle: true,
                  builder: (BuildContext context) {
                    return NuevaReservaView(details.date, widget.espacio);
                  },
                ).whenComplete(() {
                  setState(() {});
                });
              },
              timeSlotViewSettings: TimeSlotViewSettings(
                startHour: 8,
                endHour: 20,
                nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
              ),
              appointmentBuilder: (context, calendarAppointmentDetails) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).disabledColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'No disponible',
                      style: TextStyle(color: Theme.of(context).cardColor),
                    ),
                  ),
                );
              },
              headerStyle:
                  CalendarHeaderStyle(backgroundColor: Colors.transparent),
            );
          }
        },
      ),
    );
  }

  Future<List<Reserva>> _fetchReservas(Espacio espacio) async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    var uri = Uri.http('localhost:3000', '/api/reservas', {
      'fechaInicio': firstDayOfMonth.toIso8601String(),
      'fechaFin': lastDayOfMonth.toIso8601String(),
      'elementos': espacio.elementos,
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var reservas = Reserva.fromJsonList(json.decode(response.body));
      return reservas;
    } else {
      throw Exception('Failed to load reservations');
    }
  }
}

class ReservationsDataSource extends CalendarDataSource {
  ReservationsDataSource(List<Reserva> reservas) {
    appointments = reservas;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return "No disponible";
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].startTime.hour == 0 &&
        appointments![index].startTime.minute == 0 &&
        appointments![index].endTime.hour == 23 &&
        appointments![index].endTime.minute == 59;
  }
}
