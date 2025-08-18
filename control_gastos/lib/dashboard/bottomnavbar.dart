import 'package:control_gastos/dashboard/screens/principalScreen.dart';
import 'package:control_gastos/dashboard/screens/typeRecurrence.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;


  final List<Widget> screens = [Principalscreen(), RecurrenceTypeScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF13B218),
        elevation: 0,
        title: const Text(
          "Gestor de Gastos",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.access_alarm, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),

      backgroundColor: Color(0xFFE6F7E7),

      body: screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: const Color(0xFF13B218),
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [Icon(Icons.home, size: 30, color: Colors.white)],
      ),
    );
  }
}
