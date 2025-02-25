import 'package:flutter/material.dart';
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
    const Center(child: Text('Home')),
    const Center(child: Text('Perfil')),
    const Center(child: Text('Crear Reserva')),
    const Center(child: Text('Espacios')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(110),
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
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage('foto.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Marco Tacchino',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'marcotacchino20@hotmail.com',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '+54 911 1234-5678',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
    return FloatingActionButton.large(
      onPressed: () => setState(() => _currentIndex = 2),
      backgroundColor: Colors.blue,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Crear Reserva', style: TextStyle(fontSize: 14)),
        ],
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
              onPressed: () => setState(() => _currentIndex = 1),
            ),
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
