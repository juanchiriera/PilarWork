import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pilarwork_app/model/reserva_model.dart';

class ReservaListTile extends StatelessWidget {
  const ReservaListTile({
    super.key,
    required this.reserva,
  });

  final Reserva reserva;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
    return ListTile(
      title: Text(reserva.espacio),
      subtitle: Text(
          '${_formatTime(reserva.startTime)} - ${_formatTime(reserva.endTime)}'),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTime(DateTime time) {
    DateTime gmt3Time = time.toUtc().add(Duration(hours: -3));
    return DateFormat('HH:mm').format(gmt3Time);
  }
}
