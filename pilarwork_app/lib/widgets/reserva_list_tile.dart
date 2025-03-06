import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/utils/TimeUtils.dart';

//TODO: Hacer que al tocar una reserva, se abra una vista de detalle (crear la vista de detalle en un archivo nuevo)
// La vista de detalle (reserva_virew.dart) debería mostrar la información de la reserva
// La vista de detalle debería tener un botón para cancelar la reserva, que al tocarlo, debería mostrar un diálogo de confirmación
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
      subtitle: Text(
          '${TimeUtils.formatTime(reserva.startTime)} - ${TimeUtils.formatTime(reserva.endTime)}'),
    );
  }
}
