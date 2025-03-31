import 'package:flutter/material.dart';
import 'package:pilarwork_app/pages/login_page.dart';
import 'package:pilarwork_app/views/detalles_usuario_view.dart';
import 'package:pilarwork_app/views/reservas_usuario_view.dart';
import 'package:pilarwork_app/widgets/user_data_bar.dart';
import 'espacios_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Center(child: ReservasUsuarioView()),
    const Center(child: DetallesUsuarioView()),
    const Center(child: Text('Crear Reserva')),
    const Center(child: EspaciosPage()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 158, 158, 158),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
            title: UserDataBar(),
          ),
        ),
      ),
      body: _pages[_currentIndex],
      floatingActionButton: _buildFloatingButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EspaciosPage()),
        );
      },
      backgroundColor: Colors.blue,
      shape: CircleBorder(),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(Icons.event)],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón Home
            IconButton(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            // Botón Perfil
            IconButton(
              icon: Icon(
                Icons.person,
                color: _currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
              onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
            // Botón Espacios
            const SizedBox(width: 40),
            IconButton(
                icon: Icon(
                  Icons.space_dashboard,
                  color: _currentIndex == 3 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EspaciosPage()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
