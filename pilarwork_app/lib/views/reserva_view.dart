import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/pages/reserva_page.dart';
import 'package:pilarwork_app/utils/TimeUtils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservaView extends StatelessWidget {
  const ReservaView({
    super.key,
    required this.reserva,
  });

  final Reserva reserva;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            reserva.espacio,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              reserva.titulo.isEmpty ? 'Reserva sin tituloo' : reserva.titulo,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              reserva.descripcion.isEmpty
                  ? 'La reserva no tiene descripcion'
                  : reserva.descripcion,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${TimeUtils.formatTime(reserva.startTime)} - ${TimeUtils.formatTime(reserva.endTime)}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: 150,
              child: SfCalendar(
                view: CalendarView.timelineDay,
                viewNavigationMode: ViewNavigationMode.none,
                timeSlotViewSettings: TimeSlotViewSettings(
                  startHour: 8,
                  endHour: 20,
                  nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday],
                ),
                initialDisplayDate:
                    reserva.startTime.subtract(Duration(hours: 2)),
                headerStyle: CalendarHeaderStyle(
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04 < 16
                        ? MediaQuery.of(context).size.width * 0.04
                        : 16,
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  ),
                ),
                dataSource: MeetingDataSource(reserva),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
