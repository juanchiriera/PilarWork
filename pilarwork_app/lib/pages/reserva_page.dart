import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/utils/TimeUtils.dart';
import 'package:pilarwork_app/views/reserva_view.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservaPage extends StatelessWidget {
  final Reserva reserva;

  const ReservaPage({super.key, required this.reserva});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reserva'),
      ),
      body: ReservaView(reserva: reserva),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  Reserva reserva;

  MeetingDataSource(this.reserva) {
    appointments = [reserva];
  }

  @override
  DateTime getStartTime(int index) {
    return reserva.startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return reserva.endTime;
  }

  @override
  String getSubject(int index) {
    return "";
  }
}
