import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/utils/TimeUtils.dart';

class ReservaListTile extends StatelessWidget {
  const ReservaListTile({
    super.key,
    required this.reserva,
  });

  final Reserva reserva;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reserva.espacio),
      subtitle: Text(
          '${TimeUtils.formatTime(reserva.startTime)} - ${TimeUtils.formatTime(reserva.endTime)}'),
    );
  }
}
