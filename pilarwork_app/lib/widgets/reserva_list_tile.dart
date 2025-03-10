import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/utils/time_utils.dart';
import 'package:pilarwork_app/views/reserva_view.dart';

class ReservaListTile extends StatelessWidget {
  const ReservaListTile({
    super.key,
    required this.reserva,
  });

  final Reserva reserva;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(reserva.titulo.isNotEmpty ? reserva.titulo : reserva.espacio),
      onTap: () => _showReservaDetail(context),
      subtitle: Text(
          '${TimeUtils.formatTime(reserva.startTime)} - ${TimeUtils.formatTime(reserva.endTime)}'),
    );
  }

  void _showReservaDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.2,
            horizontal: 20,
          ),
          child: ReservaView(reserva: reserva),
        );
      },
    );
  }
}