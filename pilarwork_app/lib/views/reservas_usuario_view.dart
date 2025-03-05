import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pilarwork_app/model/reserva_model.dart';
import 'package:pilarwork_app/widgets/reserva_list_tile.dart';

class ReservasUsuarioView extends StatefulWidget {
  const ReservasUsuarioView({super.key});

  @override
  _ReservasUsuarioViewState createState() => _ReservasUsuarioViewState();
}

class _ReservasUsuarioViewState extends State<ReservasUsuarioView> {
  late Future<List<Reserva>> _reservasFuture;

  @override
  void initState() {
    super.initState();
    _reservasFuture = _fetchReservas();
  }

  Future<List<Reserva>> _fetchReservas() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    var uri = Uri.http('localhost:3000', '/api/reservas', {
      'fechaInicio': firstDayOfMonth.toIso8601String(),
      'fechaFin': lastDayOfMonth.toIso8601String(),
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var reservas = Reserva.fromJsonList(json.decode(response.body));
      return reservas;
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tus reservas'),
      ),
      body: FutureBuilder<List<Reserva>>(
        future: _reservasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aun no tenes ninguna reserva!'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reserva = snapshot.data![index];
                return ReservaListTile(reserva: reserva);
              },
            );
          }
        },
      ),
    );
  }
}
