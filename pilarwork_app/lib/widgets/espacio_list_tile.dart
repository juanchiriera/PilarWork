import 'package:flutter/material.dart';
import 'package:pilarwork_app/model/espacio_model.dart';
import 'package:pilarwork_app/views/calendar_view.dart';

class EspacioListTile extends StatelessWidget {
  const EspacioListTile({
    super.key,
    required this.espacio,
  });

  final Espacio espacio;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title:
          Text(espacio.name, style: Theme.of(context).textTheme.headlineSmall),
      subtitle: Text(
        'Capacidad aproximada: ${espacio.elementos.length} ${espacio.elementos.length == 1 ? 'persona' : 'personas'}',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CalendarDisplay(onDateSelected: (date) {}, espacio: espacio)),
        );
      },
    );
  }
}
