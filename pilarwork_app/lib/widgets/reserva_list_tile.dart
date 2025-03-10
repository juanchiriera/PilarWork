import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/pages/reserva_page.dart';
import 'package:pilarwork_app/utils/TimeUtils.dart';
import 'package:pilarwork_app/views/reserva_view.dart';

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
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ReservaPage(reserva: reserva)),
        // );
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.2,
                    horizontal: 20),
                child: ReservaView(reserva: reserva),
              );
            });
      },
      subtitle: Text(
          '${TimeUtils.formatTime(reserva.startTime)} - ${TimeUtils.formatTime(reserva.endTime)}'),
    );
  }
}
