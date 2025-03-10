import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/pages/reserva_page.dart';
import 'package:pilarwork_app/utils/time_utils.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

class ReservaView extends StatelessWidget {
  const ReservaView({
    super.key,
    required this.reserva,
  });

  final Reserva reserva;

Future<void> _handleCancel(BuildContext context) async {
  try {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/reservas/${reserva.id}'),
    );

    if (response.statusCode == 200) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context, rootNavigator: true).pop();
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reserva cancelada exitosamente')),
          );
        }
      });
    } else {
      throw Exception('Error al cancelar reserva: ${response.statusCode}');
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}

  void _showCancelationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar cancelación'),
          content:
              const Text('¿Estás seguro de que quieres cancelar esta reserva?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Volver'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
                _handleCancel(context);
              },
              child: const Text('Cancelar reserva'),
            ),
          ],
        );
      },
    );
  }

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cancel_outlined, size: 24),
                label: const Text(
                  'Cancelar Reserva',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showCancelationDialog(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
